# Sprint 任务拆解 / Sprint Task Breakdown

> S1-S17 每个 Sprint 的详细任务拆解：文件/函数/测试清单。
> 比 roadmap.md 更细，供实现时逐项打勾。

## S1：core 包 — 核心类型 + 全局查表 + Hinnant 算法

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `core/moon.pkg` | 包配置（无依赖） | 3 |
| `core/timezone_core.mbt` | FixedTimespan/Span/FixedTimespanSet + 查表 | ~200 |
| `core/hinnant.mbt` | days_from_civil/civil_from_days | ~60 |
| `core/timezone_core_wbtest.mbt` | 白盒测试 | ~100 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `FixedTimespan::make` | `(offset~ : Int32, name~ : String) -> FixedTimespan` | 构造 |
| `Span::make` | `(begin~ : Int64?, end~ : Int64?) -> Span` | 构造 |
| `Span::cmp` | `(Self, Int64) -> Ordering` | 区间比较 |
| `Span::contains` | `(Self, Int64) -> Bool` | 区间包含 |
| `FixedTimespanSet::make` | `(first~ : FixedTimespan, rest~ : Array[(Int64, FixedTimespan)]) -> FixedTimespanSet` | 构造（含查表索引化） |
| `FixedTimespanSet::make_compact` | `(firstOffsetIdx~, firstAbbrIdx~, restCompact~) -> FixedTimespanSet` | 压缩构造（data 包用） |
| `FixedTimespanSet::len` | `(Self) -> Int64` | 段数 |
| `FixedTimespanSet::utc_span` | `(Self, Int64) -> Span` | UTC 区间 |
| `FixedTimespanSet::local_span` | `(Self, Int64) -> Span` | 本地区间 |
| `FixedTimespanSet::get` | `(Self, Int64) -> FixedTimespan` | 取段（查表还原） |
| `FixedTimespanSet::offset_at` | `(Self, Int64) -> Int32` | 取偏移（直接查表） |
| `FixedTimespanSet::name_at` | `(Self, Int64) -> String` | 取缩写（直接查表） |
| `days_from_civil` | `(year, month, day : Int64) -> Int64` | Hinnant civil→days |
| `civil_from_days` | `(days : Int64) -> (Int64, Int64, Int64)` | Hinnant days→civil |
| `lookup_offset_idx` | `(Int32) -> Int64` | 内部：二分查偏移表 |
| `lookup_abbr_idx` | `(String) -> Int64` | 内部：线性查缩写表 |

### 全局常量

| 常量 | 类型 | 条目数 |
|------|------|--------|
| `TZ_OFFSET_TABLE` | `Array[Int32]` | 406 |
| `TZ_NAME_TABLE` | `Array[String]` | 178 |

### 测试清单

- [ ] `FixedTimespan` 构造与字段访问
- [ ] `Span::cmp` 全 8 种边界组合
- [ ] `Span::contains` 全 4 种边界组合
- [ ] `FixedTimespanSet::utc_span` 首段/中间/末段
- [ ] `FixedTimespanSet::local_span` 首段/中间/末段 + DST 偏移
- [ ] `FixedTimespanSet::get`/`offset_at`/`name_at` 一致性
- [ ] `days_from_civil` 已知值（1970-01-01→0, 2000-01-01→10957）
- [ ] `civil_from_days` 已知值（0→1970-01-01, 10957→2000-01-01）
- [ ] `days_from_civil ∘ civil_from_days = id` 往返（@quickcheck）
- [ ] 负 days（公元前）正确性

### 验收门禁

- `moon check` 通过
- `moon test` 通过
- `moon info` 生成的 `.mbti` 符合 api.md 契约

---

## S2：data 包 — 6 大洲数据 + tz_variants

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `data/moon.pkg` | 依赖 `core` | 3 |
| `data/data_africa.mbt` | 非洲时区常量 | ~300 |
| `data/data_america.mbt` | 美洲 | ~800 |
| `data/data_asia.mbt` | 亚洲 | ~500 |
| `data/data_australasia.mbt` | 大洋洲 | ~200 |
| `data/data_europe.mbt` | 欧洲 | ~600 |
| `data/data_others.mbt` | 南极/大西洋/印度洋/太平洋/Etc/UTC 等 | ~400 |
| `tz/tz_variants.mbt` | Tz 枚举 597 + name + from_str + NAME_TO_TZ | ~1940 |
| `tz/moon.pkg` | 依赖 `core`（tz_variants 不依赖 data） | 3 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `Tz::name` | `(Self) -> String` | variant → IANA ID |
| `Tz::from_str` | `(String) -> Tz?` | IANA ID → variant |
| `Tz::from_str_exn` | `(String) -> Tz raise TzError` | 同上但抛错 |
| 各时区 `timespans` | `(Tz) -> FixedTimespanSet` | 返回该时区预计算表（S5 实现，S2 仅声明） |

