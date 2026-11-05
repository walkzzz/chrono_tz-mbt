# API 参考 / API Reference

> chrono_tz-mbt 核心公共 API。本文件是设计契约，实现按 Sprint 逐步填充。
> 导入：`pub using @chrono_tz-mbt { type Tz, type NaiveDateTime, type DateTime, ... }` 或按子包 `@tz`/`@core`/`@data`。

## 包结构

| 包 | 路径 | 职责 |
|----|------|------|
| `@chrono_tz-mbt` | 根 | 文档入口 + 14 个便捷函数（委托 `@tz`） |
| `@chrono_tz-mbt/core` | `core/` | 零依赖核心类型 + 全局查表 |
| `@chrono_tz-mbt/data` | `data/` | 6 大洲时区数据常量 |
| `@chrono_tz-mbt/tz` | `tz/` | 时区算法层 |

---

## 根包便捷 API（14 函数）

根包提供无状态便捷函数，委托 `@tz` 完成常见时区操作，调用方不必直接引用 `@tz` 静态方法。涉及 `Tz`/`DateTime`/`NaiveDateTime` 等类型的构造与判别仍需 `@tz`。

```moonbit
/// 时区总数（597）。
pub fn tz_count() -> Int32

/// 全部 IANA 时区名称。
pub fn tz_names() -> Array[String]

/// 解析 IANA 时区名，失败返回 None。
pub fn tz_from_str(name : String) -> @tz.Tz?

/// 返回时区的 IANA 名称。
pub fn tz_name(tz : @tz.Tz) -> String

/// 时区在给定 UTC 时间戳下的偏移量（秒）。东区为正。
pub fn offset_from_utc(tz : @tz.Tz, timestamp : Int64) -> Int32

/// 时区在给定本地时刻下的偏移结果（处理 DST gap/ambiguous）。
pub fn offset_from_local(tz : @tz.Tz, naive : @tz.NaiveDateTime) -> @tz.LocalResult[@tz.TzOffset]

/// 从 UTC 时间戳和时区构造 DateTime。
pub fn datetime_from_timestamp(timestamp : Int64, tz : @tz.Tz) -> @tz.DateTime

/// 将 DateTime 转换到目标时区（时间戳不变）。
pub fn convert_timezone(dt : @tz.DateTime, target : @tz.Tz) -> @tz.DateTime

/// DateTime → RFC 3339 字符串。
pub fn to_rfc3339(dt : @tz.DateTime) -> String

/// 解析 RFC 3339 字符串为 DateTime。
pub fn parse_rfc3339(s : String) -> @tz.DateTime?

/// strftime 格式化。
pub fn strftime(fmt : String, dt : @tz.DateTime) -> String

/// strptime 解析（需指定结果所属时区）。
pub fn strptime(fmt : String, s : String, tz : @tz.Tz) -> @tz.DateTime?

/// DST gap 检测（时钟前跳，该本地时刻不存在）。
pub fn detect_gap(tz : @tz.Tz, naive : @tz.NaiveDateTime) -> @tz.GapInfo?

/// 从本地时刻构造 DateTime（处理 DST gap/ambiguous）。
pub fn from_local(tz : @tz.Tz, naive : @tz.NaiveDateTime) -> @tz.LocalResult[@tz.DateTime]
```

**示例**：

```moonbit
let tz = tz_from_str("Asia/Shanghai").unwrap()
assert_eq(offset_from_utc(tz, 0L), 28800)   // +08:00
let dt = datetime_from_timestamp(0L, tz_from_str("UTC").unwrap())
assert_eq(to_rfc3339(dt), "1970-01-01T00:00:00+00:00")
```

---

## core 包

### 常量

```moonbit
/// IANA tzdb 版本号。
pub const IANA_TZDB_VERSION : String   // "2025b"
```

### Ordering

```moonbit
pub enum Ordering {
  Less
  Equal
  Greater
} derive(Eq, Compare, Debug)

pub extend Ordering with Eq::{not_equal, equal}
pub extend Ordering with Compare::{op_lt, op_le, op_ge, compare, op_gt}
pub extend Ordering with Debug::{to_repr}
```

三路比较结果。MoonBit 标准库未提供此枚举（其 `Compare` trait 返回 `Int32`），本项目自定义。序关系：`Less < Equal < Greater`。

### FixedTimespan

