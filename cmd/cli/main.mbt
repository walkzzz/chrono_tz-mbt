///|
/// chrono-tz CLI — 命令行时区查询工具。
///
/// 用法：
///   chrono-tz list [--prefix <p>]
///   chrono-tz info <timezone> [--time <timestamp>]
///   chrono-tz convert <rfc3339> <to_tz>
///   chrono-tz now <timezone>
///   chrono-tz parse <rfc3339>
///   chrono-tz format <format> <rfc3339>
///   chrono-tz dst <timezone> [--year <year>]
///   chrono-tz search <keyword>
///   chrono-tz diff <tz1> <tz2>
///   chrono-tz repl
///
/// 运行：moon run cmd/cli --target native -- <args>

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
// 辅助
// ============================================================

///|
fn get_tz(name : String) -> @tz.Tz? {
  @tz.Tz::from_str(name)
}

///|
fn make_utc_dt(ts : Int64) -> @tz.DateTime {
  let utc_tz = match @tz.Tz::from_str("UTC") {
    Some(t) => t
    None => abort("internal: UTC not found")
  }
  let naive_utc = @tz.NaiveDateTime::from_timestamp(ts)
  let off = utc_tz.offset_from_utc_date_time(naive_utc)
  @tz.DateTime::make(ts, off)
}

///|
fn usage() -> Unit {
  println("chrono-tz CLI — IANA timezone query tool")
  println("")
  println("Usage:")
  println("  chrono-tz list [--prefix <p>]          List all 597 timezones")
  println("  chrono-tz info <tz> [--time <ts>]      Show offset/abbreviation")
  println("  chrono-tz convert <rfc3339> <to_tz>    Convert timezone")
  println("  chrono-tz now <tz>                     Current time in timezone")
  println("  chrono-tz parse <rfc3339>              Parse RFC3339")
  println("  chrono-tz format <fmt> <rfc3339>       strftime format")
  println("  chrono-tz dst <tz> [--year <y>]        Detect DST transitions")
  println("  chrono-tz search <keyword>            Search timezones")
  println("  chrono-tz diff <tz1> <tz2>            Show time difference")
  println("  chrono-tz repl                         Interactive mode")
  println("")
  println("Examples:")
  println("  chrono-tz list --prefix Asia/")
  println("  chrono-tz now Asia/Shanghai")
  println("  chrono-tz convert 2025-07-15T12:00:00Z Asia/Tokyo")
  println(
    "  chrono-tz format \"%Y-%m-%d %H:%M:%S %Z\" 2025-07-15T12:00:00+08:00",
  )
  println("  chrono-tz search Tokyo")
  println("  chrono-tz diff Asia/Shanghai America/New_York")
}

// ============================================================
// 子命令
// ============================================================

///|
fn cmd_list(args : Array[String]) -> Unit {
  let mut prefix : String? = None
  let mut i = 0
  while i < args.length() {
    if args[i] == "--prefix" && i + 1 < args.length() {
      prefix = Some(args[i + 1])
      i += 2
    } else {
      i += 1
    }
  }
  let all_names = @tz.Tz::all_names()
  let count = match prefix {
    Some(p) => all_names.iter().filter(fn(name) { name.contains(p) }).count()
    None => all_names.length()
  }
  match prefix {
    Some(p) => {
      println("Timezones matching '\{p}' (\{count} found):")
      for name in all_names {
        if name.contains(p) {
          println("  \{name}")
        }
      }
    }
    None => {
      println("All \{count} IANA timezones:")
      for name in all_names {
        println("  \{name}")
      }
    }
  }
}

