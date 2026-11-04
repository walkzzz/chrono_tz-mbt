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
- **S3 tz 包 — NaiveDateTime/Date/CjDuration** ⏳ 下一步

### MoonBit 语法要点（S1 实践验证）

- **标准库无 `Ordering` 枚举**：`Compare` trait 的 `compare` 返回 `Int32`（负/零/正）；自定义 `pub enum Ordering { Less; Equal; Greater }`
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

### 文档

开发文档在 `docs/`（10 份）：roadmap / architecture(ADR-001~016) / api / migration-map / testing / performance / error-codes / tz-names / sprint-tasks / build-ci。