```moonbit
pub struct FixedTimespan {
  offset : Int32   // UTC 偏移秒（如 CET = +3600）
  name : String    // 缩写（如 "CET"）
} derive(Eq, Compare, Debug)

pub extend FixedTimespan with Eq::{not_equal, equal}
pub extend FixedTimespan with Compare::{op_lt, op_le, op_ge, compare, op_gt}
pub extend FixedTimespan with Debug::{to_repr}
```

单段固定偏移：从某过渡点起生效的 UTC 偏移及其缩写名。

### Span

```moonbit
pub struct Span {
  begin : Int64?   // 区间下界（含），None 无下界
  end : Int64?     // 区间上界（不含），None 无上界
} derive(Eq, Compare, Debug)

pub extend Span with Eq::{not_equal, equal}
pub extend Span with Compare::{op_lt, op_le, op_ge, compare, op_gt}
pub extend Span with Debug::{to_repr}

pub fn Span::cmp(self : Span, x : Int64) -> Ordering
pub fn Span::contains(self : Span, x : Int64) -> Bool
```

左闭右开时间戳区间 `[begin, end)`。`cmp`：x 在区间内 `Equal`，早于 `Greater`，晚于 `Less`。

### FixedTimespanSet

```moonbit
pub struct FixedTimespanSet {
  first_offset_idx : Int32
  first_abbr_idx : Int32
  rest_compact : Array[(Int64, Int32, Int32)]
} derive(Eq, Compare, Debug)

pub extend FixedTimespanSet with Eq::{not_equal, equal}
pub extend FixedTimespanSet with Compare::{op_lt, op_le, op_ge, compare, op_gt}
pub extend FixedTimespanSet with Debug::{to_repr}

pub fn FixedTimespanSet::make(first_offset_idx : Int32, first_abbr_idx : Int32, rest_compact : Array[(Int64, Int32, Int32)]) -> FixedTimespanSet
pub fn FixedTimespanSet::from_first_rest(first : FixedTimespan, rest : Array[(Int64, FixedTimespan)]) -> FixedTimespanSet
pub fn FixedTimespanSet::len(self : FixedTimespanSet) -> Int32
pub fn FixedTimespanSet::utc_span(self : FixedTimespanSet, index : Int32) -> Span
pub fn FixedTimespanSet::local_span(self : FixedTimespanSet, index : Int32) -> Span
pub fn FixedTimespanSet::get(self : FixedTimespanSet, index : Int32) -> FixedTimespan
pub fn FixedTimespanSet::offset_at(self : FixedTimespanSet, index : Int32) -> Int32
pub fn FixedTimespanSet::name_at(self : FixedTimespanSet, index : Int32) -> String
pub fn FixedTimespanSet::estimated_memory_bytes(self : FixedTimespanSet) -> Int64
```

单个时区的预计算过渡表（ADR-005 压缩存储）：`first_offset_idx`/`first_abbr_idx` 为最早段在全局查表中的索引，`rest_compact` 每条为 `(transitionUtcSec, offsetIdx, abbrIdx)`。

### 全局查表

```moonbit
/// 全局 UTC 偏移查表（406 唯一值，升序）。
pub let tz_offset_table : Array[Int32]

/// 全局时区缩写查表（178 唯一值，字典序）。
pub let tz_name_table : Array[String]

/// 偏移值→索引（二分，包内私有）。
fn lookup_offset_idx(offset : Int32) -> Int32

/// 缩写→索引（线性，包内私有）。
fn lookup_abbr_idx(abbr : String) -> Int32
```

各时区 `FixedTimespanSet` 存索引而非原值，减小体积（见 ADR-005）。

---

## tz 包

### Tz（时区枚举）

```moonbit
pub enum Tz {
  Africa__Abidjan
  Africa__Accra
  // ... 共 597 variant（340 规范 + 257 别名）
  Asia__Shanghai
  Europe__London
  America__New_York
  UTC
  // ...
} derive(Eq, Compare, Show)
```

variant 命名：IANA 时区名中 `/` → `__`，`-`/`+` 保留在 `Etc__GMTPlus1` 等中。

```moonbit
/// IANA 时区名 → Tz，未知返回 None（不抛错）。
pub fn Tz::from_str(s : String) -> Tz?

/// Tz → IANA 时区名。
pub fn Tz::name(self : Tz) -> String

/// 该时区的完整偏移历史。
pub fn Tz::timespans(self : Tz) -> FixedTimespanSet

/// UTC 时刻的偏移（单值，UTC→本地无歧义）。
pub fn Tz::offset_from_utc_date_time(self : Tz, dt : NaiveDateTime) -> TzOffset

/// 本地时刻的偏移（三分支，DST 缺口/重叠）。
pub fn Tz::offset_from_local_date_time(self : Tz, dt : NaiveDateTime) -> LocalResult[TzOffset]

/// 构造 Date（仅年月日，时分秒默认 0）。
pub fn Tz::ymd(self : Tz, year : Int32, month : Int32, day : Int32) -> Date
```

