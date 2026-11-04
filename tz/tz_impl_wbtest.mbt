///|
/// tz_impl_wbtest.mbt — Tz::timespans / offset_from_utc/local / DateTime / GapInfo 白盒测试

///|
fn get_tz(name : String) -> Tz {
  match Tz::from_str(name) {
    Some(t) => t
    None => abort("timezone not found: \{name}")
  }
}

///|
test "Tz::timespans UTC" {
  let tz = get_tz("UTC")
  let span = tz.timespans()
  assert_true(span.len() >= 1)
}

///|
test "Tz::timespans Europe/Paris" {
  let tz = get_tz("Europe/Paris")
  let span = tz.timespans()
  assert_true(span.len() >= 1)
}

///|
test "offset_from_utc UTC" {
  let tz = get_tz("UTC")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let off = tz.offset_from_utc_date_time(dt)
  assert_eq(off.offset_sec(), 0)
  assert_eq(off.tz_id(), "UTC")
}

///|
test "offset_from_utc Europe/London winter" {
  let tz = get_tz("Europe/London")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let off = tz.offset_from_utc_date_time(dt)
  assert_eq(off.offset_sec(), 0)
  assert_eq(off.abbreviation(), "GMT")
}

///|
test "offset_from_utc Europe/London summer" {
  let tz = get_tz("Europe/London")
  let dt = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  let off = tz.offset_from_utc_date_time(dt)
  assert_eq(off.offset_sec(), 3600)
  assert_eq(off.abbreviation(), "BST")
}

///|
test "offset_from_utc America/New_York winter" {
  let tz = get_tz("America/New_York")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let off = tz.offset_from_utc_date_time(dt)
  assert_eq(off.offset_sec(), -18000)
  assert_eq(off.abbreviation(), "EST")
}

///|
test "offset_from_utc America/New_York summer" {
  let tz = get_tz("America/New_York")
  let dt = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  let off = tz.offset_from_utc_date_time(dt)
  assert_eq(off.offset_sec(), -14400)
  assert_eq(off.abbreviation(), "EDT")
}

///|
test "offset_from_local UTC" {
  let tz = get_tz("UTC")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let lr = tz.offset_from_local_date_time(dt)
  assert_true(lr.is_single())
  assert_eq(lr.unwrap().offset_sec(), 0)
}

///|
test "offset_from_local Europe/London normal" {
  let tz = get_tz("Europe/London")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let lr = tz.offset_from_local_date_time(dt)
  assert_true(lr.is_single())
  assert_eq(lr.unwrap().offset_sec(), 0)
}

///|
test "offset_from_local Europe/London DST gap" {
  let tz = get_tz("Europe/London")
  // March 30, 2025 1am local — spring forward gap (1am GMT → 2am BST)
  let dt = NaiveDateTime::make(2025L, 3L, 30L, 1L, 30L, 0L)
  let lr = tz.offset_from_local_date_time(dt)
  assert_true(lr.is_none())
}

///|
test "offset_from_local Europe/London DST ambiguous" {
  let tz = get_tz("Europe/London")
  // October 26, 2025 1am local — fall back ambiguous (2am BST → 1am GMT)
  let dt = NaiveDateTime::make(2025L, 10L, 26L, 1L, 30L, 0L)
  let lr = tz.offset_from_local_date_time(dt)
  assert_true(lr.is_ambiguous())
}

///|
test "DateTime basic" {
  let tz = get_tz("UTC")
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(tz, span)
  let dt = DateTime::make(0L, off)
  assert_eq(dt.timestamp(), 0L)
  assert_eq(dt.offset_sec(), 0)
  assert_eq(dt.abbreviation(), "UTC")
  assert_eq(dt.tz_id(), "UTC")
}

///|
test "DateTime to_rfc3339 UTC" {
  let tz = get_tz("UTC")
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(tz, span)
  let dt = DateTime::make(0L, off)
  assert_eq(dt.to_rfc3339(), "1970-01-01T00:00:00+00:00")
}

///|
test "DateTime to_string UTC" {
  let tz = get_tz("UTC")
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(tz, span)
  let dt = DateTime::make(0L, off)
  assert_eq(dt.to_string(), "1970-01-01 00:00:00 UTC")
}

///|
test "DateTime with_timezone" {
  let utc = get_tz("UTC")
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(utc, span)
  let dt = DateTime::make(0L, off)
  let london = get_tz("Europe/London")
  let dt_london = dt.with_timezone(london)
  assert_eq(dt_london.timestamp(), 0L)
  assert_eq(dt_london.tz_id(), "Europe/London")
  // 1970-01-01: UK was in permanent BST experiment (UTC+1) from 1968-1971
  assert_eq(dt_london.offset_sec(), 3600)
}

///|
test "Tz::from_local_date_time Single" {
  let tz = get_tz("UTC")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let lr = tz.from_local_date_time(dt)
  assert_true(lr.is_single())
  let result = lr.unwrap()
  assert_eq(result.tz_id(), "UTC")
  assert_eq(result.offset_sec(), 0)
}

///|
test "Tz::from_local_date_time None" {
  let tz = get_tz("Europe/London")
  // March 30, 2025 1:30am — spring forward gap
  let dt = NaiveDateTime::make(2025L, 3L, 30L, 1L, 30L, 0L)
  let lr = tz.from_local_date_time(dt)
  assert_true(lr.is_none())
}

///|
test "Tz::from_local_date_time Ambiguous" {
  let tz = get_tz("Europe/London")
  // October 26, 2025 1:30am — fall back ambiguous
  let dt = NaiveDateTime::make(2025L, 10L, 26L, 1L, 30L, 0L)
  let lr = tz.from_local_date_time(dt)
  assert_true(lr.is_ambiguous())
  let earliest = lr.earliest()
  let latest = lr.latest()
  assert_eq(earliest.tz_id(), "Europe/London")
  assert_eq(latest.tz_id(), "Europe/London")
}

///|
test "Date::and_hms_opt Single" {
  let tz = get_tz("UTC")
  let d = Date::make(2025L, 1L, 15L)
  let lr = d.and_hms_opt(tz, 12L, 0L, 0L)
  assert_true(lr.is_single())
  let dt = lr.unwrap()
  assert_eq(dt.tz_id(), "UTC")
}

///|
test "Date::and_hms_tz Single" {
  let tz = get_tz("UTC")
  let d = Date::make(2025L, 1L, 15L)
  let dt = d.and_hms_tz(tz, 12L, 0L, 0L)
  assert_eq(dt.tz_id(), "UTC")
}

///|
test "GapInfo detect gap" {
  let tz = get_tz("Europe/London")
  // March 30, 2025 1:30am — spring forward gap
  let dt = NaiveDateTime::make(2025L, 3L, 30L, 1L, 30L, 0L)
  let gap = GapInfo::detect(dt, tz)
  assert_true(gap is Some(_))
}

///|
test "GapInfo detect no gap" {
  let tz = get_tz("Europe/London")
  let dt = NaiveDateTime::make(2025L, 1L, 15L, 12L, 0L, 0L)
  let gap = GapInfo::detect(dt, tz)
  assert_true(gap is None)
}
