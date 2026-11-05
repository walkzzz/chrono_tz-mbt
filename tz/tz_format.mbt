///|
/// tz_format.mbt — strftime/strptime/RFC3339（chrono_tz-mbt MoonBit 移植）
/// strftime 格式化 + strptime 解析 + RFC3339 format/parse。

///|
/// 星期全名（0=Sunday..6=Saturday）。
let weekday_full : Array[String] = [
  "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
]

///|
/// 星期缩写（0=Sunday..6=Saturday）。
let weekday_abbr : Array[String] = [
  "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
]

///|
/// 月份全名（1-12）。
let month_full : Array[String] = [
  "", "January", "February", "March", "April", "May", "June", "July", "August", "September",
  "October", "November", "December",
]

///|
/// 月份缩写（1-12）。
let month_abbr : Array[String] = [
  "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov",
  "Dec",
]

///|
/// 左补零到指定宽度。
fn pad_zero(n : Int64, width : Int32) -> String {
  let s = n.to_string()
  if s.length() >= width {
    s
  } else {
    let mut r = s
    while r.length() < width {
      r = "0" + r
    }
    r
  }
}

///|
/// 格式化偏移为 ±HHMM（strftime %z 用）。
fn format_offset_hhmm(offset_sec : Int32) -> String {
  let total_min = offset_sec / 60
  let sign = if total_min < 0 { "-" } else { "+" }
  let abs_min = if total_min < 0 { -total_min } else { total_min }
  let h = abs_min / 60
  let m = abs_min % 60
  "\{sign}\{pad_zero(h.to_int64(), 2)}\{pad_zero(m.to_int64(), 2)}"
}

///|
/// strftime：按格式串格式化 DateTime。
/// 支持：%Y %m %d %H %M %S %Z %z %A %a %B %b %j %% 及字面字符。
pub fn strftime(format : String, dt : DateTime) -> String {
  let local_dt = dt.naive_local()
  let mut result = ""
  let chars = format.to_array()
  let n = chars.length()
  let mut i = 0
  while i < n {
    let c = chars[i]
    if c == '%' && i + 1 < n {
      let spec = chars[i + 1]
      let part = match spec {
        'Y' => local_dt.year().to_string()
        'm' => pad_zero(local_dt.month(), 2)
        'd' => pad_zero(local_dt.day(), 2)
        'H' => pad_zero(local_dt.hour(), 2)
        'M' => pad_zero(local_dt.minute(), 2)
        'S' => pad_zero(local_dt.second(), 2)
        'Z' => dt.abbreviation()
        'z' => format_offset_hhmm(dt.offset_sec())
        'A' => weekday_full[local_dt.weekday().to_int()]
        'a' => weekday_abbr[local_dt.weekday().to_int()]
        'B' => month_full[local_dt.month().to_int()]
        'b' => month_abbr[local_dt.month().to_int()]
        'j' => pad_zero(local_dt.ordinal(), 3)
        '%' => "%"
        _ => "\{spec}"
      }
      result = result + part
      i = i + 2
    } else {
      result = result + c.to_string()
      i = i + 1
    }
  }
  result
}

///|

///|
/// 解析十进制数字，返回 (值, 新位置)，失败返回 None。
fn parse_digits(
  s : Array[Char],
  start : Int32,
  count : Int32,
) -> (Int64, Int32)? {
  let mut val = 0L
  let mut i = 0
  while i < count {
    if start + i >= s.length() {
      return None
    }
    let c = s[start + i]
    if c < '0' || c > '9' {
      return None
    }
    val = val * 10L + (c.to_int() - '0'.to_int()).to_int64()
    i = i + 1
  }
  Some((val, start + count))
}

///|
/// 解析十进制数字（Int 索引版），返回 (值, 新位置)，失败返回 None。
fn parse_digits_at(
  s : Array[Char],
  start : Int32,
  count : Int32,
) -> (Int64, Int32)? {
  let mut val = 0L
  let mut i = 0
  while i < count {
    if start + i >= s.length() {
      return None
    }
    let c = s[start + i]
    if c < '0' || c > '9' {
      return None
    }
    val = val * 10L + (c.to_int() - '0'.to_int()).to_int64()
    i = i + 1
  }
  Some((val, start + count))
}