**示例**：

```moonbit
let tz = @tz.Tz::from_str("Asia/Shanghai").unwrap()   // 或 guard!
assert_eq(tz.name(), "Asia/Shanghai")
```

### NaiveDateTime（无时区日期时间）

```moonbit
pub struct NaiveDateTime {
  year : Int64
  month : Int64
  day : Int64
  hour : Int64
  min : Int64
  sec : Int64
} derive(Eq, Compare, Show, ToJson)

/// 构造，非法日期/时间抛 TzError。
pub fn NaiveDateTime::make(y, mo, d, h, mi, s : Int64) -> NaiveDateTime raise TzError

/// Unix 时间戳 → NaiveDateTime（UTC，Hinnant 算法）。
pub fn NaiveDateTime::from_timestamp(unix_secs : Int64) -> NaiveDateTime

/// NaiveDateTime → Unix 时间戳（Hinnant 算法，支持负时间戳）。
pub fn NaiveDateTime::timestamp(self : NaiveDateTime) -> Int64

/// 日历分量（DateTimeLike trait）。
pub fn NaiveDateTime::year(self) -> Int64
pub fn NaiveDateTime::month(self) -> Int64
pub fn NaiveDateTime::day(self) -> Int64
pub fn NaiveDateTime::weekday(self) -> Int64          // 0=周日..6=周六
pub fn NaiveDateTime::ordinal(self) -> Int64          // 年内序日 1..366
pub fn NaiveDateTime::week_of_year(self) -> Int64

/// 闰年/月天数。
pub fn NaiveDateTime::is_leap_year(year : Int64) -> Bool
pub fn NaiveDateTime::days_in_month(year : Int64, month : Int64) -> Int64

/// 算术。
pub fn NaiveDateTime::add_seconds(self : NaiveDateTime, secs : Int64) -> NaiveDateTime
pub fn NaiveDateTime::sub_seconds(self : NaiveDateTime, secs : Int64) -> NaiveDateTime
pub fn NaiveDateTime::add_days(self : NaiveDateTime, days : Int64) -> NaiveDateTime
pub fn NaiveDateTime::add_months(self : NaiveDateTime, months : Int64) -> NaiveDateTime
pub fn NaiveDateTime::add_years(self : NaiveDateTime, years : Int64) -> NaiveDateTime

/// 格式化。
pub fn NaiveDateTime::to_rfc_string(self) -> String          // "YYYY-MM-DDTHH:MM:SS"
pub fn NaiveDateTime::to_date_time_string(self) -> String
pub fn NaiveDateTime::format(self, fmt : String) -> String   // strftime 子集
pub fn NaiveDateTime::parse_from_str(s : String, fmt : String) -> NaiveDateTime?  // strptime
```

### DateTime（带时区日期时间）

```moonbit
pub struct DateTime {
  naive_utc : Int64     // UTC 时间戳
  off : TzOffset        // 当前偏移
} derive(Eq, Compare, Show)

pub fn DateTime::make(naive_utc : Int64, off : TzOffset) -> DateTime
pub fn DateTime::timestamp(self) -> Int64
pub fn DateTime::offset(self) -> TzOffset
pub fn DateTime::offset_sec(self) -> Int32
pub fn DateTime::abbreviation(self) -> String         // "CST"/"CEST" 等
pub fn DateTime::tz_id(self) -> String                // IANA 时区名
pub fn DateTime::to_rfc3339(self) -> String           // "2016-05-10T12:00:00+01:00"
pub fn DateTime::to_string(self) -> String
pub fn DateTime::format(self, fmt : String) -> String
pub fn DateTime::with_timezone(self : DateTime, tz : Tz) -> DateTime
```

### Date（仅年月日 + 时区）

```moonbit
pub struct Date {
  tz : Tz
  year : Int32
  month : Int32
  day : Int32
} derive(Eq, Compare, Show)

pub fn Date::make(tz : Tz, year : Int32, month : Int32, day : Int32) -> Date
pub fn Date::and_hms(self : Date, h : Int32, m : Int32, s : Int32) -> DateTime
pub fn Date::and_hms_opt(self : Date, h : Int32, m : Int32, s : Int32) -> LocalResult[DateTime]
```