///|
fn cmd_info(args : Array[String]) -> Unit {
  if args.length() < 1 {
    println("Error: missing <timezone> argument")
    println("Usage: chrono-tz info <timezone> [--time <timestamp>]")
    return
  }
  let tz_name = args[0]
  let tz = match get_tz(tz_name) {
    Some(t) => t
    None => {
      println("Error: unknown timezone '\{tz_name}'")
      return
    }
  }
  let mut ts = current_timestamp()
  let mut i = 1
  while i < args.length() {
    if args[i] == "--time" && i + 1 < args.length() {
      let parsed = @json.parse(args[i + 1]) catch { _ => @json.to_json("") }
      match parsed {
        Number(n, ..) => ts = n.to_int64()
        _ => println("Warning: invalid timestamp, using current time")
      }
      i += 2
    } else {
      i += 1
    }
  }
  let naive = @tz.NaiveDateTime::from_timestamp(ts)
  let off = tz.offset_from_utc_date_time(naive)
  println("Timezone: \{tz_name}")
  println("Timestamp: \{ts}")
  println(
    "Offset: \{off.offset_sec()}s (\{off.offset_sec().to_double() / 3600.0}h)",
  )
  println("Abbreviation: \{off.abbreviation()}")
}

///|
fn cmd_convert(args : Array[String]) -> Unit {
  if args.length() < 2 {
    println("Error: missing arguments")
    println("Usage: chrono-tz convert <rfc3339> <to_tz>")
    return
  }
  let rfc = args[0]
  let to_tz_name = args[1]
  let to_tz = match get_tz(to_tz_name) {
    Some(t) => t
    None => {
      println("Error: unknown target timezone '\{to_tz_name}'")
      return
    }
  }
  match @tz.DateTime::parse_rfc3339(rfc) {
    Some(src_dt) => {
      let ts = src_dt.timestamp()
      let utc_dt = make_utc_dt(ts)
      let target_dt = utc_dt.with_timezone(to_tz)
      println("Source:  \{rfc}")
      println("UTC ts:  \{ts}")
      println("Target:  \{target_dt.to_rfc3339()}")
      println("Offset:  \{target_dt.offset_sec()}s")
      println("Abbr:    \{target_dt.abbreviation()}")
    }
    None => println("Error: failed to parse RFC3339 '\{rfc}'")
  }
}

///|
fn cmd_now(args : Array[String]) -> Unit {
  if args.length() < 1 {
    println("Error: missing <timezone> argument")
    println("Usage: chrono-tz now <timezone>")
    return
  }
  let tz_name = args[0]
  let tz = match get_tz(tz_name) {
    Some(t) => t
    None => {
      println("Error: unknown timezone '\{tz_name}'")
      return
    }
  }
  let ts = current_timestamp()
  let utc_dt = make_utc_dt(ts)
  let local_dt = utc_dt.with_timezone(tz)
  println("Timezone: \{tz_name}")
  println("RFC3339:  \{local_dt.to_rfc3339()}")
  println("Offset:   \{local_dt.offset_sec()}s")
  println("Abbr:     \{local_dt.abbreviation()}")
}

///|
fn cmd_parse(args : Array[String]) -> Unit {
  if args.length() < 1 {
    println("Error: missing <rfc3339> argument")
    println("Usage: chrono-tz parse <rfc3339>")
    return
  }
  let rfc = args[0]
  match @tz.DateTime::parse_rfc3339(rfc) {
    Some(dt) => {
      let local_dt = dt.naive_local()
      println("RFC3339:   \{rfc}")
      println("Timestamp: \{dt.timestamp()}")
      println(
        "Date:      \{local_dt.year()}-\{local_dt.month()}-\{local_dt.day()}",
      )
      println(
        "Time:      \{local_dt.hour()}:\{local_dt.minute()}:\{local_dt.second()}",
      )
      println("Timezone:  \{dt.tz_id()}")
      println("Offset:    \{dt.offset_sec()}s")
      println("Abbr:      \{dt.abbreviation()}")
    }
    None => println("Error: failed to parse '\{rfc}'")
  }
}

