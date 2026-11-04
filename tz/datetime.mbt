///|
/// datetime.mbt — NaiveDateTime / Date / CjDuration（chrono_tz-mbt MoonBit 移植）
/// 移植自仓颉 src/base/tz/datetime.cj，集成 core2 core/hinnant.mbt 算法。

///|
/// 秒级时长，用于 NaiveDateTime 的加减运算。
pub struct CjDuration {
  secs : Int64
} derive(Eq, Compare, Debug)

///|
pub extend CjDuration with Eq::{not_equal, equal}

///|
pub extend CjDuration with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend CjDuration with Debug::{to_repr}

///|
/// 由秒数直接构造。
pub fn CjDuration::make(secs : Int64) -> CjDuration {
  CjDuration::{ secs, }
}

///|
/// 构造 `h` 小时的时长。
pub fn CjDuration::hours(h : Int64) -> CjDuration {
  CjDuration::{ secs: h * 3600L, }
}

///|
/// 构造 `m` 分钟的时长。
pub fn CjDuration::minutes(m : Int64) -> CjDuration {
  CjDuration::{ secs: m * 60L, }
}

///|
/// 构造 `s` 秒的时长。
pub fn CjDuration::of_seconds(s : Int64) -> CjDuration {
  CjDuration::{ secs: s, }
}

///|
/// 零时长。
pub fn CjDuration::zero() -> CjDuration {
  CjDuration::{ secs: 0L, }
}

///|
/// 时长加法。
pub fn CjDuration::op_add(self : CjDuration, rhs : CjDuration) -> CjDuration {
  CjDuration::{ secs: self.secs + rhs.secs, }
}

///|
/// 时长减法。
pub fn CjDuration::op_sub(self : CjDuration, rhs : CjDuration) -> CjDuration {
  CjDuration::{ secs: self.secs - rhs.secs, }
}

///|
/// 无时区墙钟时刻（year/month/day/hour/min/sec），不携带任何 UTC 或偏移信息。
pub struct NaiveDateTime {
  year : Int64
  month : Int64
  day : Int64
  hour : Int64
  min : Int64
  sec : Int64
} derive(Eq, Compare, Debug)

///|
pub extend NaiveDateTime with Eq::{not_equal, equal}

///|
pub extend NaiveDateTime with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend NaiveDateTime with Debug::{to_repr}

///|
/// 向负无穷取整的整数除法。
fn floor_div(a : Int64, b : Int64) -> Int64 {
  let q = a / b
  if a % b != 0L && (a < 0L) != (b < 0L) {
    q - 1L
  } else {
    q
  }
}

///|
/// 判断是否闰年。
pub fn NaiveDateTime::is_leap_year(year : Int64) -> Bool {
  (year % 4L == 0L && year % 100L != 0L) || year % 400L == 0L
}

///|
/// 返回某年某月的天数。
pub fn NaiveDateTime::days_in_month(year : Int64, month : Int64) -> Int64 {
  let days : Array[Int64] = [
    31L, 28L, 31L, 30L, 31L, 30L, 31L, 31L, 30L, 31L, 30L, 31L,
  ]
  if month == 2L && NaiveDateTime::is_leap_year(year) {
    29L
  } else if month >= 1L && month <= 12L {
    days[month.to_int() - 1]
  } else {
    0L
  }
}

///|
/// 构造 NaiveDateTime，非法日期/时间用 fail! 抛错（S4 改为 raise TzError）。
pub fn NaiveDateTime::make(
  year : Int64,
  month : Int64,
  day : Int64,
  hour : Int64,
  min : Int64,
  sec : Int64,
) -> NaiveDateTime {
  if month < 1L || month > 12L {
    abort("Invalid month: \{month}")
  }
  let dim = NaiveDateTime::days_in_month(year, month)
  if day < 1L || day > dim {
    abort("Invalid day: \{day} for \{year}-\{month} (max \{dim})")
  }
  if hour < 0L || hour > 23L {
    abort("Invalid hour: \{hour}")
  }
  if min < 0L || min > 59L {
    abort("Invalid minute: \{min}")
  }
  if sec < 0L || sec > 59L {
    abort("Invalid second: \{sec}")
  }
  NaiveDateTime::{ year, month, day, hour, min, sec, }
}

