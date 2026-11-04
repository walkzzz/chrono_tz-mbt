# 错误码清单 / Error Code Reference

> TzError 所有子错误的完整清单：变体名/字段/触发场景/调用方处理建议。
> 对应 ADR-008 错误分层策略。

## 一、错误分层总览

| 层级 | 机制 | 适用场景 | 调用方处理 |
|------|------|---------|-----------|
| 查无 | `T?`（Option） | `from_str` 未知时区等常态失败 | `match`/`guard!`/`.unwrap_or(default)` |
| 非法输入 | `suberror TzError` + `raise` | 非法日期/时间字段 | `try ... catch { ... }` |
| 不变量破坏 | `fail!("msg")` | 内部逻辑不应到达 | 不处理（编程错误，需修代码） |
| 纯函数 | `noraise` | `days_from_civil` 等 | 无需处理（编译器证明不抛） |

## 二、TzError 子错误清单

```moonbit
suberror TzError {
  InvalidTzName(String)                    // 未知时区名
  InvalidDate(Int64, Int64, Int64)         // 非法日期 (year, month, day)
  InvalidTime(Int64, Int64, Int64)         // 非法时间 (hour, min, sec)
  InvalidDayOfYear(Int64, Int64, Int)      // 非法年积日 (year, ordinal, days_in_year)
  InvalidTimestamp(Int64)                  // 不支持的时间戳范围
  InvalidFormatString(String)              // strftime/strptime 非法格式串
  ParseError(String, Int)                  // 解析失败 (message, position)
  Rfc3339ParseError(String, Int)           // RFC3339 解析失败 (message, position)
  TzOffsetOutOfRange(Int32)               // 偏移秒数超出 [-43200, +50400]
} derive(Debug, Show)
```

## 三、逐变体详解

### InvalidTzName(String)

| 项 | 内容 |
|----|------|
| **字段** | `name : String` — 无法识别的时区名 |
| **触发** | `Tz::from_str_exn(s)`（抛错版）遇到未知时区名 |
| **源对应** | 仓颉 `fromStr` 返回 `Result<Tz, ParseError>`；本项目 `from_str` 返回 `T?`，`from_str_exn` 抛此错 |
| **调用方建议** | 优先用 `from_str`（返回 `T?`）；若用 `from_str_exn`，`catch { InvalidTzName(n) => ... }` 回退到 UTC 或报错 |

### InvalidDate(Int64, Int64, Int64)

| 项 | 内容 |
|----|------|
| **字段** | `year, month, day : Int64` |
| **触发** | `NaiveDateTime::make(y, mo, d, h, mi, s)` 中 month∉[1,12] 或 day∉[1, days_in_month] |
| **源对应** | 仓颉 `NaiveDateTime::validate()` 抛 `Exception("validate failed: y/m/d ...")` |
| **调用方建议** | 构造前自行校验，或 `catch { InvalidDate(y, mo, d) => ... }` 提示用户 |

### InvalidTime(Int64, Int64, Int64)

| 项 | 内容 |
|----|------|
| **字段** | `hour, min, sec : Int64` |
| **触发** | `NaiveDateTime::make(...)` 中 hour∉[0,23] 或 min∉[0,59] 或 sec∉[0,59] |
| **源对应** | 同上 `validate()` |
| **调用方建议** | 同 InvalidDate |

### InvalidDayOfYear(Int64, Int64, Int)

| 项 | 内容 |
|----|------|
| **字段** | `year, ordinal : Int64`，`days_in_year : Int`（365 或 366） |
| **触发** | `Date::from_ordinal(y, ord)` 中 ordinal∉[1, days_in_year] |
| **源对应** | 仓颉无直接对应（本项目新增便利 API） |
| **调用方建议** | `catch { InvalidDayOfYear(y, ord, diy) => ... }` |

### InvalidTimestamp(Int64)

| 项 | 内容 |
|----|------|
| **字段** | `ts : Int64` — 不支持的时间戳 |
| **触发** | `NaiveDateTime::from_timestamp(ts)` 中 ts 超出 Int64 表示范围（极端情况） |
| **源对应** | 仓颉不检查（依赖 Int64 溢出） |
| **调用方建议** | 正常使用不会触发；极端值场景 `catch` |

### InvalidFormatString(String)

| 项 | 内容 |
|----|------|
| **字段** | `fmt : String` — 非法格式串 |
| **触发** | `strftime(fmt, dt)` / `strptime(fmt, s)` 中 fmt 含未知 specifier |
| **源对应** | 仓颉 `tz_format.cj` 相关 |
| **调用方建议** | 格式串通常是常量，开发期即可发现；运行时 `catch` 回退默认格式 |

### ParseError(String, Int)

| 项 | 内容 |
|----|------|
| **字段** | `message : String`，`position : Int` — 输入串中出错位置 |
| **触发** | `strptime(fmt, s)` 中 s 与 fmt 不匹配 |
| **源对应** | 仓颉 `ParseError` 占位结构体（当前未用） |
| **调用方建议** | `catch { ParseError(msg, pos) => ... }` 提示用户出错位置 |

### Rfc3339ParseError(String, Int)

| 项 | 内容 |
|----|------|
| **字段** | `message : String`，`position : Int` |
| **触发** | `RFC3339::parse(s)` 中 s 不符合 RFC3339 格式 |
| **源对应** | 仓颉 `tz_format.cj` 中 RFC3339 解析 |
| **调用方建议** | `catch { Rfc3339ParseError(msg, pos) => ... }` |

### TzOffsetOutOfRange(Int32)

| 项 | 内容 |
|----|------|
| **字段** | `offset : Int32` — 偏移秒数 |
| **触发** | `TzOffset::make(offset)` 中 offset∉[-43200, +50400]（±12h 含历史极端值） |
| **源对应** | 仓颉不检查 |
| **调用方建议** | 正常不会触发（IANA 数据合法）；自定义偏移时 `catch` |

## 四、DST 相关的"非错误"处理

DST 缺口/重叠**不是错误**，是 `LocalResult[T]` 的正常分支（ADR-004）：

| 场景 | LocalResult | 源仓颉行为 | 本项目行为 |
|------|------------|-----------|-----------|
| 正常 | `Single(dt)` | 返回 `Single` | 返回 `Single` |
| 秋退重叠 | `Ambiguous(dt1, dt2)` | 返回 `Ambiguous` | 返回 `Ambiguous` |
| 春进缺口 | `None` | 返回 `None` | 返回 `None` |
| `andHms` 遇缺口/歧义 | 抛 `Exception` | — | `raise TzError` 或返回 `LocalResult` 由调用方 match |

> `LocalResult::unwrap()` 在 None/Ambiguous 时抛 `Failure`（`fail!`），这是编程错误非可恢复错误。

## 五、错误处理示例

```moonbit
// 查无：用 T?
let tz = Tz::from_str("Asia/Shanghai")
match tz {
  Some(t) => println(t.name())
  None => println("未知时区，回退 UTC")
}

// 非法输入：用 raise + catch
try {
  let dt = NaiveDateTime::make(2026, 2, 30, 12, 0, 0)  // 2 月无 30 日
} catch {
  InvalidDate(y, mo, d) => println("\{y}-\{mo}-\{d} 不是合法日期")
}

// DST 三分支：match LocalResult
match tz.offset_from_local_date_time(naive) {
  Single(off) => ...
  Ambiguous(off1, off2) => ...  // 秋退，选 off1（earliest）或 off2（latest）
  None => ...                    // 春进缺口
}
```

> 文件结束 | chrono_tz-mbt error-codes v1.0 | 2026-11-04