///|
fn cmd_format(args : Array[String]) -> Unit {
  if args.length() < 2 {
    println("Error: missing arguments")
    println("Usage: chrono-tz format <format> <rfc3339>")
    return
  }
  let fmt = args[0]
  let rfc = args[1]
  match @tz.DateTime::parse_rfc3339(rfc) {
    Some(dt) => {
      let result = @tz.strftime(fmt, dt)
      println(result)
    }
    None => println("Error: failed to parse '\{rfc}'")
  }
}

///|
fn cmd_dst(args : Array[String]) -> Unit {
  if args.length() < 1 {
    println("Error: missing <timezone> argument")
    println("Usage: chrono-tz dst <timezone> [--year <year>]")
    return
  }
  let tz_name = args[0]
  let tz = match get_tz(tz_name) {
    Some(t) => t
    None => {
      println("Error: unknown timezone '\{tz_name}'")
      return
    }
  }
  let mut year = 2026L
  let mut i = 1
  while i < args.length() {
    if args[i] == "--year" && i + 1 < args.length() {
      let parsed = @json.parse(args[i + 1]) catch { _ => @json.to_json("") }
      match parsed {
        Number(n, ..) => year = n.to_int64()
        _ => ()
      }
      i += 2
    } else {
      i += 1
    }
  }
  println("Timezone: \{tz_name}")
  println("Year: \{year}")
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
      let direction = if diff > 0 { "spring-forward" } else { "fall-back" }
      println("Month \{month}: offset \{off}s (\{direction}, delta=\{diff}s)")
    }
    prev_offset = off
  }
  if !has_dst {
    println("No DST transitions detected.")
  }
}

///|
/// search — 模糊搜索时区名。
fn cmd_search(args : Array[String]) -> Unit {
  if args.length() < 1 {
    println("Error: missing <keyword> argument")
    println("Usage: chrono-tz search <keyword>")
    return
  }
  let keyword = args[0]
  let all_names = @tz.Tz::all_names()
  let matches : Array[String] = []
  for name in all_names {
    if name.contains(keyword) {
      matches.push(name)
    }
  }
  if matches.is_empty() {
    println("No timezones matching '\{keyword}'.")
  } else {
    println("Timezones matching '\{keyword}' (\{matches.length()} found):")
    for name in matches {
      let tz = match @tz.Tz::from_str(name) {
        Some(t) => t
        None => continue
      }
      let naive = @tz.NaiveDateTime::from_timestamp(current_timestamp())
      let off = tz.offset_from_utc_date_time(naive)
      println("  \{name}  (UTC\{format_offset_str(off.offset_sec())})")
    }
  }
}

///|
/// 格式化偏移为 +HH:MM 或 -HH:MM。
fn format_offset_str(offset_sec : Int32) -> String {
  let total_min = offset_sec / 60
  let sign = if total_min < 0 { "-" } else { "+" }
  let abs_min = if total_min < 0 { -total_min } else { total_min }
  let h = abs_min / 60
  let m = abs_min % 60
  let hs = if h < 10 { "0\{h}" } else { "\{h}" }
  let ms = if m < 10 { "0\{m}" } else { "\{m}" }
  "\{sign}\{hs}:\{ms}"
}

///|
/// diff — 显示两个时区的时差。
fn cmd_diff(args : Array[String]) -> Unit {
  if args.length() < 2 {
    println("Error: missing <tz1> <tz2> arguments")
    println("Usage: chrono-tz diff <tz1> <tz2>")
    return
  }
  let tz1 = match get_tz(args[0]) {
    Some(t) => t
    None => {
      println("Error: unknown timezone '\{args[0]}'")
      return
    }
  }
  let tz2 = match get_tz(args[1]) {
    Some(t) => t
    None => {
      println("Error: unknown timezone '\{args[1]}'")
      return
    }
  }
  let ts = current_timestamp()
  let naive = @tz.NaiveDateTime::from_timestamp(ts)
  let off1 = tz1.offset_from_utc_date_time(naive).offset_sec()
  let off2 = tz2.offset_from_utc_date_time(naive).offset_sec()
  let diff = off1 - off2
  let abs_diff = if diff < 0 { -diff } else { diff }
  let h = abs_diff / 3600
  let m = abs_diff % 3600 / 60
  let sign = if diff >= 0 { "ahead" } else { "behind" }
  println("\{args[0]}: UTC\{format_offset_str(off1)}")
  println("\{args[1]}: UTC\{format_offset_str(off2)}")
  println("Difference: \{args[0]} is \{h}h\{m}m \{sign} \{args[1]}")
}