### 数据生成

从源仓颉 `src/data/data_*.cj` 逐文件转换：
1. 提取每个时区的 `FixedTimespanSet` 构造调用
2. 转换为 MoonBit `FixedTimespanSet::make_compact(...)` 调用
3. 保持 firstOffsetIdx/firstAbbrIdx/restCompact 不变

### 测试清单

- [ ] 597 variant `name()` 返回值与 IANA ID 一致
- [ ] `from_str(name(tz)) == Some(tz)` 往返（全 597）
- [ ] `from_str("invalid") == None`
- [ ] `from_str_exn("invalid") raise InvalidTzName`
- [ ] 各大洲数据文件 `moon check` 通过

### 验收门禁

- `moon check` 通过
- `moon test` 通过
- 597 时区全部可 `from_str` 解析

---

## S3：tz 包 — NaiveDateTime/Date/Duration

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `tz/datetime.mbt` | NaiveDateTime/Date/Duration + Hinnant 集成 | ~300 |
| `tz/datetime_wbtest.mbt` | 白盒测试 | ~150 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `NaiveDateTime::make` | `(Int64, Int64, Int64, Int64, Int64, Int64) -> NaiveDateTime raise TzError` | 构造+校验 |
| `NaiveDateTime::from_timestamp` | `(Int64) -> NaiveDateTime` | 时间戳→civil |
| `NaiveDateTime::timestamp` | `(Self) -> Int64` | civil→时间戳 |
| `NaiveDateTime::year/month/day/hour/min/sec` | `(Self) -> Int64` | 字段访问 |
| `NaiveDateTime::weekday` | `(Self) -> Int64` | 星期（0=周日） |
| `NaiveDateTime::ordinal` | `(Self) -> Int64` | 年积日 |
| `NaiveDateTime::days_in_month` | `(Self) -> Int64` | 月天数 |
| `NaiveDateTime::is_leap_year` | `(Self) -> Bool` | 闰年 |
| `NaiveDateTime::to_string` | derive Show | YYYY-MM-DD HH:MM:SS |
| `Date::make` | `(Int64, Int64, Int64) -> Date raise TzError` | 构造+校验 |
| `Date::from_ordinal` | `(Int64, Int64) -> Date raise TzError` | 年+积日 |
| `Duration` 相关 | 加减/比较 | — |

### 测试清单

- [ ] `make` 合法/非法日期（2/29 闰年/平年、4/31 等）
- [ ] `from_timestamp` / `timestamp` 往返
- [ ] 已知时间戳：1970-01-01T00:00:00→0, 2000-01-01T00:00:00→946684800
- [ ] 负时间戳：1969-12-31T23:59:59→-1
- [ ] `weekday` 已知值（2000-01-01=周六=6）
- [ ] `ordinal` 已知值（2000-03-01=61）
- [ ] `days_in_month` 闰年二月=29
- [ ] `is_leap_year` 2000=true, 1900=false, 2024=true

### 验收门禁

- `moon check` + `moon test` 通过
- Hinnant 往返性质 @quickcheck

---

## S4：tz 包 — TzOffset/LocalResult/TimeZone trait

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `tz/timezone_impl.mbt` | TzOffset/LocalResult/TimeZone/GapInfo/binary_search | ~200 |
| `tz/timezone_impl_wbtest.mbt` | 白盒测试 | ~100 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `TzOffset::make` | `(Int32) -> TzOffset raise TzError` | 构造+范围校验 |
| `TzOffset::seconds` | `(Self) -> Int32` | 偏移秒数 |
| `TzOffset::to_string` | derive Show | +HH:MM |
| `LocalResult::earliest` | `(Self[T]) -> T raise Failure` | 取最早（None 抛 fail!） |
| `LocalResult::latest` | `(Self[T]) -> T raise Failure` | 取最晚 |
| `LocalResult::unwrap` | `(Self[T]) -> T raise Failure` | 取唯一（非 Single 抛 fail!） |
| `LocalResult::is_single` | `(Self[T]) -> Bool` | 判定 |
| `binary_search` | `(Array[(Int64, Int64, Int64)], Int64) -> Int64` | 二分查 transitions |
| `TimeZone` trait | `offset_from_utc_date_time`/`offset_from_local_date_time` | — |
| `DateTimeLike` trait | `year`/`month`/`day`/`weekday`/... | — |

