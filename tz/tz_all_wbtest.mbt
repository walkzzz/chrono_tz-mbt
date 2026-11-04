///|
/// tz_all_wbtest.mbt — 全 597 时区 offset/DST 扫描白盒测试

///|
test "all 597 offset_from_utc non-exception winter" {
  let all = Tz::all()
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  for tz in all {
    let off = tz.offset_from_utc_date_time(dt)
    let _ = off.offset_sec()
    let _ = off.abbreviation()
  }
}

///|
test "all 597 offset_from_utc non-exception summer" {
  let all = Tz::all()
  let dt = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  for tz in all {
    let off = tz.offset_from_utc_date_time(dt)
    let _ = off.offset_sec()
    let _ = off.abbreviation()
  }
}

///|
test "all 597 offset_from_local non-exception" {
  let all = Tz::all()
  let dt = NaiveDateTime::make(2025L, 6L, 15L, 12L, 0L, 0L)
  for tz in all {
    let lr = tz.offset_from_local_date_time(dt)
    let _ = lr.is_single()
    let _ = lr.is_none()
    let _ = lr.is_ambiguous()
  }
}

///|
test "all 597 timespans non-empty" {
  let all = Tz::all()
  for tz in all {
    let span = tz.timespans()
    assert_true(span.len() >= 1)
  }
}

///|
test "DST detection winter vs summer offset differs" {
  let all = Tz::all()
  let winter = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let summer = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  let mut dst_count = 0
  for tz in all {
    let w = tz.offset_from_utc_date_time(winter).offset_sec()
    let s = tz.offset_from_utc_date_time(summer).offset_sec()
    if w != s {
      dst_count = dst_count + 1
    }
  }
  // 北半球 + 南半球 DST 时区，2025b 应有数十个
  assert_true(dst_count > 20)
}

///|
test "all 597 name non-empty" {
  let all = Tz::all()
  for tz in all {
    let name = tz.name()
    assert_true(name.length() > 0)
  }
}

///|
test "all 597 from_str roundtrip via name" {
  let all = Tz::all()
  for tz in all {
    let name = tz.name()
    match Tz::from_str(name) {
      Some(t) => assert_eq(t, tz)
      None => abort("from_str roundtrip failed for \{name}")
    }
  }
}

///|
test "UTC offset always zero" {
  let utc = Tz::UTC
  for month in 1..<13 {
    let dt = NaiveDateTime::make(2025L, month.to_int64(), 15L, 12L, 0L, 0L)
    let off = utc.offset_from_utc_date_time(dt)
    assert_eq(off.offset_sec(), 0)
  }
}

///|
test "all 597 DateTime construct via and_hms_tz" {
  let all = Tz::all()
  let d = Date::make(2025L, 6L, 15L)
  for tz in all {
    let dt = d.and_hms_tz(tz, 12L, 0L, 0L)
    let _ = dt.timestamp()
    let _ = dt.to_rfc3339()
    let _ = dt.to_string()
  }
}

///|
test "all 597 strftime smoke" {
  let all = Tz::all()
  let d = Date::make(2025L, 6L, 15L)
  for tz in all {
    let dt = d.and_hms_tz(tz, 12L, 30L, 45L)
    let s = strftime("%Y-%m-%d %H:%M:%S %Z %z", dt)
    assert_true(s.length() > 0)
  }
}
