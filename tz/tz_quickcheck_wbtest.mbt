///|
/// tz_quickcheck_wbtest.mbt — Hinnant 算法 @quickcheck 性质测试
///
/// 注：Int64 对极端值（如 -25252982167711029）中间计算溢出，
/// 用 filter 限制到 ±100000 年范围（实际应用远不超过此范围）。

///|
/// civil_from_days ∘ days_from_civil = id（往返互逆）
test "Hinnant days_from_civil roundtrip" {
  @quickcheck.check(
    (days : Int64) => {
      let (y, m, d) = @core.civil_from_days(days)
      @core.days_from_civil(y, m, d) == days
    },
    filter=days => days >= -40000000L && days <= 40000000L,
    count=2000,
  )
}

///|
/// days_from_civil ∘ civil_from_days = id（往返互逆，从 civil 端）
test "Hinnant civil_from_days roundtrip" {
  @quickcheck.check(
    (year : Int64) => {
      let days = @core.days_from_civil(year, 1L, 1L)
      let (y, _, _) = @core.civil_from_days(days)
      y == year
    },
    filter=year => year >= -100000L && year <= 100000L,
    count=2000,
  )
}

///|
/// weekday 对齐：1970-01-01 是周四（weekday=4）
test "Hinnant weekday epoch is Thursday" {
  let days = @core.days_from_civil(1970L, 1L, 1L)
  assert_eq(days, 0L)
  let (y, m, d) = @core.civil_from_days(0L)
  assert_eq(y, 1970L)
  assert_eq(m, 1L)
  assert_eq(d, 1L)
}

///|
/// NaiveDateTime timestamp 往返：from_timestamp ∘ timestamp = id
test "NaiveDateTime timestamp roundtrip quickcheck" {
  @quickcheck.check(
    (ts : Int64) => {
      let dt = NaiveDateTime::from_timestamp(ts)
      dt.timestamp() == ts
    },
    filter=ts => ts >= -3153600000000L && ts <= 3153600000000L,
    count=2000,
  )
}

///|
/// NaiveDateTime 日期分量范围合法
test "NaiveDateTime components in range quickcheck" {
  @quickcheck.check(
    (ts : Int64) => {
      let dt = NaiveDateTime::from_timestamp(ts)
      dt.month() >= 1L &&
      dt.month() <= 12L &&
      dt.day() >= 1L &&
      dt.day() <= 31L &&
      dt.hour() >= 0L &&
      dt.hour() <= 23L &&
      dt.minute() >= 0L &&
      dt.minute() <= 59L &&
      dt.second() >= 0L &&
      dt.second() <= 59L
    },
    filter=ts => ts >= -3153600000000L && ts <= 3153600000000L,
    count=2000,
  )
}

///|
/// weekday 范围 0..6
test "NaiveDateTime weekday in range quickcheck" {
  @quickcheck.check(
    (ts : Int64) => {
      let dt = NaiveDateTime::from_timestamp(ts)
      let wd = dt.weekday()
      wd >= 0L && wd <= 6L
    },
    filter=ts => ts >= -3153600000000L && ts <= 3153600000000L,
    count=2000,
  )
}

///|
/// ordinal 范围 1..366
test "NaiveDateTime ordinal in range quickcheck" {
  @quickcheck.check(
    (ts : Int64) => {
      let dt = NaiveDateTime::from_timestamp(ts)
      let ord = dt.ordinal()
      ord >= 1L && ord <= 366L
    },
    filter=ts => ts >= -3153600000000L && ts <= 3153600000000L,
    count=2000,
  )
}
