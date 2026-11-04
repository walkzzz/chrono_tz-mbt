///|
/// Hinnant civil↔days 算法（Howard Hinnant "Date Algorithms"）。
/// 纯整数 O(1)，支持负时间戳（公元前）。见 ADR-003。

///|
/// 将公历日期转换为自 1970-01-01 起的天数。
/// - year: 年（可为负，表示公元前）
/// - month: 月 [1, 12]
/// - day: 日 [1, 31]
/// 返回：天数（1970-01-01 → 0）
pub fn days_from_civil(year : Int64, month : Int64, day : Int64) -> Int64 {
  let y = year - (if month <= 2L { 1L } else { 0L })
  let era = (if y >= 0L { y } else { y - 399L }) / 400L
  let yoe = y - era * 400L
  let doy = (153L * (month + (if month > 2L { -3L } else { 9L })) + 2L) / 5L +
    day -
    1L
  let doe = yoe * 365L + yoe / 4L - yoe / 100L + doy
  era * 146097L + doe - 719468L
}

///|
/// 将自 1970-01-01 起的天数转换为公历日期。
/// - days: 天数（可为负）
/// 返回：(year, month, day)
pub fn civil_from_days(days : Int64) -> (Int64, Int64, Int64) {
  let z = days + 719468L
  let era = (if z >= 0L { z } else { z - 146096L }) / 146097L
  let doe = z - era * 146097L
  let yoe = (doe - doe / 1460L + doe / 36524L - doe / 146096L) / 365L
  let y = yoe + era * 400L
  let doy = doe - (365L * yoe + yoe / 4L - yoe / 100L)
  let mp = (5L * doy + 2L) / 153L
  let d = doy - (153L * mp + 2L) / 5L + 1L
  let m = mp + (if mp < 10L { 3L } else { -9L })
  (y + (if m <= 2L { 1L } else { 0L }), m, d)
}
