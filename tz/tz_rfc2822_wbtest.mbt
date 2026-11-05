///|
/// tz_rfc2822_wbtest.mbt — RFC2822 + HTTP date 白盒测试

///|
fn make_utc_dt(
  year : Int64,
  month : Int64,
  day : Int64,
  h : Int64,
  m : Int64,
  s : Int64,
) -> DateTime {
  let tz = match Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  Date::make(year, month, day).and_hms_tz(tz, h, m, s)
}

///|
test "to_rfc2822 UTC" {
  let dt = make_utc_dt(2003L, 7L, 1L, 10L, 52L, 37L)
  assert_eq(dt.to_rfc2822(), "Tue, 1 Jul 2003 10:52:37 +0000")
}

///|
test "to_rfc2822 带偏移" {
  let tz = match Tz::from_str("Asia/Shanghai") {
    Some(t) => t
    None => abort("not found")
  }
  let dt = Date::make(2026L, 1L, 1L).and_hms_tz(tz, 8L, 0L, 0L)
  assert_eq(dt.to_rfc2822(), "Thu, 1 Jan 2026 08:00:00 +0800")
}

///|
test "parse_rfc2822 基本" {
  guard DateTime::parse_rfc2822("Tue, 1 Jul 2003 10:52:37 +0200") is Some(dt) else {
    assert_true(false)
    return
  }
  let ldt = dt.naive_local()
  assert_eq(ldt.year(), 2003L)
  assert_eq(ldt.month(), 7L)
  assert_eq(ldt.day(), 1L)
  assert_eq(ldt.hour(), 10L)
  assert_eq(ldt.minute(), 52L)
  assert_eq(ldt.second(), 37L)
}

///|
test "parse_rfc2822 无 weekday" {
  guard DateTime::parse_rfc2822("1 Jul 2003 10:52:37 +0200") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "parse_rfc2822 GMT" {
  guard DateTime::parse_rfc2822("Tue, 15 Nov 1994 12:45:26 GMT") is Some(dt) else {
    assert_true(false)
    return
  }
  let ldt = dt.naive_local()
  assert_eq(ldt.year(), 1994L)
  assert_eq(ldt.month(), 11L)
  assert_eq(ldt.day(), 15L)
  assert_eq(ldt.hour(), 12L)
}

///|
test "parse_rfc2822 往返" {
  let dt = make_utc_dt(2026L, 6L, 15L, 14L, 30L, 45L)
  let s = dt.to_rfc2822()
  guard DateTime::parse_rfc2822(s) is Some(dt2) else {
    assert_true(false)
    return
  }
  assert_eq(dt2.timestamp(), dt.timestamp())
}

///|
test "to_http_date" {
  let dt = make_utc_dt(1994L, 11L, 15L, 12L, 45L, 26L)
  assert_eq(dt.to_http_date(), "Tue, 15 Nov 1994 12:45:26 GMT")
}

///|
test "to_http_date 补零" {
  let dt = make_utc_dt(2026L, 1L, 5L, 9L, 8L, 7L)
  assert_eq(dt.to_http_date(), "Mon, 05 Jan 2026 09:08:07 GMT")
}

///|
test "parse_http_date" {
  guard DateTime::parse_http_date("Tue, 15 Nov 1994 12:45:26 GMT") is Some(dt) else {
    assert_true(false)
    return
  }
  let ldt = dt.naive_local()
  assert_eq(ldt.year(), 1994L)
  assert_eq(ldt.month(), 11L)
  assert_eq(ldt.day(), 15L)
}

///|
test "parse_rfc2822 无效返回 None" {
  assert_true(DateTime::parse_rfc2822("invalid") is None)
  assert_true(DateTime::parse_rfc2822("") is None)
}
