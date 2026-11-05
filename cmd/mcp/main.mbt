///|
/// chrono_tz-mbt MCP 服务器 — stdio JSON-RPC，暴露时区查询工具供大模型调用。
///
/// 协议：MCP 2024-11-05，stdio 传输，JSON-RPC 2.0。
/// 工具：list_timezones / get_offset / convert_time / parse_rfc3339 /
///       format_time / get_current_time / detect_dst。
/// 运行：moon run cmd/mcp --target native

// ============================================================
// C FFI — stdio 读写 + 时间戳
// ============================================================

///|
#borrow(buf)
extern "C" fn read_ffi(
  fd : Int32,
  buf : FixedArray[Byte],
  len~ : Int32,
) -> Int32 = "read"

///|
#borrow(buf)
extern "C" fn write_ffi(fd : Int32, buf : Bytes, len~ : Int32) -> Int32 = "write"

///|
extern "C" fn c_time(t : UInt64) -> Int32 = "time"

///|
fn current_timestamp() -> Int64 {
  c_time(0UL).to_int64()
}

///|
fn write_reply(line : String) -> Unit {
  let data = @utf8.encode(line + "\n")
  ignore(write_ffi(1, data, len=data.length()))
}

// ============================================================
// JSON-RPC 协议
// ============================================================

///|
fn rpc_result(id : Json?, result : Map[String, Json]) -> String {
  let response : Json = Json::object({
    "jsonrpc": Json("2.0"),
    "id": match id {
      Some(value) => value
      None => Json::null()
    },
    "result": Json::object(result),
  })
  response.stringify()
}

///|
fn rpc_error(id : Json?, code : Int32, message : String) -> String {
  let response : Json = Json::object({
    "jsonrpc": Json("2.0"),
    "id": match id {
      Some(value) => value
      None => Json::null()
    },
    "error": Json::object({ "code": Json(code), "message": Json(message) }),
  })
  response.stringify()
}

///|
fn tool_ok(text : String) -> Map[String, Json] {
  {
    "content": Json([Json::object({ "type": Json("text"), "text": Json(text) })]),
    "isError": Json(false),
  }
}

///|
fn tool_error(message : String) -> Map[String, Json] {
  {
    "content": Json([
      Json::object({ "type": Json("text"), "text": Json(message) }),
    ]),
    "isError": Json(true),
  }
}

// ============================================================
// MCP 协议分发
// ============================================================

///|
fn handle_message(request : Json) -> String? {
  let obj = match request {
    Object(obj) => obj
    _ => return Some(rpc_error(None, -32600, "request must be a Json object"))
  }
  let id = obj.get("id")
  let method_name = match obj.get("method") {
    Some(String(m)) => m
    _ => return Some(rpc_error(id, -32600, "missing string 'method' field"))
  }
  match method_name {
    "initialize" => Some(rpc_result(id, initialize_result()))
    "ping" => Some(rpc_result(id, Map([])))
    "tools/list" => Some(rpc_result(id, tools_list()))
    "tools/call" => Some(rpc_result(id, call_tool(obj.get("params"))))
    _ =>
      if method_name.contains("notifications/") {
        None
      } else {
        Some(rpc_error(id, -32601, "method not found: \{method_name}"))
      }
  }
}

///|
fn initialize_result() -> Map[String, Json] {
  {
    "protocolVersion": Json("2024-11-05"),
    "capabilities": Json::object({ "tools": Json::empty_object() }),
    "serverInfo": Json::object({
      "name": Json("chrono-tz-mcp"),
      "version": Json("0.1.0"),
    }),
  }
}

///|
fn handle_line(line : StringView) -> Unit {
  let request = @json.parse(line) catch {
    parse_error => {
      write_reply(rpc_error(None, -32700, "parse error: \{parse_error}"))
      return
    }
  }
  match handle_message(request) {
    Some(response) => write_reply(response)
    None => ()
  }
}

///|
fn drain_messages(pending : String) -> String {
  match pending.find("\n") {
    Some(pos) => {
      let message = pending[0:pos].to_owned().trim()
      if message != "" {
        handle_line(message)
      }
      drain_messages(pending[pos + 1:].to_owned())
    }
    None => {
      let trimmed = pending.trim()
      if trimmed == "" {
        return ""
      }
      let request = @json.parse(trimmed) catch { _ => return pending }
      match handle_message(request) {
        Some(response) => write_reply(response)
        None => ()
      }
      ""
    }
  }
}

// ============================================================
// tools/list — 工具元数据
// ============================================================

