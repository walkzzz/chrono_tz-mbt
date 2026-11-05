///|
/// 黑盒测试 — 通过 `@chrono_tz_mbt` 公开 API 验证端到端行为。
/// 根包依赖 tz，外部用户通过 `walkzzz/chrono_tz-mbt/tz` 使用时区功能。
test "Tz::from_str roundtrip" {
  let tz = match @tz.Tz::from_str("Asia/Tokyo") {
    Some(t) => t
    None => abort("Asia/Tokyo not found")
  }
  assert_eq(tz.name(), "Asia/Tokyo")
}

///|
test "DateTime RFC3339 roundtrip" {
  let rfc = "2025-01-15T08:30:00Z"
  let dt = match @tz.DateTime::parse_rfc3339(rfc) {
    Some(d) => d
    None => abort("parse failed")
  }
  assert_eq(dt.to_rfc3339(), "2025-01-15T08:30:00+00:00")
}

///|
test "timezone conversion UTC to Shanghai" {
  let utc_tz = match @tz.Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  let shanghai = match @tz.Tz::from_str("Asia/Shanghai") {
    Some(t) => t
    None => abort("Asia/Shanghai not found")
  }
  let naive = @tz.NaiveDateTime::from_timestamp(0L)
  let off = utc_tz.offset_from_utc_date_time(naive)
  let dt = @tz.DateTime::make(0L, off)
  let shanghai_dt = dt.with_timezone(shanghai)
  assert_eq(shanghai_dt.offset_sec(), 28800)
}

///|
test "all 597 timezones accessible" {
  let all = @tz.Tz::all()
  assert_eq(all.length(), 597)
  let names = @tz.Tz::all_names()
  assert_eq(names.length(), 597)
}

///|
test "strftime format output" {
  let dt = match @tz.DateTime::parse_rfc3339("2026-03-15T14:30:00Z") {
    Some(d) => d
    None => abort("parse failed")
  }
  assert_eq(@tz.strftime("%Y-%m-%d %H:%M:%S", dt), "2026-03-15 14:30:00")
}