### 测试清单

- [ ] `TzOffset` 合法/非法偏移
- [ ] `LocalResult` 三分支 earliest/latest/unwrap
- [ ] `binary_search` 已知 transitions 查找
- [ ] `TimeZone` trait `Tz` 实现（S5 完成后测）

### 验收门禁

- `moon check` + `moon test` 通过

---

## S5：tz 包 — timespans() + DST 算法 + DateTime

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `tz/tz_impl.mbt` | timespans() + offset_from_utc/local + DateTime | ~300 |
| `tz/tz_impl_wbtest.mbt` | 白盒测试 | ~150 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `Tz::timespans` | `(Self) -> FixedTimespanSet` | 返回预计算表（查 data 包） |
| `Tz::offset_from_utc_date_time` | `(Self, NaiveDateTime) -> TzOffset` | UTC→偏移（二分） |
| `Tz::offset_from_local_date_time` | `(Self, NaiveDateTime) -> LocalResult[TzOffset]` | 本地→偏移（三分支） |
| `DateTime::make` | `(NaiveDateTime, Tz) -> DateTime` | 构造 |
| `DateTime::from_local` | `(NaiveDateTime, Tz) -> LocalResult[DateTime]` | 本地→时区时刻 |
| `DateTime::from_utc` | `(NaiveDateTime, Tz) -> DateTime` | UTC→时区时刻 |
| `DateTime::naive` | `(Self) -> NaiveDateTime` | 取本地 civil |
| `DateTime::naive_utc` | `(Self) -> NaiveDateTime` | 取 UTC civil |
| `DateTime::timezone` | `(Self) -> Tz` | 取时区 |
| `DateTime::offset` | `(Self) -> TzOffset` | 取偏移 |
| `DateTime::timestamp` | `(Self) -> Int64` | UTC 时间戳 |

### 测试清单

- [ ] `timespans` 全 597 时区非空
- [ ] `offset_from_utc_date_time` 已知值（UTC 0, Asia/Shanghai +28800, America/New_York EST -18000/EDT -14400）
- [ ] `offset_from_local_date_time` 正常/秋退重叠/春进缺口
- [ ] `DateTime::from_local` 三分支
- [ ] `DateTime::timestamp` 与 NaiveDateTime 一致性
- [ ] DST 转换日：2026-03-08 02:30 America/New_York = None（春进）
- [ ] DST 转换日：2026-11-01 01:30 America/New_York = Ambiguous（秋退）

### 验收门禁

- `moon check` + `moon test` 通过
- DST 三分支正确

---

## S6：tz 包 — 格式化/解析

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `tz/tz_format.mbt` | strftime/strptime/RFC3339 | ~250 |
| `tz/tz_format_wbtest.mbt` | 白盒测试 | ~100 |

### 函数清单

| 函数 | 签名 | 说明 |
|------|------|------|
| `strftime` | `(String, DateTime) -> String` | 格式化 |
| `strptime` | `(String, String, Tz) -> DateTime raise TzError` | 解析 |
| `RFC3339::format` | `(DateTime) -> String` | RFC3339 输出 |
| `RFC3339::parse` | `(String) -> DateTime raise TzError` | RFC3339 解析 |

### 测试清单

- [ ] strftime 常用 specifier：%Y %m %d %H %M %S %Z %z %A %a %j
- [ ] strptime 往返
- [ ] RFC3339 已知值：`2026-11-04T12:00:00+08:00`
- [ ] RFC3339 边界：Z 后缀、偏移正负、毫秒

### 验收门禁

- `moon check` + `moon test` 通过

---

## S7：测试 — 黑盒/快照/性质/基准

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `chrono_tz-mbt_test.mbt` | 黑盒测试（公开 API） | ~300 |
| `tz/tz_bench.mbt` | 基准测试 | ~100 |

