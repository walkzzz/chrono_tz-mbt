///|
/// tz_serialize_wbtest.mbt — 序列化白盒测试

///|
test "DateTime to_json UTC" {
  let tz = get_tz("UTC")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  let json = dt.to_json()
  assert_true(json.contains("\"rfc3339\""))
  assert_true(json.contains("\"timestamp\""))
  assert_true(json.contains("\"timezone\":\"UTC\""))
  assert_true(json.contains("\"offset\":0"))
}

///|
test "DateTime to_json Shanghai" {
  let tz = get_tz("Asia/Shanghai")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  let json = dt.to_json()
  assert_true(json.contains("\"timezone\":\"Asia/Shanghai\""))
  assert_true(json.contains("\"offset\":28800"))
}

///|
test "DateTime to_json_compact" {
  let tz = get_tz("Asia/Shanghai")
  let dt = Date::make(2025L, 7L, 15L).and_hms_tz(tz, 12L, 0L, 0L)
  let json = dt.to_json_compact()
  assert_true(json.contains("\"rfc3339\""))
  assert_true(json.contains("\"timezone\""))
  assert_false(json.contains("\"timestamp\""))
}

///|
test "NaiveDateTime to_json" {
  let dt = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  let json = dt.to_json()
  assert_true(json.contains("\"rfc3339\":\"2025-07-15T12:00:00\""))
  assert_true(json.contains("\"timestamp\""))
}

///|
test "DateTime to_json all 597 smoke" {
  let all = Tz::all()
  let d = Date::make(2025L, 6L, 15L)
  for tz in all {
    let dt = d.and_hms_tz(tz, 12L, 0L, 0L)
    let json = dt.to_json()
    assert_true(json.length() > 20)
  }
}
