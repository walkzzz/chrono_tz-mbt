///|
/// tz_local.mbt — 宿主时区检测（读 $TZ 环境变量）。

///|
/// 返回宿主时区（读 $TZ 环境变量）。
/// native/js/wasm 均读 $TZ；未设置、空串或解析失败返回 None。
pub fn Tz::local_tz() -> Tz? {
  guard @env.get_env_var("TZ") is Some(tz_str) else { return None }
  if tz_str.length() == 0 {
    return None
  }
  Tz::from_str(tz_str)
}