///|
/// 解析连续字母，返回 (字符串, 新位置)，失败返回 None。
fn parse_alpha(s : Array[Char], start : Int32) -> (String, Int32)? {
  if start >= s.length() {
    return None
  }
  let mut buf = ""
  let mut i = start
  while i < s.length() {
    let c = s[i]
    if (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') {
      buf = buf + c.to_string()
      i = i + 1
    } else {
      break
    }
  }
  if buf.length() == 0 {
    None
  } else {
    Some((buf, i))
  }
}

///|
/// 查表匹配名称（大小写敏感），返回索引，失败返回 None。
fn lookup_name(table : Array[String], name : String) -> Int32? {
  let mut i = 0
  while i < table.length() {
    if table[i] == name {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
/// 解析时区偏移 ±HHMM 或 ±HH:MM，返回 (offset_sec, 新位置)，失败返回 None。
fn parse_offset(s : Array[Char], start : Int32) -> (Int32, Int32)? {
  if start >= s.length() {
    return None
  }
  let sign : Int32 = if s[start] == '+' {
    1
  } else if s[start] == '-' {
    -1
  } else {
    return None
  }
  guard parse_digits_at(s, start + 1, 2) is Some((oh, p1)) else { return None }
  let p2 = if p1 < s.length() && s[p1] == ':' { p1 + 1 } else { p1 }
  guard parse_digits_at(s, p2, 2) is Some((om, p3)) else { return None }
  Some((sign * (oh.to_int() * 3600 + om.to_int() * 60), p3))
}

///|
/// RFC3339 解析：`YYYY-MM-DDTHH:MM:SS±HH:MM` 或 `YYYY-MM-DDTHH:MM:SSZ`。
/// 返回 DateTime?（解析失败返回 None，不抛错，ADR-008 查无→T?）。
pub fn DateTime::parse_rfc3339(s : String) -> DateTime? {
  let chars = s.to_array()
  let n = chars.length()
  // 最短格式：YYYY-MM-DDTHH:MM:SSZ = 20 字符
  if n < 20 {
    return None
  }
  // 解析日期时间部分 YYYY-MM-DDTHH:MM:SS
  guard parse_digits(chars, 0, 4) is Some((year, p1)) else { return None }
  if p1 >= n || chars[p1] != '-' {
    return None
  }
  guard parse_digits(chars, p1 + 1, 2) is Some((month, p2)) else { return None }
  if p2 >= n || chars[p2] != '-' {
    return None
  }
  guard parse_digits(chars, p2 + 1, 2) is Some((day, p3)) else { return None }
  if p3 >= n || (chars[p3] != 'T' && chars[p3] != 't' && chars[p3] != ' ') {
    return None
  }
  guard parse_digits(chars, p3 + 1, 2) is Some((hour, p4)) else { return None }
  if p4 >= n || chars[p4] != ':' {
    return None
  }
  guard parse_digits(chars, p4 + 1, 2) is Some((min, p5)) else { return None }
  if p5 >= n || chars[p5] != ':' {
    return None
  }
  guard parse_digits(chars, p5 + 1, 2) is Some((sec, p6)) else { return None }
  // 解析时区后缀：Z 或 ±HH:MM
  let offset_sec : Int32 = if p6 < n && (chars[p6] == 'Z' || chars[p6] == 'z') {
    0
  } else {
    if p6 + 6 > n {
      return None
    }
    let sign : Int32 = if chars[p6] == '+' {
      1
    } else if chars[p6] == '-' {
      -1
    } else {
      return None
    }
    guard parse_digits(chars, p6 + 1, 2) is Some((oh, p7)) else { return None }
    if p7 >= n || chars[p7] != ':' {
      return None
    }
    guard parse_digits(chars, p7 + 1, 2) is Some((om, _)) else { return None }
    sign * (oh.to_int() * 3600 + om.to_int() * 60)
  }
  // 构造 NaiveDateTime（本地墙钟）
  let naive = NaiveDateTime::make(year, month, day, hour, min, sec)
  // UTC 时间戳 = 本地时间戳 - offset
  let utc_ts = naive.timestamp() - offset_sec.to_int64()
  // 查找匹配的时区
  let tz = Tz::from_str("UTC")
  match tz {
    Some(t) => {
      let off_span = @core.FixedTimespan::{ offset: offset_sec, name: "UTC", }
      let off = TzOffset::make(t, off_span)
      Some(DateTime::make(utc_ts, off))
    }
    None => None
  }
}

///|
/// strptime：按格式串解析输入为 DateTime。
/// 支持：%Y(4位年) %m(2位月) %d(2位日) %H(2位时) %M(2位分) %S(2位秒)
///       %y(2位年,00-68→2000s,69-99→1900s) %j(3位年中天数)
///       %B(月份全名) %b(月份缩写) %A(星期全名) %a(星期缩写)
///       %Z(时区缩写,仅消费) %z(偏移±HHMM/±HH:MM,仅消费) %% 及字面字符。
/// 解析失败返回 None（ADR-008 查无→T?）。
pub fn strptime(format : String, input : String, tz : Tz) -> DateTime? {
  let fmt_chars = format.to_array()
  let in_chars = input.to_array()
  let fmt_n = fmt_chars.length()
  let in_n = in_chars.length()
  let mut fi = 0
  let mut ii = 0
  let mut year = 1970L
  let mut month = 1L
  let mut day = 1L
  let mut hour = 0L
  let mut minute = 0L
  let mut second = 0L
  let mut has_yday = false
  while fi < fmt_n {
    let fc = fmt_chars[fi]
    if fc == '%' && fi + 1 < fmt_n {
      let spec = fmt_chars[fi + 1]
      match spec {
        'Y' => {
          guard parse_digits_at(in_chars, ii, 4) is Some((v, np)) else {
            return None
          }
          year = v
          ii = np
        }
        'm' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          month = v
          ii = np
        }
        'd' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          day = v
          ii = np
        }
        'H' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          hour = v
          ii = np
        }
        'M' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          minute = v
          ii = np
        }
        'S' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          second = v
          ii = np
        }
        'y' => {
          guard parse_digits_at(in_chars, ii, 2) is Some((v, np)) else {
            return None
          }
          year = if v <= 68L { 2000L + v } else { 1900L + v }
          ii = np
        }
        'j' => {
          guard parse_digits_at(in_chars, ii, 3) is Some((v, np)) else {
            return None
          }
          day = v
          has_yday = true
          ii = np
        }
        'B' => {
          guard parse_alpha(in_chars, ii) is Some((name, np)) else {
            return None
          }
          guard lookup_name(month_full, name) is Some(m) else { return None }
          month = m.to_int64()
          ii = np
        }
        'b' => {
          guard parse_alpha(in_chars, ii) is Some((name, np)) else {
            return None
          }
          guard lookup_name(month_abbr, name) is Some(m) else { return None }
          month = m.to_int64()
          ii = np
        }
        'A' => {
          guard parse_alpha(in_chars, ii) is Some((name, np)) else {
            return None
          }
          guard lookup_name(weekday_full, name) is Some(_) else { return None }
          ii = np
        }
        'a' => {
          guard parse_alpha(in_chars, ii) is Some((name, np)) else {
            return None
          }
          guard lookup_name(weekday_abbr, name) is Some(_) else { return None }
          ii = np
        }
        'Z' => {
          guard parse_alpha(in_chars, ii) is Some((_, np)) else { return None }
          ii = np
        }
        'z' => {
          guard parse_offset(in_chars, ii) is Some((_, np)) else { return None }
          ii = np
        }
        '%' => {
          if ii >= in_n || in_chars[ii] != '%' {
            return None
          }
          ii = ii + 1
        }
        _ => return None
      }
      fi = fi + 2
    } else {
      if ii >= in_n || in_chars[ii] != fc {
        return None
      }
      ii = ii + 1
      fi = fi + 1
    }
  }
  let naive = if has_yday {
    let d = Date::from_ordinal(year, day)
    NaiveDateTime::make(d.year(), d.month(), d.day(), hour, minute, second)
  } else {
    NaiveDateTime::make(year, month, day, hour, minute, second)
  }
  match tz.from_local_date_time(naive) {
    LocalResult::Single(dt) => Some(dt)
    _ => None
  }
}
