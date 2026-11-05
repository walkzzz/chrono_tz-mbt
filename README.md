# chrono_tz-mbt

MoonBit IANA 时区库，移植自 [chrono_tz_cangjie](https://github.com/chronotope/chrono-tz)（仓颉 v2.157.0，Rust chrono-tz 0.11.0）。

聚焦 IANA tzdata 2025b（597 时区）+ DST 三分支 + Hinnant civil↔days + RFC3339 + strftime/strptime。

## 功能特性

- **597 个 IANA 时区** — 覆盖全球所有 tzdata 2025b 时区
- **DST 自动处理** — Gap（春季前跳）/ Ambiguous（秋季回拨）/ Normal 三分支
- **Hinnant 算法** — civil↔days 互逆转换，无浮点运算
- **RFC3339 解析/格式化** — `parse_rfc3339` / `to_rfc3339` 往返一致
- **strftime/strptime** — `%Y %m %d %H %M %S %Z %z %A %a %B %b %j %%` 等
- **时区转换** — `with_timezone` 跨时区 DateTime 转换
- **根包便捷 API** — 14 个无状态函数（`tz_from_str`/`offset_from_utc`/`convert_timezone`/`to_rfc3339`/`parse_rfc3339`/`strftime`/`strptime`/`detect_gap`/`from_local` 等），委托 `@tz` 完成常见操作
- **JSON 序列化** — DateTime / NaiveDateTime 的 `to_json` / `to_json_compact`
- **MCP 服务器** — 7 个时区工具（list_timezones / get_offset / convert_time / parse_rfc3339 / format_time / get_current_time / detect_dst）
- **CLI 工具** — 10 个子命令（list / info / convert / now / parse / format / dst / search / diff / repl）
- **LLM Agent** — DeepSeek 流式聊天 + 时区上下文注入 + 7 个 tz: 工具调用（now / convert / offset / dst / search / list / help）
- **四后端支持** — wasm / wasm-gc / js / native 全通过（`moon check --target all` + `moon test --target all` 201/201 ✓），`--deny-warn` 零警告强制
- **POSIX TZ footer 外推** — 超出内置 transition 后用 IANA POSIX TZ footer（如 `EST5EDT,M3.2.0,M11.1.0`）外推未来 DST 规则，引入 `caijiewei295/tzif-engine` 依赖

## 安装

```toml
# moon.mod
import {
  "walkzzz/chrono_tz-mbt/tz" @tz,
}
```

## 快速开始

```moonbit
let tz = @tz.Tz::from_str("Asia/Shanghai").unwrap()
let naive = @tz.NaiveDateTime::from_timestamp(0L)
let utc_tz = @tz.Tz::from_str("UTC").unwrap()
let off = utc_tz.offset_from_utc_date_time(naive)
let dt = @tz.DateTime::make(0L, off)
let shanghai_dt = dt.with_timezone(tz)
println(shanghai_dt.to_rfc3339())  // 1970-01-01T08:00:00+08:00
```

## API 概览

### Tz 枚举（597 时区）

| 方法 | 签名 | 说明 |
|------|------|------|
| `from_str` | `(String) -> Tz?` | 二分查找解析时区名 |
| `name` | `(Tz) -> String` | 时区名（如 `"Asia/Shanghai"`） |
| `all` | `() -> Array[Tz]` | 全部 597 时区 |
| `all_names` | `() -> Array[String]` | 全部时区名 |
| `offset_from_utc_date_time` | `(Tz, NaiveDateTime) -> TzOffset` | UTC→本地偏移 |
| `offset_from_local_date_time` | `(Tz, NaiveDateTime) -> LocalResult[TzOffset]` | 本地→UTC 偏移（三分支） |
| `timespans` | `(Tz) -> FixedTimespanSet` | 时区所有时间段 |

### DateTime / NaiveDateTime / Date

| 方法 | 签名 | 说明 |
|------|------|------|
| `NaiveDateTime::from_timestamp` | `(Int64) -> NaiveDateTime` | Unix 时间戳→naive |
| `DateTime::make` | `(Int64, TzOffset) -> DateTime` | 时间戳+偏移→DateTime |
| `DateTime::parse_rfc3339` | `(String) -> DateTime?` | RFC3339 解析 |
| `DateTime::to_rfc3339` | `(DateTime) -> String` | RFC3339 格式化 |
| `DateTime::with_timezone` | `(DateTime, Tz) -> DateTime` | 时区转换 |
| `DateTime::strftime` | `(DateTime, String) -> String` | strftime 格式化 |
| `Date::and_hms_opt` | `(Date, Int, Int, Int) -> NaiveDateTime?` | 日期+时分秒 |

### LocalResult[T]（DST 三分支）

```
enum LocalResult[T] {
  Single(T)       // Normal — 唯一解
  Ambiguous(T, T) // 秋季回拨 — 两个解
  None            // 春季前跳 — 无解
}
```

### 根包便捷 API（14 函数）

根包 `walkzzz/chrono_tz-mbt` 提供无状态便捷函数，委托 `@tz` 完成常见操作，调用方不必直接引用 `@tz` 静态方法：

| 函数 | 签名 | 说明 |
|------|------|------|
| `tz_count` | `() -> Int32` | 时区总数（597） |
| `tz_names` | `() -> Array[String]` | 全部时区名 |
| `tz_from_str` | `(String) -> Tz?` | 解析时区名 |
| `tz_name` | `(Tz) -> String` | 时区名 |
| `offset_from_utc` | `(Tz, Int64) -> Int32` | UTC 时间戳→偏移秒 |
| `offset_from_local` | `(Tz, NaiveDateTime) -> LocalResult[TzOffset]` | 本地时刻→偏移（三分支） |
| `datetime_from_timestamp` | `(Int64, Tz) -> DateTime` | 时间戳+时区→DateTime |
| `convert_timezone` | `(DateTime, Tz) -> DateTime` | 时区转换 |
| `to_rfc3339` | `(DateTime) -> String` | RFC3339 格式化 |
| `parse_rfc3339` | `(String) -> DateTime?` | RFC3339 解析 |
| `strftime` | `(String, DateTime) -> String` | strftime 格式化 |
| `strptime` | `(String, String, Tz) -> DateTime?` | strptime 解析 |
| `detect_gap` | `(Tz, NaiveDateTime) -> GapInfo?` | DST gap 检测 |
| `from_local` | `(Tz, NaiveDateTime) -> LocalResult[DateTime]` | 本地时刻→DateTime（三分支） |

## 包结构

```
chrono_tz-mbt/
├── core/          # 零依赖核心类型（Hinnant + FixedTimespan + 全局查表）
├── data/          # 6 大洲 IANA tzdata（38711 行）+ posix_tz.mbt（598 POSIX TZ footer）
├── tz/            # 时区算法（Tz 枚举 + DateTime + DST + RFC3339 + strftime/strptime + POSIX 外推）
├── cmd/mcp/       # MCP 服务器（JSON-RPC + 7 时区工具）
├── cmd/cli/       # CLI 工具（10 子命令）
├── cmd/agent/     # LLM Agent（DeepSeek 流式聊天 + 时区上下文）
├── docs/          # 开发文档（10 份）
├── Makefile       # 工程严格度（--deny-warn --target all 四后端零警告）
└── 根包            # 文档入口 + 14 个便捷函数（tz_from_str/offset_from_utc/convert_timezone/...）
```

## CLI 用法

```bash
moon run cmd/cli -- list                    # 列出全部 597 时区
moon run cmd/cli -- info Asia/Shanghai      # 时区详情（偏移/DST）
moon run cmd/cli -- convert 0 UTC Asia/Shanghai  # 时区转换
moon run cmd/cli -- now Asia/Shanghai       # 当前时间
moon run cmd/cli -- parse "2026-01-01T00:00:00Z"  # RFC3339 解析
moon run cmd/cli -- format "%Y-%m-%d %H:%M" "2026-01-01T00:00:00Z"  # strftime
moon run cmd/cli -- dst Asia/Shanghai       # DST 检测
moon run cmd/cli -- search Shanghai         # 模糊搜索时区名
moon run cmd/cli -- diff Asia/Shanghai America/New_York  # 时差比较
moon run cmd/cli -- repl                    # 交互式 REPL 模式
```

## MCP 服务器

```bash
moon run cmd/mcp  # 启动 JSON-RPC stdio 服务器
```

工具：`list_timezones` / `get_offset` / `convert_time` / `parse_rfc3339` / `format_time` / `get_current_time` / `detect_dst`

## LLM Agent

```bash
# 配置 .env
DEEPSEEK_API_KEY=sk-xxx

moon run cmd/agent  # 启动 DeepSeek 流式聊天（Ctrl+C 中断）
```

Agent 自动注入时区上下文（当前 UTC 时间 + 14 常用时区偏移）到系统提示，并支持直接调用 7 个时区工具：`tz:now` / `tz:convert` / `tz:offset` / `tz:dst` / `tz:search` / `tz:list` / `tz:help`。

## 构建与测试

```bash
moon check                    # 类型检查
moon test --target native     # 运行测试（201 个，native target）
moon info                     # 更新 .mbti 接口
moon fmt                      # 格式化
```

> 注：WASM target 有 597 match arm local count 限制，需用 `--target native`。

## Sprint 进度

| Sprint | 内容 | 状态 |
|--------|------|------|
| S1 | core 包 — Hinnant + FixedTimespan + 全局查表 | ✅ |
| S2 | data 包 + Tz 枚举 597 + from_str | ✅ |
| S3 | NaiveDateTime / Date / Duration | ✅ |
| S4 | TzOffset + LocalResult + TimeZone trait | ✅ |
| S5 | DateTime + DST + GapInfo | ✅ |
| S6 | strftime / strptime / RFC3339 | ✅ |
| S7 | 黑盒/白盒/基准测试（全 597 扫描） | ✅ |
| S8 | quickcheck + JSON 序列化 | ✅ |
| S9 | MCP 服务器 | ✅ |
| S10 | CLI 工具 | ✅ |
| S11 | LLM Agent | ✅ |
| S12 | 根包文档 + hackathon 申报书 | ✅ |
| S13 | 消除 warning + strptime 扩展 + CLI 增强 + Agent 工具集成 | ✅ |
| S14 | 文档完善 + 元数据修正 | ✅ |
| S15 | 根包便捷 API 扩展（2→14 函数）+ 接口文档完善 | ✅ |

## 许可证

Apache-2.0