### 测试清单

- [ ] 全 597 时区 `from_str` 往返
- [ ] 全 597 时区 `offset_from_utc_date_time` 非异常
- [ ] DST 转换日全时区扫描
- [ ] Hinnant 往返 @quickcheck
- [ ] 与 moon-chrono_tz 输出对比快照
- [ ] 基准：from_str / offset_from_utc / timestamp / strftime

### 验收门禁

- `moon test` 全通过
- `moon test --bench` 基准达标（见 performance.md）
- `moon coverage analyze` 覆盖率 > 90%

---

## S8：可选扩展 — quickcheck + 序列化

### 文件清单

| 文件 | 内容 | 行数估算 |
|------|------|---------|
| `tz/tz_quickcheck_wbtest.mbt` | 7 Hinnant @quickcheck 性质测试 | ~120 |
| `tz/tz_serialize.mbt` | DateTime/NaiveDateTime JSON 序列化 | ~80 |
| `tz/tz_serialize_wbtest.mbt` | 5 序列化白盒测试 | ~60 |

### 验收门禁

- `moon check` + `moon test --target native` 通过（130 测试）
- quickcheck 性质：civil↔day 互逆 + timestamp 往返 + 分量范围

---

## S9：MCP 服务器

### 文件清单

| 文件 | 内容 |
|------|------|
| `cmd/mcp/moon.pkg` | 依赖 tz + json + utf8，native target，executable |
| `cmd/mcp/main.mbt` | C FFI stdio + JSON-RPC 协议 + 7 时区工具 |

### 工具清单

`list_timezones` / `get_offset` / `convert_time` / `parse_rfc3339` / `format_time` / `get_current_time` / `detect_dst`

### 验收门禁

- `moon check` 通过，`moon test --target native` 130 测试通过

---

## S10：CLI 工具

### 文件清单

| 文件 | 内容 |
|------|------|
| `cmd/cli/moon.pkg` | 依赖 tz + json + utf8 + env，native target，executable |
| `cmd/cli/main.mbt` | 10 子命令 + 参数解析 + usage |

### 子命令清单

`list` / `info` / `convert` / `now` / `parse` / `format` / `dst` / `search` / `diff` / `repl`

### 验收门禁

- `moon check` 通过，`moon test --target native` 130 测试通过

---

## S11：LLM Agent

### 文件清单

| 文件 | 内容 |
|------|------|
| `cmd/agent/moon.pkg` | 依赖 tz + json + env + async/http/fs/stdio + tty/input/color，native target，executable |
| `cmd/agent/main.mbt` | DeepSeek 流式聊天（SSE）+ 系统提示注入时区上下文 + 思考过程灰色显示 + Ctrl+C 中断 + 多轮对话 |

### 验收门禁

- `moon check` 通过，`moon test --target native` 130 测试通过

---

## S12：根包文档 + hackathon 申报书

### 文件清单

| 文件 | 内容 |
|------|------|
| `moon.pkg`（根） | 添加 `walkzzz/chrono_tz-mbt/tz` 依赖 |
| `chrono_tz-mbt.mbt` | 文档入口（包结构 + 快速开始示例） |
| `chrono_tz-mbt_wbtest.mbt` | 6 白盒测试 |
| `chrono_tz-mbt_test.mbt` | 5 黑盒测试 |
| `README.md` | 完整项目文档 |
| `README.mbt.md` | 包级别简短文档 |
| `hackathon2026_moon_cross_proposal.md` | 修复乱码/重复段落 |

### 验收门禁

- `moon check` + `moon test --target native` 141 测试通过

---

## S13：消除 warning + strptime 扩展 + CLI 增强 + Agent 工具集成

### 文件清单

| 文件 | 内容 |
|------|------|
| `chrono_tz-mbt.mbt` | 添加 `tz_count`/`tz_names` 引用 @tz |
| `tz/tz_bench.mbt` | 引用 @bench/@quickcheck |
| `tz/tz_format.mbt` | strptime 扩展支持 %Y %m %d %H %M %S %y %j %B %b %A %a %Z %z %% 及字面字符 |
| `tz/tz_format_wbtest.mbt` | 8 个新 strptime 测试 |
| `cmd/cli/main.mbt` | 3 新子命令：search/diff/repl |
| `cmd/agent/main.mbt` | MCP 工具调用集成：tz:now/convert/offset/dst/search/list/help |
| `hackathon2026_chrono_tz_mbt_proposal.md` | 本项目申报书 |

