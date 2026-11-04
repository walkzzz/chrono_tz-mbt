///|
/// tz_bench_wbtest.mbt — 基准测试（from_str / offset_from_utc / timestamp / strftime）

///|
test "bench from_str" {
  let names = Tz::all_names()
  let summary = @bench.single_bench(
    () => {
      for name in names {
        ignore(Tz::from_str(name))
      }
    },
    name="from_str x597",
    count=10,
  )
  ignore(summary)
}

///|
test "bench offset_from_utc" {
  let all = Tz::all()
  let dt = NaiveDateTime::make(2025L, 7L, 15L, 12L, 0L, 0L)
  let summary = @bench.single_bench(
    () => {
      for tz in all {
        ignore(tz.offset_from_utc_date_time(dt).offset_sec())
      }
    },
    name="offset_from_utc x597",
    count=10,
  )
  ignore(summary)
}

///|
test "bench timestamp" {
  let summary = @bench.single_bench(
    () => {
      for i in 0..<1000 {
        let dt = NaiveDateTime::from_timestamp(i.to_int64() * 86400L)
        ignore(dt.timestamp())
      }
    },
    name="timestamp x1000",
    count=10,
  )
  ignore(summary)
}

///|
test "bench strftime" {
  let all = Tz::all()
  let d = Date::make(2025L, 7L, 15L)
  let dts = Array::make(all.length(), d.and_hms_tz(Tz::UTC, 12L, 0L, 0L))
  for i in 0..<all.length() {
    dts[i] = d.and_hms_tz(all[i], 12L, 30L, 45L)
  }
  let summary = @bench.single_bench(
    () => {
      for dt in dts {
        ignore(strftime("%Y-%m-%d %H:%M:%S %Z %z", dt))
      }
    },
    name="strftime x597",
    count=10,
  )
  ignore(summary)
}

///|
test "bench to_rfc3339" {
  let all = Tz::all()
  let d = Date::make(2025L, 7L, 15L)
  let dts = Array::make(all.length(), d.and_hms_tz(Tz::UTC, 12L, 0L, 0L))
  for i in 0..<all.length() {
    dts[i] = d.and_hms_tz(all[i], 12L, 30L, 45L)
  }
  let summary = @bench.single_bench(
    () => {
      for dt in dts {
        ignore(dt.to_rfc3339())
      }
    },
    name="to_rfc3339 x597",
    count=10,
  )
  ignore(summary)
}

///|
test "bench parse_rfc3339" {
  let all = Tz::all()
  let d = Date::make(2025L, 7L, 15L)
  let strs = Array::make(all.length(), "")
  for i in 0..<all.length() {
    let dt = d.and_hms_tz(all[i], 12L, 30L, 45L)
    strs[i] = dt.to_rfc3339()
  }
  let summary = @bench.single_bench(
    () => {
      for s in strs {
        ignore(DateTime::parse_rfc3339(s))
      }
    },
    name="parse_rfc3339 x597",
    count=10,
  )
  ignore(summary)
}