///|
/// 由 Unix 时间戳构造 NaiveDateTime（UTC，Hinnant days→civil 算法）。
pub fn NaiveDateTime::from_timestamp(unix_secs : Int64) -> NaiveDateTime {
  let days = floor_div(unix_secs, 86400L)
  let rem = unix_secs - days * 86400L
  let hour = rem / 3600L
  let min = rem % 3600L / 60L
  let sec = rem % 60L
  let (year, month, day) = @core.civil_from_days(days)
  NaiveDateTime::{ year, month, day, hour, min, sec, }
}

///|
/// 转为 Unix 时间戳（Hinnant civil→days 算法，支持负时间戳）。
pub fn NaiveDateTime::timestamp(self : NaiveDateTime) -> Int64 {
  let days = @core.days_from_civil(self.year, self.month, self.day)
  days * 86400L + self.hour * 3600L + self.min * 60L + self.sec
}

///|
/// 年分量。
pub fn NaiveDateTime::year(self : NaiveDateTime) -> Int64 {
  self.year
}

///|
/// 月分量。
pub fn NaiveDateTime::month(self : NaiveDateTime) -> Int64 {
  self.month
}

///|
/// 日分量。
pub fn NaiveDateTime::day(self : NaiveDateTime) -> Int64 {
  self.day
}

///|
/// 时分量。
pub fn NaiveDateTime::hour(self : NaiveDateTime) -> Int64 {
  self.hour
}

///|
/// 分分量。
pub fn NaiveDateTime::minute(self : NaiveDateTime) -> Int64 {
  self.min
}

///|
/// 秒分量。
pub fn NaiveDateTime::second(self : NaiveDateTime) -> Int64 {
  self.sec
}

///|
/// 星期（0=周日..6=周六）。
pub fn NaiveDateTime::weekday(self : NaiveDateTime) -> Int64 {
  let days = @core.days_from_civil(self.year, self.month, self.day)
  let wd = (days + 4L) % 7L
  (wd + 7L) % 7L
}

///|
/// 年内序日（1..366）。
pub fn NaiveDateTime::ordinal(self : NaiveDateTime) -> Int64 {
  let days = @core.days_from_civil(self.year, self.month, self.day)
  let year_start = @core.days_from_civil(self.year, 1L, 1L)
  days - year_start + 1L
}

///|
/// 加秒数。
pub fn NaiveDateTime::add_seconds(
  self : NaiveDateTime,
  secs : Int64,
) -> NaiveDateTime {
  NaiveDateTime::from_timestamp(self.timestamp() + secs)
}

///|
/// 减秒数。
pub fn NaiveDateTime::sub_seconds(
  self : NaiveDateTime,
  secs : Int64,
) -> NaiveDateTime {
  NaiveDateTime::from_timestamp(self.timestamp() - secs)
}

///|
/// 加天数。
pub fn NaiveDateTime::add_days(
  self : NaiveDateTime,
  days : Int64,
) -> NaiveDateTime {
  NaiveDateTime::add_seconds(self, days * 86400L)
}

///|
/// 格式化为 "YYYY-MM-DDTHH:MM:SS"。
pub fn NaiveDateTime::to_rfc_string(self : NaiveDateTime) -> String {
  let pad4 = fn(n : Int64) -> String {
    let s = n.to_string()
    if s.length() >= 4 {
      s
    } else {
      let mut r = s
      while r.length() < 4 {
        r = "0" + r
      }
      r
    }
  }
  let pad2 = fn(n : Int64) -> String {
    let s = n.to_string()
    if s.length() >= 2 {
      s
    } else {
      "0" + s
    }
  }
  "\{pad4(self.year)}-\{pad2(self.month)}-\{pad2(self.day)}T\{pad2(self.hour)}:\{pad2(self.min)}:\{pad2(self.sec)}"
}

