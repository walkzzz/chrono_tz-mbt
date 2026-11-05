# walkzzz/chrono_tz-mbt

MoonBit IANA 时区库，移植自 chrono_tz_cangjie（仓颉 v2.157.0，Rust chrono-tz 0.11.0）。

聚焦 IANA tzdata 2025b（597 时区）+ DST 三分支 + Hinnant civil↔days + RFC3339 + strftime/strptime。

## 依赖

```toml
# moon.mod
import {
  "walkzzz/chrono_tz-mbt/tz" @tz,
}
```

## 示例

```moonbit nocheck
let tz = @tz.Tz::from_str("Asia/Shanghai").unwrap()
let naive = @tz.NaiveDateTime::from_timestamp(0L)
let utc_tz = @tz.Tz::from_str("UTC").unwrap()
let off = utc_tz.offset_from_utc_date_time(naive)
let dt = @tz.DateTime::make(0L, off)
let shanghai_dt = dt.with_timezone(tz)
println(shanghai_dt.to_rfc3339())  // 1970-01-01T08:00:00+08:00
```

## 包

- `tz` — 时区算法（Tz 枚举 + DateTime + DST + RFC3339 + strftime/strptime）
- `core` — 零依赖核心类型（Hinnant + FixedTimespan + 全局查表）
- `data` — 6 大洲 IANA tzdata 数据