///|
/// posix_extrapolate_wbtest.mbt — POSIX TZ footer 外推白盒测试
/// 验证超出内置 transition 后的 DST 外推正确性。

///|
fn get_tz_extrap(name : String) -> Tz {
  match Tz::from_str(name) {
    Some(tz) => tz
    None => abort("timezone not found: \{name}")
  }
}

///|
test "posix extrapolate America/New_York summer DST" {
  let tz = get_tz_extrap("America/New_York")
  let dt = NaiveDateTime::make(2030L, 7L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), -14400)
}

///|
test "posix extrapolate America/New_York winter EST" {
  let tz = get_tz_extrap("America/New_York")
  let dt = NaiveDateTime::make(2030L, 1L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), -18000)
}

///|
test "posix extrapolate Asia/Shanghai no DST" {
  let tz = get_tz_extrap("Asia/Shanghai")
  let dt = NaiveDateTime::make(2030L, 7L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), 28800)
}

///|
test "posix extrapolate UTC zero offset" {
  let tz = get_tz_extrap("UTC")
  let dt = NaiveDateTime::make(2030L, 7L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), 0)
}

///|
test "posix extrapolate Europe/London summer BST" {
  let tz = get_tz_extrap("Europe/London")
  let dt = NaiveDateTime::make(2030L, 7L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), 3600)
}

///|
test "posix extrapolate Europe/London winter GMT" {
  let tz = get_tz_extrap("Europe/London")
  let dt = NaiveDateTime::make(2030L, 1L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), 0)
}

///|
test "posix extrapolate America/Los_Angeles summer PDT" {
  let tz = get_tz_extrap("America/Los_Angeles")
  let dt = NaiveDateTime::make(2030L, 7L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), -25200)
}

///|
test "posix extrapolate Australia/Sydney summer AEDT" {
  let tz = get_tz_extrap("Australia/Sydney")
  let dt = NaiveDateTime::make(2030L, 1L, 15L, 12L, 0L, 0L)
  let offset = tz.offset_from_utc_extrapolated(dt)
  assert_eq(offset.offset_sec(), 39600)
}
