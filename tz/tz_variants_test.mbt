///|
/// Tz::from_str 基本解析测试
test "Tz from_str basic" {
  assert_eq(@tz.Tz::from_str("UTC"), Some(@tz.Tz::UTC))
  assert_eq(@tz.Tz::from_str("Asia/Shanghai"), Some(@tz.Tz::Asia__Shanghai))
  assert_eq(
    @tz.Tz::from_str("America/New_York"),
    Some(@tz.Tz::America__New_York),
  )
  assert_eq(@tz.Tz::from_str("Europe/London"), Some(@tz.Tz::Europe__London))
  assert_eq(@tz.Tz::from_str("Africa/Cairo"), Some(@tz.Tz::Africa__Cairo))
  assert_eq(
    @tz.Tz::from_str("Australia/Sydney"),
    Some(@tz.Tz::Australia__Sydney),
  )
  assert_eq(@tz.Tz::from_str("invalid"), None)
  assert_eq(@tz.Tz::from_str(""), None)
}

///|
/// Tz::name 基本测试
test "Tz name basic" {
  assert_eq(@tz.Tz::name(@tz.Tz::UTC), "UTC")
  assert_eq(@tz.Tz::name(@tz.Tz::Asia__Shanghai), "Asia/Shanghai")
  assert_eq(@tz.Tz::name(@tz.Tz::America__New_York), "America/New_York")
  assert_eq(@tz.Tz::name(@tz.Tz::Europe__London), "Europe/London")
}

///|
/// Tz::from_str 与 Tz::name 往返测试（关键时区）
test "Tz from_str name roundtrip" {
  let tzs = [
    @tz.Tz::UTC,
    @tz.Tz::Asia__Shanghai,
    @tz.Tz::Asia__Tokyo,
    @tz.Tz::America__New_York,
    @tz.Tz::America__Los_Angeles,
    @tz.Tz::Europe__London,
    @tz.Tz::Europe__Paris,
    @tz.Tz::Africa__Cairo,
    @tz.Tz::Australia__Sydney,
  ]
  for tz in tzs {
    let name = @tz.Tz::name(tz)
    assert_eq(@tz.Tz::from_str(name), Some(tz))
  }
}

///|
/// 全 597 时区 from_str ↔ name 往返
test "Tz all 597 from_str name roundtrip" {
  let all = @tz.Tz::all()
  assert_eq(all.length(), 597)
  for tz in all {
    let name = @tz.Tz::name(tz)
    assert_eq(@tz.Tz::from_str(name), Some(tz))
  }
}

///|
/// Tz::all_names 与 Tz::all 长度一致且按升序
test "Tz all_names consistent" {
  let names = @tz.Tz::all_names()
  assert_eq(names.length(), 597)
  let all = @tz.Tz::all()
  for i in 0..<597 {
    assert_eq(@tz.Tz::name(all[i]), names[i])
  }
}
