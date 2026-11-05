///|
/// tz_cron.mbt — cron 表达式（5 字段：分 时 日 月 周）

///|
/// 月份名称（小写，jan=1..dec=12）
let cron_month_names : Array[String] = [
  "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec",
]

///|
/// 星期名称（小写，sun=0..sat=6）
let cron_dow_names : Array[String] = [
  "sun", "mon", "tue", "wed", "thu", "fri", "sat",
]

///|
pub struct Cron {
  minutes : Array[Bool] // 60 (0-59)
  hours : Array[Bool] // 24 (0-23)
  doms : Array[Bool] // 32 (1-31)
  months : Array[Bool] // 13 (1-12)
  dows : Array[Bool] // 7 (0-6)
  dom_restricted : Bool // dom 是否非 *
  dow_restricted : Bool // dow 是否非 *
} derive(Debug)

///|
pub extend Cron with Debug::{to_repr}

///|
/// 转小写
fn to_lower(s : String) -> String {
  let mut r = ""
  for c in s {
    if c >= 'A' && c <= 'Z' {
      match (c.to_int() + 32).to_char() {
        Some(ch) => r += ch.to_string()
        None => r += c.to_string()
      }
    } else {
      r += c.to_string()
    }
  }
  r
}

///|
/// 解析整数
fn parse_cron_int(s : String) -> Int32? {
  if s.length() == 0 {
    return None
  }
  let chars = s.to_array()
  let mut result = 0
  let mut i = 0
  while i < chars.length() {
    if chars[i] < '0' || chars[i] > '9' {
      return None
    }
    result = result * 10 + (chars[i].to_int() - 48)
    i += 1
  }
  Some(result)
}

///|
/// 按字符分割字符串
fn split_char(s : String, sep : Char) -> Array[String] {
  let result : Array[String] = []
  let mut word = ""
  for c in s {
    if c == sep {
      result.push(word)
      word = ""
    } else {
      word += c.to_string()
    }
  }
  result.push(word)
  result
}

///|
/// 按空白分割字符串
fn split_ws(s : String) -> Array[String] {
  let result : Array[String] = []
  let chars = s.to_array()
  let n = chars.length()
  let mut i = 0
  while i < n {
    while i < n && (chars[i] == ' ' || chars[i] == '\t') {
      i += 1
    }
    if i >= n {
      break
    }
    let mut word = ""
    while i < n && chars[i] != ' ' && chars[i] != '\t' {
      word += chars[i].to_string()
      i += 1
    }
    result.push(word)
  }
  result
}

///|
/// 解析 cron 单值（数字或名称）
fn parse_cron_value(
  s : String,
  min : Int32,
  max : Int32,
  names : Array[String]?,
) -> Int32? {
  match parse_cron_int(s) {
    Some(n) => if n >= min && n <= max { Some(n) } else { None }
    None =>
      match names {
        Some(tbl) => {
          let lower = to_lower(s)
          for i in 0..<tbl.length() {
            if tbl[i] == lower {
              return Some(i + min)
            }
          }
          None
        }
        None => None
      }
  }
}

///|
/// 解析 cron 字段，返回位集数组
fn parse_cron_field(
  s : String,
  min : Int32,
  max : Int32,
  names : Array[String]?,
) -> Array[Bool]? {
  let bits : Array[Bool] = []
  for _ in 0..<(max + 1) {
    bits.push(false)
  }
  for part in split_char(s, ',') {
    let step_parts = split_char(part, '/')
    let base = step_parts[0]
    let step = if step_parts.length() > 1 {
      match parse_cron_int(step_parts[1]) {
        Some(n) => n
        None => return None
      }
    } else {
      1
    }
    if step <= 0 {
      return None
    }
    let lo_hi : (Int32, Int32)? = if base == "*" {
      Some((min, max))
    } else {
      let range_parts = split_char(base, '-')
      if range_parts.length() == 2 {
        match
          (
            parse_cron_value(range_parts[0], min, max, names),
            parse_cron_value(range_parts[1], min, max, names),
          ) {
          (Some(l), Some(h)) => Some((l, h))
          _ => None
        }
      } else {
        match parse_cron_value(base, min, max, names) {
          Some(v) => Some((v, v))
          None => None
        }
      }
    }
    guard lo_hi is Some((lo, hi)) else { return None }
    if lo < min || hi > max || lo > hi {
      return None
    }
    let mut i = lo
    while i <= hi {
      bits[i] = true
      i += step
    }
  }
  Some(bits)
}

