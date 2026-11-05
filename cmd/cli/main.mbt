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
  println("")
  println("Examples:")
  println("  chrono-tz list --prefix Asia/")
  println("  chrono-tz now Asia/Shanghai")
  println("  chrono-tz convert 2025-07-15T12:00:00Z Asia/Tokyo")
  println(
    "  chrono-tz format \"%Y-%m-%d %H:%M:%S %Z\" 2025-07-15T12:00:00+08:00",
  )
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
      let local = dt.naive_local()
      println("RFC3339:   \{rfc}")
      println("Timestamp: \{dt.timestamp()}")
      println("Date:      \{local.year()}-\{local.month()}-\{local.day()}")
      println("Time:      \{local.hour()}:\{local.minute()}:\{local.second()}")
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
    "--help" => usage()
    "-h" => usage()
    _ => {
      println("Error: unknown subcommand '\{subcommand}'")
      usage()
    }
  }
}
