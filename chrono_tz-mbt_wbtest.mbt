///|
/// 白盒测试 — 验证 tz 包 API 可通过根包依赖访问。
test "tz accessible from root" {
  let tz = @tz.Tz::from_str("UTC")
  assert_true(tz is Some(_))
}

///|
test "tz all 597 timezones" {
  let all = @tz.Tz::all()
  assert_eq(all.length(), 597)
}

///|
test "tz all_names consistency" {
  let names = @tz.Tz::all_names()
  assert_eq(names.length(), 597)
  assert_true(names.contains("UTC"))
  assert_true(names.contains("Asia/Shanghai"))
  assert_true(names.contains("America/New_York"))
  assert_true(names.contains("Europe/London"))
}

///|
test "tz NaiveDateTime epoch" {
  let dt = @tz.NaiveDateTime::from_timestamp(0L)
  assert_eq(dt.year(), 1970L)
  assert_eq(dt.month(), 1L)
  assert_eq(dt.day(), 1L)
  assert_eq(dt.hour(), 0L)
}

///|
test "tz DateTime parse_rfc3339" {
  let dt = @tz.DateTime::parse_rfc3339("2025-07-15T12:00:00Z")
  assert_true(dt is Some(_))
}

///|
test "tz strftime basic" {
  let dt = match @tz.DateTime::parse_rfc3339("2025-07-15T12:00:00Z") {
    Some(d) => d
    None => abort("parse failed")
  }
  assert_eq(@tz.strftime("%Y-%m-%d", dt), "2025-07-15")
}

///|
/// 根包便捷 API smoke tests — 验证委托正确性。
test "root tz_from_str / tz_name" {
  let tz = match tz_from_str("Asia/Shanghai") {
    Some(t) => t
    None => abort("Asia/Shanghai not found")
  }
  assert_eq(tz_name(tz), "Asia/Shanghai")
  assert_true(tz_from_str("Invalid/Zone") is None)
}

///|
test "root offset_from_utc" {
  let tz = tz_from_str("Asia/Shanghai").unwrap()
  // 1970-01-01 UTC, Shanghai = +08:00 = +28800s
  assert_eq(offset_from_utc(tz, 0L), 28800)
  let utc = tz_from_str("UTC").unwrap()
  assert_eq(offset_from_utc(utc, 0L), 0)
}

///|
test "root datetime_from_timestamp / to_rfc3339" {
  let tz = tz_from_str("UTC").unwrap()
  let dt = datetime_from_timestamp(0L, tz)
  assert_eq(to_rfc3339(dt), "1970-01-01T00:00:00+00:00")
}

///|
test "root convert_timezone" {
  let utc = tz_from_str("UTC").unwrap()
  let shanghai = tz_from_str("Asia/Shanghai").unwrap()
  let dt = datetime_from_timestamp(0L, utc)
  let sh_dt = convert_timezone(dt, shanghai)
  assert_eq(sh_dt.offset_sec(), 28800)
  // timestamp 不变
  assert_eq(sh_dt.timestamp(), 0L)
}

///|
test "root parse_rfc3339" {
  let dt = parse_rfc3339("2026-11-05T12:34:56+08:00")
  assert_true(dt is Some(_))
  assert_true(parse_rfc3339("not a date") is None)
}

///|
test "root strftime / strptime roundtrip" {
  let tz = tz_from_str("UTC").unwrap()
  let dt = datetime_from_timestamp(0L, tz)
  assert_eq(strftime("%Y-%m-%d", dt), "1970-01-01")
  let parsed = strptime("%Y-%m-%d-%H-%M-%S", "1970-01-01-00-00-00", tz)
  assert_true(parsed is Some(_))
}

///|
test "root from_local single" {
  let tz = tz_from_str("Asia/Shanghai").unwrap()
  // 2026-01-15 12:00 Shanghai — 非 DST 边界，应 Single
  let naive = @tz.NaiveDateTime::make(2026L, 1L, 15L, 12L, 0L, 0L)
  let result = from_local(tz, naive)
  assert_true(result.is_single())
}

///|
test "root detect_gap non-gap" {
  let tz = tz_from_str("Asia/Shanghai").unwrap()
  // 2026-01-15 12:00 Shanghai — 无 gap
  let naive = @tz.NaiveDateTime::make(2026L, 1L, 15L, 12L, 0L, 0L)
  assert_true(detect_gap(tz, naive) is None)
}

///|
test "root offset_from_local single" {
  let tz = tz_from_str("UTC").unwrap()
  let naive = @tz.NaiveDateTime::make(2026L, 6L, 15L, 12L, 0L, 0L)
  let result = offset_from_local(tz, naive)
  assert_true(result.is_single())
}