///|
/// repl — 交互式模式。
fn cmd_repl(_args : Array[String]) -> Unit {
  println(
    "chrono-tz interactive mode. Type 'help' for commands, 'quit' to exit.",
  )
  let all_names = @tz.Tz::all_names()
  let mut running = true
  while running {
    println("tz> ")
    let line = read_line()
    if line == "" {
      running = false
    } else {
      let parts = split_spaces(line)
      let cmd = parts[0]
      match cmd {
        "quit" | "exit" => running = false
        "help" =>
          println(
            "Commands: list, now <tz>, convert <rfc3339> <tz>, search <kw>, diff <tz1> <tz2>, quit",
          )
        "list" => {
          println("Total: \{all_names.length()} timezones")
          for name in all_names {
            println("  \{name}")
          }
        }
        "now" =>
          if parts.length() < 2 {
            println("Usage: now <timezone>")
          } else {
            cmd_now([parts[1]])
          }
        "convert" =>
          if parts.length() < 3 {
            println("Usage: convert <rfc3339> <timezone>")
          } else {
            cmd_convert([parts[1], parts[2]])
          }
        "search" =>
          if parts.length() < 2 {
            println("Usage: search <keyword>")
          } else {
            cmd_search([parts[1]])
          }
        "diff" =>
          if parts.length() < 3 {
            println("Usage: diff <tz1> <tz2>")
          } else {
            cmd_diff([parts[1], parts[2]])
          }
        "" => ()
        _ => println("Unknown command: \{cmd}. Type 'help' for commands.")
      }
    }
  }
  println("Goodbye!")
}

///|
/// 按空格分割字符串为数组。
fn split_spaces(s : String) -> Array[String] {
  let result : Array[String] = []
  let mut current = ""
  let chars = s.to_array()
  for c in chars {
    if c == ' ' {
      if current != "" {
        result.push(current)
        current = ""
      }
    } else {
      current = current + c.to_string()
    }
  }
  if current != "" {
    result.push(current)
  }
  if result.is_empty() {
    result.push("")
  }
  result
}

///|
/// 从 stdin 读取一行。
#borrow(buf)
extern "C" fn c_read(fd : Int32, buf : FixedArray[Byte], len~ : Int32) -> Int32 = "read"

///|
fn read_line() -> String {
  let buf : FixedArray[Byte] = FixedArray::make(256, 0)
  let _ = c_read(0, buf, len=256)
  let mut s = ""
  for i in 0..<256 {
    let b = buf[i]
    if b == 10 || b == 0 {
      break
    }
    let c = b.to_int().to_char()
    match c {
      Some(ch) => s = s + ch.to_string()
      None => ()
    }
  }
  s
}

// ============================================================
// 主入口
// ============================================================

///|
fn main {
  let args = @env.args()
  if args.length() < 2 {
    usage()
    return
  }
  let subcommand = args[1]
  let rest : Array[String] = []
  for j in 2..<args.length() {
    rest.push(args[j])
  }
  match subcommand {
    "list" => cmd_list(rest)
    "info" => cmd_info(rest)
    "convert" => cmd_convert(rest)
    "now" => cmd_now(rest)
    "parse" => cmd_parse(rest)
    "format" => cmd_format(rest)
    "dst" => cmd_dst(rest)
    "search" => cmd_search(rest)
    "diff" => cmd_diff(rest)
    "repl" => cmd_repl(rest)
    "--help" => usage()
    "-h" => usage()
    _ => {
      println("Error: unknown subcommand '\{subcommand}'")
      usage()
    }
  }
}
