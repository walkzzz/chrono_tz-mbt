# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Project Structure

- MoonBit packages are organized per directory; each directory contains a
  `moon.pkg` file listing its dependencies. Each package has its files and
  blackbox test files (ending in `_test.mbt`) and whitebox test files (ending in
  `_wbtest.mbt`).

- In the toplevel directory, there is a `moon.mod` file listing module
  metadata.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon ide` provides project navigation helpers like `peek-def`, `outline`, and
  `find-references`. See $moonbit-agent-guide for details.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check tests pass. MoonBit supports snapshot testing; when
  changes affect outputs, run `moon test --update` to refresh snapshots.

- Prefer `assert_eq` or `assert_true(pattern is Pattern(...))` for results that
  are stable or very unlikely to change. For snapshot tests that record
  structured debugging output, derive `Debug` and use `debug_inspect`, rather
  than deriving `Show` for debugging. For solid, well-defined results (e.g.
  scientific computations), prefer assertion tests. You can use
  `moon coverage analyze > uncovered.log` to see which parts of your code are
  not covered by tests.
## Project: chrono_tz-mbt

时区核心库，移植自 `chrono_tz_cangjie`（仓颉 v2.157.0，Rust chrono-tz 0.11.0）。
聚焦 IANA tzdata 2025b（597 时区）+ DST + Hinnant + RFC3339。不含农历/术数。

### 每轮结束流程（用户要求）

每轮迭代结束后依次执行：
1. 更新记忆（`C:\Users\Administrator\.codeartsdoer\memory\E--CodeArts-forMoon-chrono_tz-mbt\`）
2. 更新本 AGENTS.md
3. 更新 .gitignore
4. 提交仓库（`git add -A && git commit`）
5. 推送远程（`git push`）
6. 继续迭代

### Sprint 状态

- **S1 core 包** ✅ 完成（moon check ✓ + moon test 11/11 ✓ + moon info ✓ + moon fmt ✓）
  - `core/hinnant.mbt` — Hinnant civil↔days
  - `core/timezone_core.mbt` — Ordering + FixedTimespan + Span + FixedTimespanSet + 全局查表(406+178)
  - `core/timezone_core_wbtest.mbt` — 11 白盒测试
- **S2 data 包 + tz_variants** ✅ 完成（moon check ✓ + moon test 14/14 ✓ + moon info ✓ + moon fmt ✓）
  - `data/` — 6 大洲数据文件（38711 行，从 moon-chrono_tz 复制事实性 IANA tzdata）
  - `tz/tz_variants.mbt` — Tz 枚举 597 + name + from_str（独立重写，纯二分查找，去掉 LRU 缓存）
  - `tz/tz_variants_test.mbt` — 3 黑盒测试
- **S3 tz 包 — NaiveDateTime/Date/Duration** ✅ 完成（moon check ✓ + moon test 42/42 ✓ + moon info ✓ + moon fmt ✓）
  - `tz/datetime.mbt` — Duration + NaiveDateTime + Date（~340 行，集成 Hinnant 算法）
  - `tz/datetime_wbtest.mbt` — 28 白盒测试
- **S4 tz 包 — tz_offset / local_result / trait** ✅ 完成（moon check ✓ + moon test 54/54 ✓ + moon info ✓ + moon fmt ✓）
  - `tz/timezone_impl.mbt` — TzError suberror + binary_search + TzOffset + LocalResult[T] + TimeZone trait（~140 行）
  - `tz/timezone_impl_wbtest.mbt` — 12 白盒测试
  - `core/timezone_core.mbt` — Ordering 改 `pub(all) enum` 供外部包构造
- **S5 tz 包 — tz_impl / DateTime / DST** ✅ 完成（moon check ✓ + moon test 76/76 ✓ native + moon info ✓ + moon fmt ✓）
  - `tz/tz_impl.mbt` — Tz::timespans(597 arm) + offset_from_utc/local + GapInfo（~730 行）
  - `tz/tz_impl_wbtest.mbt` — 22 白盒测试（offset/DST gap/ambiguous/DateTime/from_local/GapInfo）
  - `tz/datetime.mbt` — 追加 DateTime + Tz::from_local_date_time + Date::and_hms_opt/and_hms_tz（~155 行）
  - `tz/timezone_impl.mbt` — `pub trait` → `pub(open) trait` 供 Tz 实现
  - 注：WASM target 有 597 match arm local count 限制，用 native target 测试
- **S6 tz 包 — strftime/strptime/RFC3339** ✅ 完成（moon check ✓ + moon test 100/100 ✓ native + moon info ✓ + moon fmt ✓）
  - `tz/tz_format.mbt` — strftime(%Y%m%d%H%M%S%Z%z%A%a%B%b%j%%) + strptime(简化) + DateTime::parse_rfc3339（~270 行）
  - `tz/tz_format_wbtest.mbt` — 24 白盒测试（strftime 各 specifier/RFC3339 往返/strptime）
  - 注：`RFC3339::format`/`RFC3339::parse` 命名不合法（RFC3339 非类型），format 委托已有 `DateTime::to_rfc3339`，parse 改为 `DateTime::parse_rfc3339`
- **S7 tz 包 — 测试（黑盒/白盒/基准）** ✅ 完成（moon check ✓ + moon test 118/118 ✓ native + moon info ✓ + moon fmt ✓）
  - `tz/tz_variants.mbt` — 新增 `Tz::all() -> Array[Tz]` + `Tz::all_names() -> Array[String]`（遍历 name_to_tz 表，避免 597 match arm WASM 限制）
  - `tz/tz_variants_test.mbt` — 新增 2 黑盒测试（全 597 from_str↔name 往返 + all_names 一致性）
  - `tz/tz_all_wbtest.mbt` — 10 白盒测试（全 597 offset/timespans/DateTime/strftime 扫描 + DST 检测 + UTC 零偏移）
  - `tz/tz_bench_wbtest.mbt` — 6 基准测试（from_str/offset_from_utc/timestamp/strftime/to_rfc3339/parse_rfc3339）
  - `tz/moon.pkg` — 添加 `moonbitlang/core/bench` 依赖
  - 注：Hinnant @quickcheck + 与 moon-chrono_tz 快照对比留 S8 可选扩展
- **S8 tz 包 — 可选扩展（quickcheck/序列化）** ✅ 完成（moon check ✓ + moon test 130/130 ✓ native + moon info ✓ + moon fmt ✓）
  - `tz/tz_quickcheck_wbtest.mbt` — 7 Hinnant @quickcheck 性质测试（civil↔day 互逆 + timestamp 往返 + 分量范围 + weekday/ordinal 范围）
  - `tz/tz_serialize.mbt` — DateTime/NaiveDateTime JSON 序列化（to_json/to_json_compact）
  - `tz/tz_serialize_wbtest.mbt` — 5 序列化白盒测试
  - `tz/moon.pkg` — 添加 `moonbitlang/core/quickcheck` 依赖
- **S9 MCP 服务器** ✅ 完成（moon check ✓ + moon test 130/130 ✓ native + moon info ✓ + moon fmt ✓）
  - `cmd/mcp/moon.pkg` — 依赖 tz + json + utf8，native target，executable
  - `cmd/mcp/main.mbt` — C FFI stdio + JSON-RPC 协议 + 7 个时区工具（list_timezones/get_offset/convert_time/parse_rfc3339/format_time/get_current_time/detect_dst）
- **S10 CLI 工具** ✅ 完成（moon check ✓ + moon test 130/130 ✓ native + moon info ✓ + moon fmt ✓）
  - `cmd/cli/moon.pkg` — 依赖 tz + json + utf8 + env，native target，executable
  - `cmd/cli/main.mbt` — 7 子命令（list/info/convert/now/parse/format/dst）+ 参数解析 + usage
- **S11 LLM Agent** ✅ 完成（moon check ✓ + moon test 130/130 ✓ native + moon info ✓ + moon fmt ✓）
  - `cmd/agent/moon.pkg` — 依赖 tz + json + env + async/http/fs/stdio + tty/input/color，native target，executable
  - `cmd/agent/main.mbt` — DeepSeek 流式聊天（SSE）+ 系统提示注入时区上下文（当前 UTC + 14 常用时区偏移）+ 思考过程灰色显示 + Ctrl+C 中断 + 多轮对话
  - `moon.mod` — 添加 `moonbitlang/async@0.22.5` + `moonbit-community/tty@0.6.2` 依赖
- **S12 根包文档 + hackathon 申报书完善** ✅ 完成（moon check ✓ + moon test 141/141 ✓ native + moon info ✓ + moon fmt ✓）
  - `moon.pkg`（根）— 添加 `walkzzz/chrono_tz-mbt/tz` 依赖
  - `chrono_tz-mbt.mbt` — 文档入口（包结构 + 快速开始示例）
  - `chrono_tz-mbt_wbtest.mbt` — 6 白盒测试（tz API 可从根包访问）
  - `chrono_tz-mbt_test.mbt` — 5 黑盒测试（from_str roundtrip / RFC3339 / 时区转换 / 597时区 / strftime）
  - `README.md` — 完整项目文档（删除符号链接，独立文件：功能特性 / 安装 / API 概览 / CLI/MCP/Agent 用法 / Sprint 进度）
  - `README.mbt.md` — 包级别简短文档（32 行）
  - `hackathon2026_moon_cross_proposal.md` — 修复乱码/重复段落/数据不一致（测试数 2289 / trait 实现 188 / 包数 80）
- **S13 消除 warning + 申报书 + strptime 扩展 + CLI 增强 + Agent 工具集成** ✅ 完成（moon check 0 warnings ✓ + moon test 147/147 ✓ native + moon info ✓ + moon fmt ✓）
  - 消除 3 个 unused_package 警告：根包添加 `tz_count`/`tz_names` 函数引用 @tz；tz 包添加 `tz_bench.mbt` 引用 @bench/@quickcheck
  - 消除 cmd/agent `is_empty` 未使用 + cmd/cli+cmd/mcp `local` 保留关键字 + cmd/cli `utf8` 未使用包
  - `hackathon2026_chrono_tz_mbt_proposal.md` — 本项目申报书（参照 moon-cross 格式）
  - `tz/tz_format.mbt` — strptime 扩展支持 %Y %m %d %H %M %S %y %j %% 及字面字符（通用解析器）
  - `tz/tz_format_wbtest.mbt` — 8 个新 strptime 测试（%y/%j/%%/自定义格式/日期only）
  - `cmd/cli/main.mbt` — 3 个新子命令：search（模糊搜索）/ diff（时差比较）/ repl（交互式模式）
  - `cmd/agent/main.mbt` — MCP 工具调用集成：tz:now/convert/offset/dst/search/list/help 直接调用 tz 包
- **S14 文档完善 + 元数据修正** ✅ 完成（moon check 0 warnings ✓ + moon test 147/147 ✓ native + moon info ✓ + moon fmt ✓）
  - `moon.mod` — 填充 repository（github.com/walkzzz/chrono_tz-mbt.git）/ keywords（8 个）/ description
  - `README.md` — 许可证 MIT→Apache-2.0；Sprint 进度加 S12/S13；CLI 7→10 子命令；Agent 工具描述；测试数 141→147
  - `README.mbt.md` — 完善包级别文档（核心 API 列表 + DST 三分支 + 构建测试 + 许可证）
  - `docs/` 10 份文档全部更新：roadmap（Sprint 表全✅+包结构加 cmd/）/ sprint-tasks（加 S8-S13 拆解）/ api / build-ci（moon.mod 配置+WASM 限制）/ testing / performance / architecture / error-codes / tz-names（from_str 二分查找）/ migration-map — 版本号统一升 v2.0
  - `chrono_tz-mbt.mbt` — 根包文档注释 CLI 7→10 子命令 + Agent 工具调用描述

### MoonBit 语法要点（S1~S6 实践验证）

- **标准库无 `Ordering` 枚举**：`Compare` trait 的 `compare` 返回 `Int32`（负/零/正）；自定义 `pub(all) enum Ordering { Less; Equal; Greater }`（S4 改 pub(all) 供外部构造）
- **`derive(Show)` 已弃用**：用 `derive(Debug)`；`assert_eq` 需 `Debug` trait
- **derive 后必须显式 `pub extend`**：`derive(Eq, Compare, Debug)` 后需三条 `pub extend T with Trait::{method}`，否则警告 `implicit_impl_as_method`
- **`pub extend` 模板**：
  ```
  pub extend T with Eq::{not_equal, equal}
  pub extend T with Compare::{op_lt, op_le, op_ge, compare, op_gt}
  pub extend T with Debug::{to_repr}
  ```
- **moon.pkg 零依赖**：空文件（非 `{}`）
- **Int64 字面量**：`L` 后缀（如 `1000000L`）；Int32 无后缀
- **for 区间**：`0..<n` 半开（仓颉 `0..n` 含 n）
- **abort 替代 fail!**：MoonBit 无 `fail!` 语法；用 `abort(msg : String) -> T`（泛型返回任意类型）
- **StringView vs String**：`s[:10]` 返回 `StringView` 非 `String`，拼接需 `.to_string()` 或直接构造
- **`<>` 不合法**：MoonBit 不等用 `!=`（`Eq::not_equal`）
- **suberror 语法**：`pub(all) suberror TzError { Variant(T); ... } derive(Debug)` + `pub extend TzError with Debug::{to_repr}`；自动提升 Error，可用 `raise TzError(...)` 抛错
- **`pub enum` vs `pub(all) enum`**：`pub enum` 外部包只能 match 不能构造；`pub(all) enum` 可构造（黑盒测试需 pub(all)）
- **Int32 无 to_int**：`Int32` 只有 `to_int64`；数组 `arr[i]` 需 `Int` 索引，`arr.get(i)` 接受 `Int32` 返回 `T?`
- **Int64::to_int 返回 Int32**：`Int64::to_int(self : Int64) -> Int32`（builtin/int64.mbt:795），非返回 Int；Int64→Int32 转换用 `.to_int()`
- **`Foo::bar` 命名要求 Foo 是已存在类型/trait**：不能用 `RFC3339::parse` 形式定义独立函数（RFC3339 非类型）；改为 `DateTime::parse_rfc3339` 或独立函数名

### 文档

开发文档在 `docs/`（10 份）：roadmap / architecture(ADR-001~016) / api / migration-map / testing / performance / error-codes / tz-names / sprint-tasks / build-ci。