### TzOffset（时区偏移）

```moonbit
pub struct TzOffset {
  tz : Tz
  span : FixedTimespan
} derive(Eq, Show)

pub fn TzOffset::make(tz : Tz, span : FixedTimespan) -> TzOffset
pub fn TzOffset::offset_sec(self) -> Int32
pub fn TzOffset::offset(self) -> String              // "+08:00"
pub fn TzOffset::abbreviation(self) -> String        // "CST"
pub fn TzOffset::tz_id(self) -> String
pub fn TzOffset::to_string(self) -> String
```

### LocalResult[T]（DST 三分支）

```moonbit
pub enum LocalResult[T] {
  Single(T)
  Ambiguous(T, T)
  None
} derive(Eq, Compare, Show)

pub fn[T] LocalResult::earliest(self : LocalResult[T]) -> T       // Ambiguous 取早，其余 unwrap
pub fn[T] LocalResult::latest(self : LocalResult[T]) -> T         // Ambiguous 取晚
pub fn[T] LocalResult::single(self : LocalResult[T]) -> T?        // 仅 Single 返回 Some
pub fn[T] LocalResult::unwrap(self : LocalResult[T]) -> T         // Single 返回值，其余 fail!
```

### TimeZone trait

```moonbit
pub trait TimeZone {
  fn offset_from_utc_date_time(Self, NaiveDateTime) -> TzOffset
  fn offset_from_local_date_time(Self, NaiveDateTime) -> LocalResult[TzOffset]
}
```

`Tz` 实现 `TimeZone`。允许未来动态时区实现同一接口。

### DateTimeLike trait

```moonbit
pub trait DateTimeLike {
  fn year(Self) -> Int64
  fn month(Self) -> Int64
  fn day(Self) -> Int64
  fn weekday(Self) -> Int64
  fn ordinal(Self) -> Int64
  fn days_in_month(Self) -> Int64
  fn is_leap_year(Self) -> Bool
}
```

`NaiveDateTime`/`DateTime`/`Date` 实现 `DateTimeLike`，消除日历方法重复（见 ADR-006）。

### GapInfo（DST 缺口信息）

```moonbit
pub struct GapInfo {
  begin : (NaiveDateTime, TzOffset)?
  end : DateTime?
} derive(Eq, Show)

pub fn GapInfo::detect(dt : NaiveDateTime, tz : Tz) -> GapInfo?
```

### CjDuration

```moonbit
pub struct CjDuration { secs : Int64 } derive(Eq, Compare, Show)

pub fn CjDuration::make(secs : Int64) -> CjDuration
pub fn CjDuration::of_seconds(secs : Int64) -> CjDuration
pub fn CjDuration::minutes(m : Int64) -> CjDuration
pub fn CjDuration::hours(h : Int64) -> CjDuration
pub fn CjDuration::zero() -> CjDuration
```

### 错误类型

```moonbit
suberror TzError {
  InvalidTzName(String)
  InvalidDate(Int64, Int64, Int64)    // year, month, day
  InvalidTime(Int64, Int64, Int64)    // hour, min, sec
} derive(Debug, Show)

pub extend TzError with Debug::{to_repr}
pub extend TzError with Show::{to_string}
```

---

## 使用示例

```moonbit
///|
test "tz_basic" {
  let london = @tz.Tz::from_str("Europe/London").unwrap()
  let shanghai = @tz.Tz::from_str("Asia/Shanghai").unwrap()

  let dt_london = london.ymd(2016, 5, 10).and_hms(12, 0, 0)
  assert_eq(dt_london.to_rfc3339(), "2016-05-10T12:00:00+01:00")
  assert_eq(dt_london.abbreviation(), "BST")
  assert_eq(dt_london.offset_sec(), 3600)

  let dt_shanghai = dt_london.with_timezone(shanghai)
  assert_eq(dt_shanghai.to_rfc3339(), "2016-05-10T19:00:00+08:00")
  assert_eq(dt_london.timestamp(), 1462878000L)
}

///|
test "dst_gap" {
  let ny = @tz.Tz::from_str("America/New_York").unwrap()
  let spring_gap = @tz.NaiveDateTime::make(2026L, 3L, 8L, 2L, 30L, 0L)
  match ny.offset_from_local_date_time(spring_gap) {
    R::None => assert_true(true)      // 春进缺口
    _ => fail!("expected None")
  }
}
```

> 文件结束 | chrono_tz-mbt api v2.0 | 2026-11-05