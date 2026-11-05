///|
/// datetime_wbtest.mbt — NaiveDateTime / Date / Duration 白盒测试

///|
test "Duration::make + secs" {
  let d = Duration::make(3600L)
  assert_eq(d, Duration::{ secs: 3600L, })
}

///|
test "Duration::hours/minutes/of_seconds/zero" {
  assert_eq(Duration::hours(1L), Duration::make(3600L))
  assert_eq(Duration::minutes(1L), Duration::make(60L))
  assert_eq(Duration::of_seconds(42L), Duration::make(42L))
  assert_eq(Duration::zero(), Duration::make(0L))
}

///|
test "Duration add/sub" {
  let a = Duration::make(100L)
  let b = Duration::make(60L)
  assert_eq(a.op_add(b), Duration::make(160L))
  assert_eq(a.op_sub(b), Duration::make(40L))
}

///|
test "Duration Eq + Compare" {
  let a = Duration::make(100L)
  let b = Duration::make(200L)
  assert_true(a != b)
  assert_true(a < b)
  assert_true(b > a)
  assert_true(a <= a)
  assert_true(b >= a)
}

///|
test "NaiveDateTime::is_leap_year" {
  assert_true(NaiveDateTime::is_leap_year(2000L))
  assert_false(NaiveDateTime::is_leap_year(1900L))
  assert_true(NaiveDateTime::is_leap_year(2024L))
  assert_false(NaiveDateTime::is_leap_year(2023L))
}

///|
test "NaiveDateTime::days_in_month" {
  assert_eq(NaiveDateTime::days_in_month(2024L, 2L), 29L)
  assert_eq(NaiveDateTime::days_in_month(2023L, 2L), 28L)
  assert_eq(NaiveDateTime::days_in_month(2024L, 1L), 31L)
  assert_eq(NaiveDateTime::days_in_month(2024L, 4L), 30L)
  assert_eq(NaiveDateTime::days_in_month(2024L, 12L), 31L)
  assert_eq(NaiveDateTime::days_in_month(2024L, 0L), 0L)
  assert_eq(NaiveDateTime::days_in_month(2024L, 13L), 0L)
}

///|
test "NaiveDateTime::make legal" {
  let dt = NaiveDateTime::make(2025L, 11L, 4L, 12L, 30L, 45L)
  assert_eq(dt.year(), 2025L)
  assert_eq(dt.month(), 11L)
  assert_eq(dt.day(), 4L)
  assert_eq(dt.hour(), 12L)
  assert_eq(dt.minute(), 30L)
  assert_eq(dt.second(), 45L)
}

///|
test "NaiveDateTime::make leap day" {
  let dt = NaiveDateTime::make(2024L, 2L, 29L, 0L, 0L, 0L)
  assert_eq(dt.month(), 2L)
  assert_eq(dt.day(), 29L)
}

///|
test "NaiveDateTime::from_timestamp epoch" {
  let dt = NaiveDateTime::from_timestamp(0L)
  assert_eq(dt.year(), 1970L)
  assert_eq(dt.month(), 1L)
  assert_eq(dt.day(), 1L)
  assert_eq(dt.hour(), 0L)
  assert_eq(dt.minute(), 0L)
  assert_eq(dt.second(), 0L)
}

///|
test "NaiveDateTime::from_timestamp 2025_01_01" {
  let dt = NaiveDateTime::from_timestamp(1735689600L)
  assert_eq(dt.year(), 2025L)
  assert_eq(dt.month(), 1L)
  assert_eq(dt.day(), 1L)
  assert_eq(dt.hour(), 0L)
  assert_eq(dt.minute(), 0L)
  assert_eq(dt.second(), 0L)
}

///|
test "NaiveDateTime::from_timestamp 2000_01_01" {
  let dt = NaiveDateTime::from_timestamp(946684800L)
  assert_eq(dt.year(), 2000L)
  assert_eq(dt.month(), 1L)
  assert_eq(dt.day(), 1L)
}

///|
test "NaiveDateTime::from_timestamp negative" {
  let dt = NaiveDateTime::from_timestamp(-1L)
  assert_eq(dt.year(), 1969L)
  assert_eq(dt.month(), 12L)
  assert_eq(dt.day(), 31L)
  assert_eq(dt.hour(), 23L)
  assert_eq(dt.minute(), 59L)
  assert_eq(dt.second(), 59L)
}

///|
test "NaiveDateTime::timestamp roundtrip" {
  let dt = NaiveDateTime::make(2025L, 6L, 15L, 14L, 30L, 45L)
  let ts = dt.timestamp()
  let dt2 = NaiveDateTime::from_timestamp(ts)
  assert_eq(dt, dt2)
}