///|
fn tools_list() -> Map[String, Json] {
  {
    "tools": Json([
      tool_meta_list_timezones(),
      tool_meta_get_offset(),
      tool_meta_convert_time(),
      tool_meta_parse_rfc3339(),
      tool_meta_format_time(),
      tool_meta_get_current_time(),
      tool_meta_detect_dst(),
    ]),
  }
}

///|
fn tool_meta_list_timezones() -> Json {
  Json::object({
    "name": Json("list_timezones"),
    "description": Json(
      "List all 597 IANA timezone names, optionally filtered by prefix (e.g. 'Asia/', 'Europe/').",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "prefix": Json::object({
          "type": Json("string"),
          "description": Json(
            "Optional prefix filter, e.g. 'Asia/' or 'Europe/'.",
          ),
        }),
      }),
    }),
  })
}

///|
fn tool_meta_get_offset() -> Json {
  Json::object({
    "name": Json("get_offset"),
    "description": Json(
      "Get UTC offset and abbreviation for a timezone at a given Unix timestamp.",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "timezone": Json::object({
          "type": Json("string"),
          "description": Json("IANA timezone name, e.g. 'Asia/Shanghai'."),
        }),
        "timestamp": Json::object({
          "type": Json("number"),
          "description": Json(
            "Unix timestamp in seconds. Defaults to current time if omitted.",
          ),
        }),
      }),
      "required": Json([Json("timezone")]),
    }),
  })
}

///|
fn tool_meta_convert_time() -> Json {
  Json::object({
    "name": Json("convert_time"),
    "description": Json(
      "Parse an RFC3339 datetime and convert it to a target timezone.",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "rfc3339": Json::object({
          "type": Json("string"),
          "description": Json(
            "RFC3339 datetime, e.g. '2025-07-15T12:00:00+08:00'.",
          ),
        }),
        "to_tz": Json::object({
          "type": Json("string"),
          "description": Json("Target IANA timezone name."),
        }),
      }),
      "required": Json([Json("rfc3339"), Json("to_tz")]),
    }),
  })
}

///|
fn tool_meta_parse_rfc3339() -> Json {
  Json::object({
    "name": Json("parse_rfc3339"),
    "description": Json(
      "Parse an RFC3339 datetime string and return its components.",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "rfc3339": Json::object({
          "type": Json("string"),
          "description": Json("RFC3339 datetime string."),
        }),
      }),
      "required": Json([Json("rfc3339")]),
    }),
  })
}

///|
fn tool_meta_format_time() -> Json {
  Json::object({
    "name": Json("format_time"),
    "description": Json(
      "Format an RFC3339 datetime using strftime specifiers: %Y %m %d %H %M %S %Z %z %A %a %B %b %j %%.",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "format": Json::object({
          "type": Json("string"),
          "description": Json(
            "strftime format string, e.g. '%Y-%m-%d %H:%M:%S %Z'.",
          ),
        }),
        "rfc3339": Json::object({
          "type": Json("string"),
          "description": Json("RFC3339 datetime to format."),
        }),
      }),
      "required": Json([Json("format"), Json("rfc3339")]),
    }),
  })
}

///|
fn tool_meta_get_current_time() -> Json {
  Json::object({
    "name": Json("get_current_time"),
    "description": Json("Get the current time in a given timezone as RFC3339."),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "timezone": Json::object({
          "type": Json("string"),
          "description": Json("IANA timezone name."),
        }),
      }),
      "required": Json([Json("timezone")]),
    }),
  })
}

///|
fn tool_meta_detect_dst() -> Json {
  Json::object({
    "name": Json("detect_dst"),
    "description": Json(
      "Detect DST transitions for a timezone in a given year. Returns spring-forward and fall-back dates.",
    ),
    "inputSchema": Json::object({
      "type": Json("object"),
      "properties": Json::object({
        "timezone": Json::object({
          "type": Json("string"),
          "description": Json("IANA timezone name."),
        }),
        "year": Json::object({
          "type": Json("number"),
          "description": Json(
            "Year to check. Defaults to current year if omitted.",
          ),
        }),
      }),
      "required": Json([Json("timezone")]),
    }),
  })
}

// ============================================================
// tools/call — 工具分发
// ============================================================

