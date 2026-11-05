# walkzzz/chrono_tz-mbt

MoonBit IANA 时区库，移植自 [chrono_tz_cangjie](https://github.com/chronotope/chrono-tz)（仓颉 v2.157.0，Rust chrono-tz 0.11.0）。

聚焦 IANA tzdata 2025b（597 时区）+ DST 三分支 + Hinnant civil↔days + RFC3339 + strftime/strptime。不含农历/术数。

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

## 核心 API

- `Tz::from_str(s) -> Tz?` — 二分查找解析 IANA 时区名
- `Tz::name() -> String` — 时区名
- `Tz::all() -> Array[Tz]` / `Tz::all_names() -> Array[String]` — 全 597 时区
- `Tz::offset_from_utc_date_time(dt) -> TzOffset` — UTC→本地偏移
- `Tz::offset_from_local_date_time(dt) -> LocalResult[TzOffset]` — 本地→UTC 偏移（DST 三分支）
- `NaiveDateTime::from_timestamp(ts) -> NaiveDateTime` — Unix 时间戳→civil（Hinnant）
- `DateTime::parse_rfc3339(s) -> DateTime?` — RFC3339 解析
- `DateTime::to_rfc3339() -> String` — RFC3339 格式化
- `DateTime::strftime(fmt) -> String` — strftime 格式化
- `DateTime::with_timezone(tz) -> DateTime` — 时区转换

## DST 三分支

```
enum LocalResult[T] {
  Single(T)       // Normal — 唯一解
  Ambiguous(T, T) // 秋季回拨 — 两个解
  None            // 春季前跳 — 无解
}
```

## 包

- `tz` — 时区算法（Tz 枚举 597 + DateTime + DST + RFC3339 + strftime/strptime + JSON 序列化）
- `core` — 零依赖核心类型（Hinnant + FixedTimespan + 全局查表）
- `data` — 6 大洲 IANA tzdata 数据（38711 行）

## 构建与测试

```bash
moon check                    # 类型检查（0 warnings）
moon test --target native     # 运行测试（165 个，native target）
moon info && moon fmt         # 更新接口 + 格式化
```

> 注：WASM target 有 597 match arm local count 限制，需用 `--target native`。

## 许可证

Apache-2.0