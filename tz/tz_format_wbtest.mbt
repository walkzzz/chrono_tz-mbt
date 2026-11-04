///|
/// tz_format_wbtest.mbt — strftime / strptime / RFC3339 白盒测试

///|
test "strftime %Y %m %d %H %M %S" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 30L, 45L)
  assert_eq(strftime("%Y", dt), "2025")
  assert_eq(strftime("%m", dt), "01")
  assert_eq(strftime("%d", dt), "15")
  assert_eq(strftime("%H", dt), "12")
  assert_eq(strftime("%M", dt), "30")
  assert_eq(strftime("%S", dt), "45")
}

///|
test "strftime %Z %z UTC" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%Z", dt), "UTC")
  assert_eq(strftime("%z", dt), "+0000")
}

///|
test "strftime %Z %z Shanghai" {
  let tz = get_tz("Asia/Shanghai")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%Z", dt), "CST")
  assert_eq(strftime("%z", dt), "+0800")
}

///|
test "strftime %Z %z New_York" {
  let tz = get_tz("America/New_York")
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%Z", dt), "EST")
  assert_eq(strftime("%z", dt), "-0500")
}

///|
test "strftime %A %a weekday" {
  let tz = get_tz("UTC")
  // 2025-01-15 is Wednesday
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%A", dt), "Wednesday")
  assert_eq(strftime("%a", dt), "Wed")
}

///|
test "strftime %B %b month" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%B", dt), "July")
  assert_eq(strftime("%b", dt), "Jul")
}

///|
test "strftime %j ordinal" {
  let tz = get_tz("UTC")
  // January 15 = day 15
  let dt1 = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 0L, 0L, 0L)
  assert_eq(strftime("%j", dt1), "015")
  // February 1 = day 32
  let dt2 = Date::make(2025L, 2L, 1L).and_hms_tz(tz, 0L, 0L, 0L)
  assert_eq(strftime("%j", dt2), "032")
}

///|
test "strftime %% literal" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%%", dt), "%")
}

///|
test "strftime mixed format" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 1L, 15L).and_hms_tz(tz, 12L, 30L, 45L)
  assert_eq(strftime("%Y-%m-%d %H:%M:%S %Z", dt), "2025-01-15 12:30:45 UTC")
}

///|
test "strftime ISO 8601-ish" {
  let tz = get_tz("Asia/Shanghai")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(strftime("%Y-%m-%dT%H:%M:%S%z", dt), "2025-07-15T12:00:00+0800")
}

///|
test "RFC3339 parse Z suffix" {
  let parsed = DateTime::parse_rfc3339("2025-01-15T12:00:00Z")
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.timestamp(), 1736942400L)
  assert_eq(dt.offset_sec(), 0)
}

///|
test "RFC3339 parse +08:00 offset" {
  let parsed = DateTime::parse_rfc3339("2025-01-15T20:00:00+08:00")
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  // 2025-01-15T20:00:00+08:00 = 2025-01-15T12:00:00Z = 1736942400
  assert_eq(dt.timestamp(), 1736942400L)
  assert_eq(dt.offset_sec(), 28800)
}

///|
test "RFC3339 parse -05:00 offset" {
  let parsed = DateTime::parse_rfc3339("2025-01-15T07:00:00-05:00")
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  // 2025-01-15T07:00:00-05:00 = 2025-01-15T12:00:00Z = 1736942400
  assert_eq(dt.timestamp(), 1736942400L)
  assert_eq(dt.offset_sec(), -18000)
}

///|
test "RFC3339 roundtrip UTC" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 30L, 45L)
  let s = dt.to_rfc3339()
  let parsed = DateTime::parse_rfc3339(s)
  assert_true(parsed is Some(_))
  let dt2 = parsed.unwrap()
  assert_eq(dt2.timestamp(), dt.timestamp())
}

///|
test "RFC3339 roundtrip Shanghai" {
  let tz = get_tz("Asia/Shanghai")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 30L, 45L)
  let s = dt.to_rfc3339()
  let parsed = DateTime::parse_rfc3339(s)
  assert_true(parsed is Some(_))
  let dt2 = parsed.unwrap()
  assert_eq(dt2.timestamp(), dt.timestamp())
}

///|
test "RFC3339 parse invalid too short" {
  let parsed = DateTime::parse_rfc3339("2025-01-15")
  assert_true(parsed is None)
}

///|
test "RFC3339 parse invalid no T" {
  let parsed = DateTime::parse_rfc3339("2025-01-15X12:00:00Z")
  assert_true(parsed is None)
}

///|
test "RFC3339 parse lowercase t" {
  let parsed = DateTime::parse_rfc3339("2025-01-15t12:00:00Z")
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.timestamp(), 1736942400L)
}

///|
test "RFC3339 parse space separator" {
  let parsed = DateTime::parse_rfc3339("2025-01-15 12:00:00Z")
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.timestamp(), 1736942400L)
}

///|
test "strptime space format" {
  let tz = get_tz("UTC")
  let parsed = strptime("%Y-%m-%d %H:%M:%S", "2025-01-15 12:00:00", tz)
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.tz_id(), "UTC")
  assert_eq(dt.timestamp(), 1736942400L)
}

///|
test "strptime T format" {
  let tz = get_tz("UTC")
  let parsed = strptime("%Y-%m-%dT%H:%M:%S", "2025-01-15T12:00:00", tz)
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.tz_id(), "UTC")
  assert_eq(dt.timestamp(), 1736942400L)
}

///|
test "strptime Shanghai" {
  let tz = get_tz("Asia/Shanghai")
  let parsed = strptime("%Y-%m-%d %H:%M:%S", "2025-07-15 12:00:00", tz)
  assert_true(parsed is Some(_))
  let dt = parsed.unwrap()
  assert_eq(dt.tz_id(), "Asia/Shanghai")
  assert_eq(dt.offset_sec(), 28800)
}

///|
test "strptime invalid format" {
  let tz = get_tz("UTC")
  let parsed = strptime("%Y/%m/%d", "2025/01/15", tz)
  assert_true(parsed is None)
}

///|
test "strptime invalid input" {
  let tz = get_tz("UTC")
  let parsed = strptime("%Y-%m-%d %H:%M:%S", "2025-01-15", tz)
  assert_true(parsed is None)
}
