///|
/// tz_cron_wbtest.mbt — cron 表达式白盒测试

///|
fn make_dt(
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
test "Cron::parse 基本" {
  guard Cron::parse("30 9 * * *") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "Cron::parse mon-fri" {
  guard Cron::parse("30 9 * * mon-fri") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "Cron::parse 步长" {
  guard Cron::parse("*/15 * * * *") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "Cron::parse 列表" {
  guard Cron::parse("0,30 9 * * *") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "Cron::parse 月份名称" {
  guard Cron::parse("0 0 1 jan,jul *") is Some(_) else {
    assert_true(false)
    return
  }
  assert_true(true)
}

///|
test "Cron::parse 无效字段数" {
  assert_true(Cron::parse("30 9 * *") is None)
  assert_true(Cron::parse("30 9 * * * *") is None)
}

///|
test "Cron::parse 无效值" {
  assert_true(Cron::parse("60 9 * * *") is None)
  assert_true(Cron::parse("30 25 * * *") is None)
}

///|
test "Cron::matches 命中" {
  guard Cron::parse("30 9 * * *") is Some(cron) else {
    assert_true(false)
    return
  }
  let dt = make_dt(2024L, 3L, 8L, 9L, 30L, 0L)
  assert_true(cron.matches(dt))
}

///|
test "Cron::matches 不命中" {
  guard Cron::parse("30 9 * * *") is Some(cron) else {
    assert_true(false)
    return
  }
  let dt = make_dt(2024L, 3L, 8L, 10L, 0L, 0L)
  assert_true(!cron.matches(dt))
}

///|
test "Cron::matches mon-fri" {
  guard Cron::parse("0 9 * * mon-fri") is Some(cron) else {
    assert_true(false)
    return
  }
  // 2024-03-08 是 Friday (wd=5)
  let dt_fri = make_dt(2024L, 3L, 8L, 9L, 0L, 0L)
  assert_true(cron.matches(dt_fri))
  // 2024-03-09 是 Saturday (wd=6)
  let dt_sat = make_dt(2024L, 3L, 9L, 9L, 0L, 0L)
  assert_true(!cron.matches(dt_sat))
}

///|
test "Cron::next 基本同日" {
  guard Cron::parse("30 9 * * *") is Some(cron) else {
    assert_true(false)
    return
  }
  let dt = make_dt(2024L, 3L, 8L, 9L, 0L, 0L)
  guard cron.next(dt) is Some(next_dt) else {
    assert_true(false)
    return
  }
  let ldt = next_dt.naive_local()
  assert_eq(ldt.hour(), 9L)
  assert_eq(ldt.minute(), 30L)
  assert_eq(ldt.day(), 8L)
}

///|
test "Cron::next 跨日" {
  guard Cron::parse("0 0 * * *") is Some(cron) else {
    assert_true(false)
    return
  }
  let dt = make_dt(2024L, 3L, 8L, 23L, 59L, 0L)
  guard cron.next(dt) is Some(next_dt) else {
    assert_true(false)
    return
  }
  let ldt = next_dt.naive_local()
  assert_eq(ldt.day(), 9L)
  assert_eq(ldt.hour(), 0L)
  assert_eq(ldt.minute(), 0L)
}

///|
test "Cron::next 步长15分钟" {
  guard Cron::parse("*/15 * * * *") is Some(cron) else {
    assert_true(false)
    return
  }
  let dt = make_dt(2024L, 3L, 8L, 9L, 7L, 0L)
  guard cron.next(dt) is Some(next_dt) else {
    assert_true(false)
    return
  }
  let ldt = next_dt.naive_local()
  assert_eq(ldt.minute(), 15L)
}

///|
test "Cron::next mon-fri 周末跳过" {
  guard Cron::parse("0 9 * * mon-fri") is Some(cron) else {
    assert_true(false)
    return
  }
  // 2024-03-09 是 Saturday
  let dt = make_dt(2024L, 3L, 9L, 8L, 0L, 0L)
  guard cron.next(dt) is Some(next_dt) else {
    assert_true(false)
    return
  }
  let ldt = next_dt.naive_local()
  // 下一次是 Monday 2024-03-11 09:00
  assert_eq(ldt.day(), 11L)
  assert_eq(ldt.hour(), 9L)
}