///|
fn call_tool(params : Json?) -> Map[String, Json] {
  let name : String = match params {
    Some(Object(obj)) =>
      match obj.get("name") {
        Some(String(name)) => name
        _ => return tool_error("missing string `name` in params")
      }
    _ => return tool_error("missing `params` object")
  }
  let arguments : Json = match params {
    Some(Object(obj)) =>
      match obj.get("arguments") {
        Some(arguments) => arguments
        None => Json::empty_object()
      }
    _ => Json::empty_object()
  }
  match name {
    "list_timezones" => tool_list_timezones(arguments)
    "get_offset" => tool_get_offset(arguments)
    "convert_time" => tool_convert_time(arguments)
    "parse_rfc3339" => tool_parse_rfc3339(arguments)
    "format_time" => tool_format_time(arguments)
    "get_current_time" => tool_get_current_time(arguments)
    "detect_dst" => tool_detect_dst(arguments)
    _ => tool_error("unknown tool: \{name}")
  }
}

// ============================================================
// 工具实现
// ============================================================

///|
/// list_timezones — 列出所有 597 时区，可按前缀过滤。
fn tool_list_timezones(args : Json) -> Map[String, Json] {
  let prefix : String? = match args {
    Object(fields) =>
      match fields.get("prefix") {
        Some(String(p)) => Some(p)
        None => None
        _ => return tool_error("`prefix` must be a string")
      }
    _ => None
  }
  let all_names = @tz.Tz::all_names()
  let filtered = match prefix {
    Some(p) => all_names.filter(fn(name) { name.contains(p) })
    None => all_names
  }
  tool_ok(filtered.iter().join("\n"))
}

///|
/// get_offset — 获取时区在指定 UTC 时间戳的偏移。
fn tool_get_offset(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let tz_name : String = match fields.get("timezone") {
    Some(String(name)) => name
    _ => return tool_error("`timezone` must be a string")
  }
  let tz : @tz.Tz = match @tz.Tz::from_str(tz_name) {
    Some(t) => t
    None => return tool_error("unknown timezone: \{tz_name}")
  }
  let ts : Int64 = match fields.get("timestamp") {
    Some(Number(ts, ..)) => ts.to_int64()
    None => current_timestamp()
    _ => return tool_error("`timestamp` must be a number")
  }
  let naive = @tz.NaiveDateTime::from_timestamp(ts)
  let off = tz.offset_from_utc_date_time(naive)
  let offset_sec = off.offset_sec()
  let abbr = off.abbreviation()
  tool_ok(
    "timezone: \{tz_name}\ntimestamp: \{ts}\noffset_sec: \{offset_sec}\nabbreviation: \{abbr}\noffset_hours: \{offset_sec.to_double() / 3600.0}",
  )
}

///|
/// convert_time — 解析 RFC3339 并转换到目标时区。
fn tool_convert_time(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let rfc : String = match fields.get("rfc3339") {
    Some(String(s)) => s
    _ => return tool_error("`rfc3339` must be a string")
  }
  let to_tz_name : String = match fields.get("to_tz") {
    Some(String(name)) => name
    _ => return tool_error("`to_tz` must be a string")
  }
  let to_tz : @tz.Tz = match @tz.Tz::from_str(to_tz_name) {
    Some(t) => t
    None => return tool_error("unknown target timezone: \{to_tz_name}")
  }
  let parsed = @tz.DateTime::parse_rfc3339(rfc)
  let src_dt : @tz.DateTime = match parsed {
    Some(dt) => dt
    None => return tool_error("failed to parse RFC3339: \{rfc}")
  }
  let ts = src_dt.timestamp()
  let utc_tz = match @tz.Tz::from_str("UTC") {
    Some(t) => t
    None => return tool_error("internal: UTC not found")
  }
  let naive_utc = @tz.NaiveDateTime::from_timestamp(ts)
  let utc_off = utc_tz.offset_from_utc_date_time(naive_utc)
  let utc_dt = @tz.DateTime::make(ts, utc_off)
  let target_dt = utc_dt.with_timezone(to_tz)
  tool_ok(
    "source: \{rfc}\nsource_timestamp: \{ts}\ntarget: \{target_dt.to_rfc3339()}\ntarget_offset: \{target_dt.offset_sec()}s\ntarget_abbreviation: \{target_dt.abbreviation()}",
  )
}

///|
/// parse_rfc3339 — 解析 RFC3339 并返回各分量。
fn tool_parse_rfc3339(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let rfc : String = match fields.get("rfc3339") {
    Some(String(s)) => s
    _ => return tool_error("`rfc3339` must be a string")
  }
  let parsed = @tz.DateTime::parse_rfc3339(rfc)
  let dt : @tz.DateTime = match parsed {
    Some(dt) => dt
    None => return tool_error("failed to parse RFC3339: \{rfc}")
  }
  let local = dt.naive_local()
  tool_ok(
    "rfc3339: \{rfc}\ntimestamp: \{dt.timestamp()}\nyear: \{local.year()}\nmonth: \{local.month()}\nday: \{local.day()}\nhour: \{local.hour()}\nminute: \{local.minute()}\nsecond: \{local.second()}\ntimezone: \{dt.tz_id()}\noffset_sec: \{dt.offset_sec()}\nabbreviation: \{dt.abbreviation()}",
  )
}

