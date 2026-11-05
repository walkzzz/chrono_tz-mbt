///|
/// chrono-tz Agent — DeepSeek AI 聊天助手，集成时区工具。
///
/// 系统提示注入时区库能力 + 当前时间 + 常用时区偏移。
/// 流式输出（SSE）+ 思考过程灰色显示 + 多轮对话。
///
/// 运行：moon run cmd/agent --target native
/// 环境变量：DEEPSEEK_API_KEY / DEEPSEEK_BASE_URL / DEEPSEEK_MODEL

// ============================================================
// C FFI
// ============================================================

///|
extern "C" fn c_time(t : UInt64) -> Int32 = "time"

///|
fn current_timestamp() -> Int64 {
  c_time(0UL).to_int64()
}

// ============================================================
// 配置
// ============================================================

///|
struct Config {
  base_url : String
  api_key : String
  model : String
}

///|
fn env_or(name : String, default : String) -> String {
  match @env.get_env_var(name) {
    Some(v) => v
    None => default
  }
}

///|
fn config_from_env() -> Config {
  {
    base_url: env_or("DEEPSEEK_BASE_URL", "https://api.deepseek.com"),
    api_key: env_or("DEEPSEEK_API_KEY", ""),
    model: env_or("DEEPSEEK_MODEL", "deepseek-v4-pro"),
  }
}

///|
async fn load_dotenv(path~ : String = ".env") -> Unit {
  let content = @fs.read_file(path).text() catch { _ => return }
  for line in content.split("\n") {
    let line = line.trim()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    let pos = match line.find("=") {
      Some(p) => p
      None => continue
    }
    let key = line[:pos].trim().to_owned()
    let value = line[pos + 1:line.length()].trim().to_owned()
    if !key.is_empty() {
      @env.set_env_var(key, value)
    }
  }
}

// ============================================================
// 聊天数据类型
// ============================================================

///|
pub(all) struct ChatMessage {
  role : String
  content : String
} derive(ToJson, FromJson, Debug)

///|
pub extend ChatMessage with @json.ToJson::{to_json}

///|
pub extend ChatMessage with @json.FromJson::{from_json}

///|
pub extend ChatMessage with @debug.Debug::{to_repr}

///|
pub(all) struct ChatRequest {
  model : String
  messages : Array[ChatMessage]
  stream : Bool
} derive(ToJson, Debug)

///|
pub extend ChatRequest with @json.ToJson::{to_json}

///|
pub extend ChatRequest with @debug.Debug::{to_repr}

///|
pub struct StreamDelta {
  content : String?
  reasoning_content : String?
} derive(Debug)

///|
pub extend StreamDelta with @debug.Debug::{to_repr}

///|
pub impl FromJson for StreamDelta with fn from_json(
  json : Json,
  path : @json.JsonPath,
) -> StreamDelta raise @json.JsonDecodeError {
  guard json is Object(map) else {
    raise @json.JsonDecodeError((path, "StreamDelta: expected object"))
  }
  {
    content: nullable_str(map, "content"),
    reasoning_content: nullable_str(map, "reasoning_content"),
  }
}

///|
pub extend StreamDelta with @json.FromJson::{from_json}

///|
fn nullable_str(map : Map[String, Json], key : String) -> String? {
  match map.get(key) {
    None => None
    Some(Null) => None
    Some(String(s)) => Some(s)
    _ => None
  }
}

///|
pub struct StreamChoice {
  delta : StreamDelta
} derive(FromJson, Debug)

///|
pub extend StreamChoice with @debug.Debug::{to_repr}

///|
pub extend StreamChoice with @json.FromJson::{from_json}

///|
pub struct StreamChunk {
  choices : Array[StreamChoice]
} derive(FromJson, Debug)

///|
pub extend StreamChunk with @debug.Debug::{to_repr}

///|
pub extend StreamChunk with @json.FromJson::{from_json}

// ============================================================
// LLM 客户端
// ============================================================

///|
pub suberror HttpError {
  HttpError(Int32, String)
} derive(Debug)

///|
pub extend HttpError with @debug.Debug::{to_repr}