///|
/// 检查位集是否全 true
fn all_true(bits : Array[Bool], min : Int32, max : Int32) -> Bool {
  for i in min..<(max + 1) {
    if !bits[i] {
      return false
    }
  }
  true
}

///|
/// 解析 cron 表达式 "30 9 * * mon-fri" -> Cron?
/// 5 字段：minute(0-59) hour(0-23) day-of-month(1-31) month(1-12) day-of-week(0-6)
/// 支持：* n n-m n-m/s */s a,b,c 及名称（sun-sat, jan-dec）
pub fn Cron::parse(expr : String) -> Cron? {
  let fields = split_ws(expr)
  if fields.length() != 5 {
    return None
  }
  guard parse_cron_field(fields[0], 0, 59, None) is Some(minutes) else {
    return None
  }
  guard parse_cron_field(fields[1], 0, 23, None) is Some(hours) else {
    return None
  }
  guard parse_cron_field(fields[2], 1, 31, None) is Some(doms) else {
    return None
  }
  guard parse_cron_field(fields[3], 1, 12, Some(cron_month_names))
    is Some(months) else {
    return None
  }
  guard parse_cron_field(fields[4], 0, 6, Some(cron_dow_names)) is Some(dows) else {
    return None
  }
  let dom_restricted = !all_true(doms, 1, 31)
  let dow_restricted = !all_true(dows, 0, 6)
  Some(Cron::{
    minutes,
    hours,
    doms,
    months,
    dows,
    dom_restricted,
    dow_restricted,
  })
}

///|
/// 检查 DateTime 是否匹配 cron 表达式。
/// 标准 cron 语义：dom 和 dow 都指定时取 OR，否则取 AND。
pub fn Cron::matches(self : Cron, dt : DateTime) -> Bool {
  let ldt = dt.naive_local()
  let min_ok = self.minutes[ldt.minute().to_int()]
  let hour_ok = self.hours[ldt.hour().to_int()]
  let month_ok = self.months[ldt.month().to_int()]
  let dom_ok = self.doms[ldt.day().to_int()]
  let dow_ok = self.dows[ldt.weekday().to_int()]
  let day_ok = if self.dom_restricted && self.dow_restricted {
    dom_ok || dow_ok
  } else {
    dom_ok && dow_ok
  }
  min_ok && hour_ok && month_ok && day_ok
}

///|
/// 从 dt 之后找下一次匹配时间（逐分钟搜索，最多 366 天）。
/// 返回 DateTime?（未找到返回 None）。
pub fn Cron::next(self : Cron, dt : DateTime) -> DateTime? {
  let tz_id = dt.offset().tz_id()
  guard Tz::from_str(tz_id) is Some(tz) else { return None }
  let span = tz.timespans()
  let start_ts = dt.timestamp() + 60L
  let max_ts = start_ts + 366L * 24L * 60L * 60L
  let mut ts = start_ts
  while ts <= max_ts {
    let i = binary_search(0, span.len(), fn(n) { span.utc_span(n).cmp(ts) })
    let idx = match i {
      Ok(n) => n
      Err(n) => n
    }
    let off = TzOffset::make(tz, span.get(idx))
    let candidate = DateTime::make(ts, off)
    if self.matches(candidate) {
      return Some(candidate)
    }
    ts += 60L
  }
  None
}
