///|
/// tz_local_wbtest.mbt — 宿主时区白盒测试

///|
test "Tz::local 调用不崩溃" {
  let _ = Tz::local_tz()
  assert_true(true)
}

///|
test "Tz::local 读取 TZ 环境变量" {
  @env.set_env_var("TZ", "Asia/Shanghai")
  guard Tz::local_tz() is Some(tz) else {
    assert_true(false)
    return
  }
  assert_eq(tz.name(), "Asia/Shanghai")
  @env.set_env_var("TZ", "")
}

///|
test "Tz::local 空串返回 None" {
  @env.set_env_var("TZ", "")
  assert_true(Tz::local_tz() is None)
}

///|
test "Tz::local 无效时区返回 None" {
  @env.set_env_var("TZ", "Invalid/Zone")
  assert_true(Tz::local_tz() is None)
  @env.set_env_var("TZ", "")
}