///|
async fn chat_stream(
  config : Config,
  messages : Array[ChatMessage],
  on_reasoning~ : async (String) -> Unit,
  on_content~ : async (String) -> Unit,
) -> Unit {
  let request = { model: config.model, messages, stream: true, }
  let body = request.to_json().stringify()
  let headers = Map([
    (@http.CaseInsensitiveString("Content-Type"), "application/json"),
    (@http.CaseInsensitiveString("Authorization"), "Bearer \{config.api_key}"),
  ])
  let client = @http.post_stream(
    "\{config.base_url}/chat/completions",
    headers~,
  )
  client.write(body)
  let response = client.end_request()
  guard response.code is (200..<300) else {
    raise HttpError(response.code, response.reason)
  }
  for ;; {
    let line = match client.read_until("\n") {
      None => break
      Some(l) => l.trim()
    }
    if line.is_empty() || !line.has_prefix("data:") {
      continue
    }
    let payload = line[5:line.length()].trim()
    if payload == "[DONE]" {
      break
    }
    let chunk : StreamChunk = @json.from_json(@json.parse(payload))
    match chunk.choices {
      [choice, ..] => {
        match choice.delta.reasoning_content {
          Some(r) => if !r.is_empty() { on_reasoning(r) }
          None => ()
        }
        match choice.delta.content {
          Some(c) => if !c.is_empty() { on_content(c) }
          None => ()
        }
      }
      _ => ()
    }
  }
}

// ============================================================
// 时区上下文 — 系统提示
// ============================================================

///|
fn build_system_prompt() -> String {
  let ts = current_timestamp()
  let utc_tz = match @tz.Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  let naive_utc = @tz.NaiveDateTime::from_timestamp(ts)
  let utc_off = utc_tz.offset_from_utc_date_time(naive_utc)
  let utc_dt = @tz.DateTime::make(ts, utc_off)
  let utc_rfc = utc_dt.to_rfc3339()
  let common = [
    "UTC", "Asia/Shanghai", "Asia/Tokyo", "Asia/Kolkata", "Asia/Dubai", "Europe/London",
    "Europe/Paris", "Europe/Moscow", "America/New_York", "America/Chicago", "America/Los_Angeles",
    "America/Sao_Paulo", "Australia/Sydney", "Pacific/Auckland",
  ]
  let lines : Array[String] = []
  for name in common {
    match @tz.Tz::from_str(name) {
      Some(tz) => {
        let dt = utc_dt.with_timezone(tz)
        lines.push(
          "  \{name}: \{dt.to_rfc3339()} (off=\{dt.offset_sec()}s abbr=\{dt.abbreviation()})",
        )
      }
      None => ()
    }
  }
  let table = lines.iter().join("\n")
  let count = @tz.Tz::all_names().length()
  "You are a timezone assistant powered by chrono_tz-mbt (MoonBit, IANA tzdata 2025b, \{count} timezones).\n\nCurrent UTC: \{utc_rfc}\nTimestamp: \{ts}\n\nCurrent time in common timezones:\n\{table}\n\nYou can help with: timezone queries, time conversion, DST detection, RFC3339 parsing, strftime formatting. Answer in the user's language. Be concise."
}

// ============================================================
// 行编辑器
// ============================================================

///|
struct LineEditor {
  chars : Array[Char]
}

///|
fn LineEditor::new() -> LineEditor {
  { chars: [], }
}

///|
fn LineEditor::push(self : LineEditor, c : Char) -> Unit {
  self.chars.push(c)
}

///|
fn LineEditor::backspace(self : LineEditor) -> Bool {
  match self.chars.pop() {
    Some(_) => true
    None => false
  }
}

///|
fn LineEditor::is_empty(self : LineEditor) -> Bool {
  self.chars.is_empty()
}

///|
fn LineEditor::content(self : LineEditor) -> String {
  String::from_array(self.chars)
}

///|
fn LineEditor::clear(self : LineEditor) -> Unit {
  self.chars.clear()
}

// ============================================================
// 聊天循环
// ============================================================

///|
enum StreamOutcome {
  Done(String)
  Interrupted
  Failed(String)
}

///|
async fn main {
  load_dotenv()
  let config = config_from_env()
  if config.api_key.is_empty() {
    println(
      "Error: DEEPSEEK_API_KEY not set. Create .env with DEEPSEEK_API_KEY=sk-xxx",
    )
    return
  }
  let tty = @tty.Tty::stdio()
  tty.with_raw_mode(() => run_chat(tty, config)) catch {
    _ => run_chat_line(tty, config)
  }
}

