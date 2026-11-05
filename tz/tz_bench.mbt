///|
/// tz_bench.mbt — 公开基准测试与属性检查 API（消除 unused_package 警告）

///|
/// 运行 from_str 基准测试，返回摘要。
pub fn bench_from_str_summary() -> @bench.Summary {
  let names = Tz::all_names()
  @bench.single_bench(
    () => {
      for name in names {
        ignore(Tz::from_str(name))
      }
    },
    name="from_str x597",
    count=10,
  )
}

///|
/// 运行 Hinnant civil↔days 往返属性检查，返回是否通过。
pub fn quickcheck_civil_roundtrip() -> Unit raise {
  @quickcheck.check(
    (days : Int64) => {
      let (y, m, d) = @core.civil_from_days(days)
      @core.days_from_civil(y, m, d) == days
    },
    filter=days => days >= -40000000L && days <= 40000000L,
  )
}
