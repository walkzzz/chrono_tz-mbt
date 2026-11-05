///|
/// tz_rfc2822.mbt — RFC2822 + HTTP date 格式化/解析

///|
/// 格式化为 RFC2822 "Wed, 1 Jan 2026 00:00:00 +0000"。
pub fn DateTime::to_rfc2822(self : DateTime) -> String {
  let ldt = self.naive_local()
  let wd = ldt.weekday().to_int()
  "\{weekday_abbr[wd]}, \{ldt.day().to_string()} \{month_abbr[ldt.month().to_int()]} \{ldt.year().to_string()} \{pad_zero(ldt.hour(), 2)}:\{pad_zero(ldt.minute(), 2)}:\{pad_zero(ldt.second(), 2)} \{format_offset_hhmm(self.off.offset_sec())}"
}

///|
/// 格式化为 HTTP date "Wed, 01 Jan 2026 00:00:00 GMT"（RFC 7231 IMF-fixdate）。
pub fn DateTime::to_http_date(self : DateTime) -> String {
  let ldt = self.naive_local()
  let wd = ldt.weekday().to_int()
  "\{weekday_abbr[wd]}, \{pad_zero(ldt.day(), 2)} \{month_abbr[ldt.month().to_int()]} \{ldt.year().to_string()} \{pad_zero(ldt.hour(), 2)}:\{pad_zero(ldt.minute(), 2)}:\{pad_zero(ldt.second(), 2)} GMT"
}

///|
/// 跳过空格，返回新位置。
fn skip_ws(chars : Array[Char], p : Int32, n : Int32) -> Int32 {
  let mut i = p
  while i < n && chars[i] == ' ' {
    i += 1
  }
  i
}

///|
/// 解析 1-2 位数字，返回 (值, 新位置)。
fn parse_1_2_digits(
  chars : Array[Char],
  p : Int32,
  n : Int32,
) -> (Int64, Int32)? {
  if p >= n || chars[p] < '0' || chars[p] > '9' {
    return None
  }
  let d1 = (chars[p].to_int() - 48).to_int64()
  let p1 = p + 1
  if p1 < n && chars[p1] >= '0' && chars[p1] <= '9' {
    let d2 = (chars[p1].to_int() - 48).to_int64()
    Some((d1 * 10L + d2, p1 + 1))
  } else {
    Some((d1, p1))
  }
}

///|
/// 解析月份缩写（Jan..Dec），返回 (月份1-12, 新位置)。
fn parse_month_abbr_2822(
  chars : Array[Char],
  p : Int32,
  n : Int32,
) -> (Int64, Int32)? {
  if p + 3 > n {
    return None
  }
  let s = "\{chars[p]}\{chars[p + 1]}\{chars[p + 2]}"
  for i in 1..<13 {
    if month_abbr[i] == s {
      return Some((i.to_int64(), p + 3))
    }
  }
  None
}

///|
/// 判断字符是否字母
fn is_alpha_char(c : Char) -> Bool {
  (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
}

///|
/// 解析 RFC2822 日期时间，如 "Tue, 1 Jul 2003 10:52:37 +0200"。
/// 也接受无 weekday 形式 "1 Jul 2003 10:52:37 +0200"。
/// 返回 DateTime?（解析失败返回 None）。
pub fn DateTime::parse_rfc2822(s : String) -> DateTime? {
  let chars = s.to_array()
  let n = chars.length()
  let mut p : Int32 = 0
  p = skip_ws(chars, p, n)
  // 跳过可选 weekday + ", "
  if p + 4 < n &&
    is_alpha_char(chars[p]) &&
    is_alpha_char(chars[p + 1]) &&
    is_alpha_char(chars[p + 2]) &&
    chars[p + 3] == ',' {
    p = skip_ws(chars, p + 4, n)
  }
  // 解析 day (1-2 位)
  guard parse_1_2_digits(chars, p, n) is Some((day, p1)) else { return None }
  p = skip_ws(chars, p1, n)
  // 解析 month (3 字母)
  guard parse_month_abbr_2822(chars, p, n) is Some((month, p2)) else {
    return None
  }
  p = skip_ws(chars, p2, n)
  // 解析 year (4 位)
  guard parse_digits(chars, p, 4) is Some((year, p3)) else { return None }
  p = skip_ws(chars, p3, n)
  // 解析 HH:MM:SS
  guard parse_digits(chars, p, 2) is Some((hour, p4)) else { return None }
  if p4 >= n || chars[p4] != ':' {
    return None
  }
  guard parse_digits(chars, p4 + 1, 2) is Some((min, p5)) else { return None }
  if p5 >= n || chars[p5] != ':' {
    return None
  }
  guard parse_digits(chars, p5 + 1, 2) is Some((sec, p6)) else { return None }
  p = skip_ws(chars, p6, n)
  // 解析偏移：GMT/UTC/UT 或 ±HHMM
  let offset_sec : Int32 = if p < n && (chars[p] == 'G' || chars[p] == 'g') {
    0
  } else if p < n && (chars[p] == 'U' || chars[p] == 'u') {
    0
  } else if p < n && (chars[p] == '+' || chars[p] == '-') {
    let sign : Int32 = if chars[p] == '+' { 1 } else { -1 }
    guard parse_digits(chars, p + 1, 2) is Some((oh, p7)) else { return None }
    guard parse_digits(chars, p7, 2) is Some((om, _)) else { return None }
    sign * (oh.to_int() * 3600 + om.to_int() * 60)
  } else {
    return None
  }
  // 构造 DateTime
  let naive = NaiveDateTime::make(year, month, day, hour, min, sec)
  let utc_ts = naive.timestamp() - offset_sec.to_int64()
  guard Tz::from_str("UTC") is Some(t) else { return None }
  let off_span = @core.FixedTimespan::{ offset: offset_sec, name: "UTC", }
  let off = TzOffset::make(t, off_span)
  Some(DateTime::make(utc_ts, off))
}

///|
/// 解析 HTTP date "Wed, 15 Nov 1994 12:45:26 GMT"（RFC 7231）。
/// 返回 DateTime?（解析失败返回 None）。
pub fn DateTime::parse_http_date(s : String) -> DateTime? {
  DateTime::parse_rfc2822(s)
}