///|
/// 格式化为 "YYYY-MM-DD HH:MM:SS"。
pub fn NaiveDateTime::to_date_time_string(self : NaiveDateTime) -> String {
  let pad4 = fn(n : Int64) -> String {
    let s = n.to_string()
    if s.length() >= 4 {
      s
    } else {
      let mut r = s
      while r.length() < 4 {
        r = "0" + r
      }
      r
    }
  }
  let pad2 = fn(n : Int64) -> String {
    let s = n.to_string()
    if s.length() >= 2 {
      s
    } else {
      "0" + s
    }
  }
  "\{pad4(self.year)}-\{pad2(self.month)}-\{pad2(self.day)} \{pad2(self.hour)}:\{pad2(self.min)}:\{pad2(self.sec)}"
}

///|
/// 仅有年月日的日期，不携带时区信息。
pub struct Date {
  year : Int64
  month : Int64
  day : Int64
} derive(Eq, Compare, Debug)

///|
pub extend Date with Eq::{not_equal, equal}

///|
pub extend Date with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Date with Debug::{to_repr}

///|
/// 构造 Date，非法日期用 fail! 抛错。
pub fn Date::make(year : Int64, month : Int64, day : Int64) -> Date {
  if month < 1L || month > 12L {
    abort("Invalid month: \{month}")
  }
  let dim = NaiveDateTime::days_in_month(year, month)
  if day < 1L || day > dim {
    abort("Invalid day: \{day} for \{year}-\{month}")
  }
  Date::{ year, month, day, }
}

///|
/// 由年 + 年内序日构造 Date。
pub fn Date::from_ordinal(year : Int64, ordinal : Int64) -> Date {
  let year_start = @core.days_from_civil(year, 1L, 1L)
  let days = year_start + ordinal - 1L
  let (y, m, d) = @core.civil_from_days(days)
  Date::{ year: y, month: m, day: d, }
}

///|
/// 年分量。
pub fn Date::year(self : Date) -> Int64 {
  self.year
}

///|
/// 月分量。
pub fn Date::month(self : Date) -> Int64 {
  self.month
}

///|
/// 日分量。
pub fn Date::day(self : Date) -> Int64 {
  self.day
}

///|
/// 转为 NaiveDateTime（时分秒为零）。
pub fn Date::and_hms(
  self : Date,
  h : Int64,
  m : Int64,
  s : Int64,
) -> NaiveDateTime {
  NaiveDateTime::make(self.year, self.month, self.day, h, m, s)
}

///|
/// 星期（0=周日..6=周六）。
pub fn Date::weekday(self : Date) -> Int64 {
  let days = @core.days_from_civil(self.year, self.month, self.day)
  let wd = (days + 4L) % 7L
  (wd + 7L) % 7L
}

///|
/// 年内序日（1..366）。
pub fn Date::ordinal(self : Date) -> Int64 {
  let days = @core.days_from_civil(self.year, self.month, self.day)
  let year_start = @core.days_from_civil(self.year, 1L, 1L)
  days - year_start + 1L
}

///|
/// UTC 瞬时 + 时区偏移（TzOffset），表示一个时区感知的绝对时刻。
pub struct DateTime {
  naive_utc : Int64
  off : TzOffset
} derive(Eq, Debug)

///|
pub extend DateTime with Eq::{not_equal, equal}

///|
pub extend DateTime with Debug::{to_repr}

///|
/// 由 UTC 时间戳和偏移构造。
pub fn DateTime::make(naive_utc : Int64, offset : TzOffset) -> DateTime {
  DateTime::{ naive_utc, off: offset, }
}

///|
/// 返回 UTC 时间戳。
pub fn DateTime::timestamp(self : DateTime) -> Int64 {
  self.naive_utc
}

///|
/// 返回偏移。
pub fn DateTime::offset(self : DateTime) -> TzOffset {
  self.off
}

///|
/// 返回偏移秒数。
pub fn DateTime::offset_sec(self : DateTime) -> Int32 {
  self.off.offset_sec()
}