///|
async fn run_chat(tty : @tty.Tty, config : Config) -> Unit {
  tty.write_string("=== chrono-tz AI Agent ===\r\n")
  tty.write_string("时区助手 · Enter 发送 · Ctrl+C 退出\r\n\r\n")
  let editor = LineEditor::new()
  let history : Array[ChatMessage] = [
    { role: "system", content: build_system_prompt(), },
  ]
  for ;; {
    tty.write_string("你> ")
    match read_line(tty, editor) {
      None => break
      Some(line) => {
        tty.write_string("\r\n")
        editor.clear()
        if line.is_empty() {
          continue
        }
        if line == "quit" || line == "exit" {
          break
        }
        history.push({ role: "user", content: line, })
        tty.write_string("🤖 ")
        match stream_reply(tty, config, history) {
          Done(reply) => {
            history.push({ role: "assistant", content: reply, })
            tty.write_string("\r\n\r\n")
          }
          Interrupted => tty.write_string("\r\n⏹ 已中断\r\n\r\n")
          Failed(msg) => tty.write_string("\r\n❌ \{msg}\r\n\r\n")
        }
      }
    }
  }
  tty.write_string("\r\n👋 再见！\r\n")
}

///|
async fn run_chat_line(tty : @tty.Tty, config : Config) -> Unit {
  tty.write_string("=== chrono-tz AI Agent (行输入) ===\n")
  tty.write_string("时区助手 · Enter 发送 · quit 退出\n\n")
  let history : Array[ChatMessage] = [
    { role: "system", content: build_system_prompt(), },
  ]
  for ;; {
    tty.write_string("你> ")
    match @async/stdio.stdin.read_until("\n") {
      None => break
      Some(line) => {
        let line = line.trim().to_owned()
        if line.is_empty() {
          continue
        }
        if line == "quit" || line == "exit" {
          break
        }
        history.push({ role: "user", content: line, })
        tty.write_string("🤖 ")
        tty.execute([
          @tty.Command::SetForeground(
            @color.Color::Basic(@color.BasicColor::BrightBlack),
          ),
        ])
        let reply = StringBuilder()
        let failed : String? = try {
          chat_stream(config, history, on_reasoning=r => tty.write_string(r), on_content=c => {
            if reply.is_empty() {
              tty.execute([@tty.Command::ResetForeground])
            }
            reply.write_string(c)
            tty.write_string(c)
          })
          None
        } catch {
          err => Some(err.to_string())
        }
        tty.execute([@tty.Command::ResetForeground])
        match failed {
          Some(msg) => tty.write_string("\n❌ \{msg}\n\n")
          None => {
            history.push({ role: "assistant", content: reply.to_string(), })
            tty.write_string("\n\n")
          }
        }
      }
    }
  }
  tty.write_string("👋 再见！\n")
}

///|
async fn stream_reply(
  tty : @tty.Tty,
  config : Config,
  history : Array[ChatMessage],
) -> StreamOutcome {
  let reply = StringBuilder()
  tty.execute([
    @tty.Command::SetForeground(
      @color.Color::Basic(@color.BasicColor::BrightBlack),
    ),
  ])
  let request : async () -> StreamOutcome = () => {
    try {
      chat_stream(config, history, on_reasoning=r => tty.write_string(r), on_content=c => {
        if reply.is_empty() {
          tty.execute([@tty.Command::ResetForeground])
        }
        reply.write_string(c)
        tty.write_string(c)
      })
      Done(reply.to_string())
    } catch {
      err => Failed(err.to_string())
    }
  }
  let interrupt : async () -> StreamOutcome = () => {
    for ;; {
      match tty.read_event() {
        @tty.Event::Input(@input.InputEvent::Key(key)) if key.kind is Press &&
          key.modifiers.ctrl() =>
          match key.code {
            @input.KeyCode::Char('c') => break Interrupted
            _ => ()
          }
        _ => ()
      }
    }
  }
  let outcome = @async.any([request, interrupt])
  tty.execute([@tty.Command::ResetForeground])
  outcome
}

///|
async fn read_line(tty : @tty.Tty, editor : LineEditor) -> String? {
  for ;; {
    match tty.read_event() {
      @tty.Event::Input(@input.InputEvent::Key(key)) if key.kind is Press =>
        if key.modifiers.ctrl() {
          match key.code {
            @input.KeyCode::Char('c' | 'd') => return None
            _ => ()
          }
        } else {
          match key.code {
            @input.KeyCode::Char(c) => {
              editor.push(c)
              tty.write_string(c.to_string())
            }
            @input.KeyCode::Enter => return Some(editor.content())
            @input.KeyCode::Backspace =>
              if editor.backspace() {
                tty.write_string("\u{8} \u{8}")
              }
            _ => ()
          }
        }
      _ => ()
    }
  }
}