### 验收门禁

- `moon check` 0 warnings + `moon test --target native` 147 测试通过
- `moon info` + `moon fmt` 通过

---

## S15：根包便捷 API 扩展 + 接口文档完善

### 文件清单

| 文件 | 内容 |
|------|------|
| `chrono_tz-mbt.mbt` | 新增 12 个便捷 pub fn（tz_from_str/tz_name/offset_from_utc/offset_from_local/datetime_from_timestamp/convert_timezone/to_rfc3339/parse_rfc3339/strftime/strptime/detect_gap/from_local） |
| `chrono_tz-mbt_wbtest.mbt` | 新增 9 个白盒 smoke test |
| `pkg.generated.mbti` | moon info 重新生成（2→14 函数） |

### 新增函数

| 函数 | 签名 | 说明 |
|------|------|------|
| `tz_from_str` | `(String) -> @tz.Tz?` | 解析时区名 |
| `tz_name` | `(@tz.Tz) -> String` | 时区名 |
| `offset_from_utc` | `(@tz.Tz, Int64) -> Int32` | UTC 时间戳→偏移秒 |
| `offset_from_local` | `(@tz.Tz, @tz.NaiveDateTime) -> @tz.LocalResult[@tz.TzOffset]` | 本地时刻→偏移（三分支） |
| `datetime_from_timestamp` | `(Int64, @tz.Tz) -> @tz.DateTime` | 时间戳+时区→DateTime |
| `convert_timezone` | `(@tz.DateTime, @tz.Tz) -> @tz.DateTime` | 时区转换 |
| `to_rfc3339` | `(@tz.DateTime) -> String` | RFC3339 格式化 |
| `parse_rfc3339` | `(String) -> @tz.DateTime?` | RFC3339 解析 |
| `strftime` | `(String, @tz.DateTime) -> String` | strftime 格式化 |
| `strptime` | `(String, String, @tz.Tz) -> @tz.DateTime?` | strptime 解析 |
| `detect_gap` | `(@tz.Tz, @tz.NaiveDateTime) -> @tz.GapInfo?` | DST gap 检测 |
| `from_local` | `(@tz.Tz, @tz.NaiveDateTime) -> @tz.LocalResult[@tz.DateTime]` | 本地时刻→DateTime（三分支） |

### 验收门禁

- `moon check` 0 warnings + `moon test --target native` 201 测试通过
- `moon info` + `moon fmt` 通过

## S16：工程严格度 + POSIX TZ footer 外推

### 文件清单

| 文件 | 内容 |
|------|------|
| `Makefile` | `check` 目标用 `--deny-warn --target all` 四后端零警告强制 |
| `data/posix_tz.mbt` | 598 时区 POSIX TZ footer 字符串查表 |
| `tz/posix_extrapolate.mbt` | `offset_from_utc_extrapolated`/`offset_from_local_extrapolated`（引入 tzif-engine） |
| `tz/posix_extrapolate_wbtest.mbt` | 8 白盒测试 |

### 验收门禁

- `moon check --deny-warn --target all` 0 warnings
- `moon test --target native` 181 测试通过

## S17：Local 宿主时区 + RFC2822/HTTP dates + cron 表达式

### 文件清单

| 文件 | 内容 |
|------|------|
| `tz/tz_local.mbt` | `Tz::local_tz()` 读 `$TZ` 环境变量返回宿主时区 |
| `tz/tz_rfc2822.mbt` | `to_rfc2822`/`parse_rfc2822`/`to_http_date`/`parse_http_date` |
| `tz/tz_cron.mbt` | `Cron` struct + `parse`/`matches`/`next`（5 字段，dom∧dow OR 语义，timespans 缓存） |
| `tz/tz_local_wbtest.mbt` | 4 白盒测试 |
| `tz/tz_rfc2822_wbtest.mbt` | 10 白盒测试 |
| `tz/tz_cron_wbtest.mbt` | 14 白盒测试 |

### 验收门禁

- `moon check --deny-warn --target all` 0 warnings
- `moon test --target native` 201 测试通过

> 文件结束 | chrono_tz-mbt sprint-tasks v2.2 | 2026-11-05