///|
/// 返回偏移缩写。
pub fn DateTime::abbreviation(self : DateTime) -> String {
  self.off.abbreviation()
}

///|
/// 返回 IANA 时区 ID。
pub fn DateTime::tz_id(self : DateTime) -> String {
  self.off.tz_id()
}

///|
/// 重新绑定到新时区（UTC 瞬时不变，偏移重算）。
pub fn DateTime::with_timezone(self : DateTime, tz : Tz) -> DateTime {
  let naive = NaiveDateTime::from_timestamp(self.naive_utc)
  let off = tz.offset_from_utc_date_time(naive)
  DateTime::{ naive_utc: self.naive_utc, off, }
}

///|
/// 返回本地墙钟时刻（UTC + offset）。
pub fn DateTime::naive_local(self : DateTime) -> NaiveDateTime {
  NaiveDateTime::from_timestamp(
    self.naive_utc + self.off.offset_sec().to_int64(),
  )
}

///|
/// 格式化为 "YYYY-MM-DD HH:MM:SS ABBR"。
pub fn DateTime::to_string(self : DateTime) -> String {
  let local_dt = self.naive_local()
  "\{local_dt.to_date_time_string()} \{self.abbreviation()}"
}

///|
/// 格式化偏移为 ±HH:MM（用于 RFC3339）。
fn format_offset(offset_sec : Int32) -> String {
  let total_min = offset_sec / 60
  let sign = if total_min < 0 { "-" } else { "+" }
  let abs_min = if total_min < 0 { -total_min } else { total_min }
  let h = abs_min / 60
  let m = abs_min % 60
  let pad2 = fn(n : Int32) -> String {
    let s = n.to_string()
    if s.length() >= 2 {
      s
    } else {
      "0" + s
    }
  }
  "\{sign}\{pad2(h)}:\{pad2(m)}"
}

///|
/// 格式化为 RFC3339 "YYYY-MM-DDTHH:MM:SS±HH:MM"。
pub fn DateTime::to_rfc3339(self : DateTime) -> String {
  let local_dt = self.naive_local()
  "\{local_dt.to_rfc_string()}\{format_offset(self.off.offset_sec())}"
}

///|
/// 把本地墙钟 `dt` 解析为 UTC 瞬时，返回 LocalResult[DateTime]。
pub fn Tz::from_local_date_time(
  self : Tz,
  dt : NaiveDateTime,
) -> LocalResult[DateTime] {
  let lr = self.offset_from_local_date_time(dt)
  match lr {
    LocalResult::Single(o) =>
      LocalResult::Single(DateTime::{
        naive_utc: dt.timestamp() - o.offset_sec().to_int64(),
        off: o,
      })
    LocalResult::Ambiguous(a, b) =>
      LocalResult::Ambiguous(
        DateTime::{
          naive_utc: dt.timestamp() - a.offset_sec().to_int64(),
          off: a,
        },
        DateTime::{
          naive_utc: dt.timestamp() - b.offset_sec().to_int64(),
          off: b,
        },
      )
    LocalResult::None => LocalResult::None
  }
}

///|
/// 由 Date + 时分秒 + 时区构造，返回 LocalResult[DateTime]（含 DST 歧义/缺口）。
pub fn Date::and_hms_opt(
  self : Date,
  tz : Tz,
  h : Int64,
  m : Int64,
  s : Int64,
) -> LocalResult[DateTime] {
  let naive = NaiveDateTime::make(self.year, self.month, self.day, h, m, s)
  tz.from_local_date_time(naive)
}

///|
/// 由 Date + 时分秒 + 时区构造，DST 缺口/歧义时 abort。
pub fn Date::and_hms_tz(
  self : Date,
  tz : Tz,
  h : Int64,
  m : Int64,
  s : Int64,
) -> DateTime {
  let naive = NaiveDateTime::make(self.year, self.month, self.day, h, m, s)
  match tz.from_local_date_time(naive) {
    LocalResult::Single(dt) => dt
    _ =>
      abort("Date::and_hms_tz: local time falls in a DST gap or is ambiguous")
  }
}