///|
test "NaiveDateTime::timestamp known" {
  let epoch = NaiveDateTime::make(1970L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(epoch.timestamp(), 0L)
  let y2025 = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(y2025.timestamp(), 1735689600L)
}

///|
test "NaiveDateTime::timestamp negative" {
  let dt = NaiveDateTime::make(1969L, 12L, 31L, 23L, 59L, 59L)
  assert_eq(dt.timestamp(), -1L)
}

///|
test "NaiveDateTime::weekday" {
  let thursday = NaiveDateTime::make(1970L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(thursday.weekday(), 4L)
  let saturday = NaiveDateTime::make(2000L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(saturday.weekday(), 6L)
  let wednesday = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(wednesday.weekday(), 3L)
  let tuesday = NaiveDateTime::make(2025L, 11L, 4L, 0L, 0L, 0L)
  assert_eq(tuesday.weekday(), 2L)
}

///|
test "NaiveDateTime::ordinal" {
  let jan1 = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(jan1.ordinal(), 1L)
  let dec31_2025 = NaiveDateTime::make(2025L, 12L, 31L, 0L, 0L, 0L)
  assert_eq(dec31_2025.ordinal(), 365L)
  let dec31_2024 = NaiveDateTime::make(2024L, 12L, 31L, 0L, 0L, 0L)
  assert_eq(dec31_2024.ordinal(), 366L)
  let mar1_2024 = NaiveDateTime::make(2024L, 3L, 1L, 0L, 0L, 0L)
  assert_eq(mar1_2024.ordinal(), 61L)
}

///|
test "NaiveDateTime add/sub seconds" {
  let dt = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 0L)
  let next = dt.add_seconds(1L)
  assert_eq(next.second(), 1L)
  let prev = dt.sub_seconds(1L)
  assert_eq(prev.year(), 2024L)
  assert_eq(prev.month(), 12L)
  assert_eq(prev.day(), 31L)
  assert_eq(prev.hour(), 23L)
  assert_eq(prev.minute(), 59L)
  assert_eq(prev.second(), 59L)
}

///|
test "NaiveDateTime add_days" {
  let dt = NaiveDateTime::make(2025L, 1L, 1L, 12L, 0L, 0L)
  let next = dt.add_days(1L)
  assert_eq(next.year(), 2025L)
  assert_eq(next.month(), 1L)
  assert_eq(next.day(), 2L)
  assert_eq(next.hour(), 12L)
  let prev = dt.add_days(-1L)
  assert_eq(prev.year(), 2024L)
  assert_eq(prev.month(), 12L)
  assert_eq(prev.day(), 31L)
}

///|
test "NaiveDateTime to_rfc_string" {
  let dt = NaiveDateTime::make(2025L, 1L, 5L, 9L, 8L, 7L)
  assert_eq(dt.to_rfc_string(), "2025-01-05T09:08:07")
  let dt2 = NaiveDateTime::make(1970L, 1L, 1L, 0L, 0L, 0L)
  assert_eq(dt2.to_rfc_string(), "1970-01-01T00:00:00")
}

///|
test "NaiveDateTime to_date_time_string" {
  let dt = NaiveDateTime::make(2025L, 1L, 5L, 9L, 8L, 7L)
  assert_eq(dt.to_date_time_string(), "2025-01-05 09:08:07")
}

///|
test "NaiveDateTime Eq + Compare" {
  let a = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 0L)
  let b = NaiveDateTime::make(2025L, 1L, 1L, 0L, 0L, 1L)
  assert_true(a < b)
  assert_true(a <= b)
  assert_true(b > a)
  assert_true(a == a)
}

///|
test "Date::make legal" {
  let d = Date::make(2025L, 6L, 15L)
  assert_eq(d.year(), 2025L)
  assert_eq(d.month(), 6L)
  assert_eq(d.day(), 15L)
}

///|
test "Date::from_ordinal" {
  let jan1 = Date::from_ordinal(2025L, 1L)
  assert_eq(jan1, Date::make(2025L, 1L, 1L))
  let dec31 = Date::from_ordinal(2025L, 365L)
  assert_eq(dec31, Date::make(2025L, 12L, 31L))
  let mar1 = Date::from_ordinal(2024L, 61L)
  assert_eq(mar1, Date::make(2024L, 3L, 1L))
}

///|
test "Date::weekday" {
  assert_eq(Date::make(1970L, 1L, 1L).weekday(), 4L)
  assert_eq(Date::make(2025L, 11L, 4L).weekday(), 2L)
}

///|
test "Date::ordinal" {
  assert_eq(Date::make(2025L, 1L, 1L).ordinal(), 1L)
  assert_eq(Date::make(2025L, 12L, 31L).ordinal(), 365L)
  assert_eq(Date::make(2024L, 12L, 31L).ordinal(), 366L)
}

///|
test "Date::and_hms" {
  let d = Date::make(2025L, 1L, 1L)
  let dt = d.and_hms(12L, 30L, 45L)
  assert_eq(dt.year(), 2025L)
  assert_eq(dt.month(), 1L)
  assert_eq(dt.day(), 1L)
  assert_eq(dt.hour(), 12L)
  assert_eq(dt.minute(), 30L)
  assert_eq(dt.second(), 45L)
}

///|
test "Date Eq + Compare" {
  let a = Date::make(2025L, 1L, 1L)
  let b = Date::make(2025L, 1L, 2L)
  assert_true(a < b)
  assert_true(b > a)
  assert_true(a == a)
}