///|
/// format_time — strftime 格式化。
fn tool_format_time(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let fmt : String = match fields.get("format") {
    Some(String(s)) => s
    _ => return tool_error("`format` must be a string")
  }
  let rfc : String = match fields.get("rfc3339") {
    Some(String(s)) => s
    _ => return tool_error("`rfc3339` must be a string")
  }
  let parsed = @tz.DateTime::parse_rfc3339(rfc)
  let dt : @tz.DateTime = match parsed {
    Some(dt) => dt
    None => return tool_error("failed to parse RFC3339: \{rfc}")
  }
  let formatted = @tz.strftime(fmt, dt)
  tool_ok("format: \{fmt}\ninput: \{rfc}\noutput: \{formatted}")
}

///|
/// get_current_time — 获取指定时区的当前时间。
fn tool_get_current_time(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let tz_name : String = match fields.get("timezone") {
    Some(String(name)) => name
    _ => return tool_error("`timezone` must be a string")
  }
  let tz : @tz.Tz = match @tz.Tz::from_str(tz_name) {
    Some(t) => t
    None => return tool_error("unknown timezone: \{tz_name}")
  }
  let ts = current_timestamp()
  let utc_tz = match @tz.Tz::from_str("UTC") {
    Some(t) => t
    None => return tool_error("internal: UTC not found")
  }
  let naive_utc = @tz.NaiveDateTime::from_timestamp(ts)
  let utc_off = utc_tz.offset_from_utc_date_time(naive_utc)
  let utc_dt = @tz.DateTime::make(ts, utc_off)
  let local_dt = utc_dt.with_timezone(tz)
  tool_ok(
    "timezone: \{tz_name}\nunix_timestamp: \{ts}\nrfc3339: \{local_dt.to_rfc3339()}\noffset_sec: \{local_dt.offset_sec()}\nabbreviation: \{local_dt.abbreviation()}",
  )
}

///|
/// detect_dst — 检测指定时区在指定年份的 DST 转换。
fn tool_detect_dst(args : Json) -> Map[String, Json] {
  let fields : Map[String, Json] = match args {
    Object(fields) => fields
    _ => return tool_error("`arguments` must be a JSON object")
  }
  let tz_name : String = match fields.get("timezone") {
    Some(String(name)) => name
    _ => return tool_error("`timezone` must be a string")
  }
  let tz : @tz.Tz = match @tz.Tz::from_str(tz_name) {
    Some(t) => t
    None => return tool_error("unknown timezone: \{tz_name}")
  }
  let year : Int64 = match fields.get("year") {
    Some(Number(y, ..)) => y.to_int64()
    None => 2026L
    _ => return tool_error("`year` must be a number")
  }
  // 逐月比较 offset，检测 DST 转换
  let lines : Array[String] = ["timezone: \{tz_name}", "year: \{year}"]
  let mut prev_offset = 0
  let mut has_dst = false
  for month in 1..<13 {
    let naive = @tz.NaiveDateTime::make(
      year,
      month.to_int64(),
      15L,
      12L,
      0L,
      0L,
    )
    let off = tz.offset_from_utc_date_time(naive).offset_sec()
    if month > 1 && off != prev_offset {
      has_dst = true
      let diff = off - prev_offset
      let direction = if diff > 0 {
        "spring-forward (+\{diff}s)"
      } else {
        "fall-back (\{diff}s)"
      }
      lines.push("month \{month}: offset \{off}s (\{direction})")
    }
    prev_offset = off
  }
  if !has_dst {
    lines.push("No DST transitions detected.")
  }
  tool_ok(lines.iter().join("\n"))
}

// ============================================================
// 主入口
// ============================================================

///|
fn main {
  serve()
}

///|
fn serve() -> Unit {
  let mut pending : String = ""
  let buf = FixedArray::make(4096, b'\x00')
  while true {
    let n = read_ffi(0, buf, len=4096)
    if n == 0 {
      break
    }
    pending = pending + @utf8.decode_lossy(Bytes::from_array(buf[0:n]))
    pending = drain_messages(pending)
  }
  pending = drain_messages(pending)
}
