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
