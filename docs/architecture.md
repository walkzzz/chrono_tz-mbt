# 架构决策记录 / Architecture Decision Records

> chrono_tz-mbt 关键架构决策及其理由。吸收 MoonBit 错误处理/文档/测试设计思想。

## 目录

- [ADR-001：三包线性结构 + 根重导出](#adr-001)
- [ADR-002：make() 构造函数模式](#adr-002)
- [ADR-003：Hinnant civil↔days 算法](#adr-003)
- [ADR-004：DST 三分支 LocalResult[T]](#adr-004)
- [ADR-005：全局查表去重](#adr-005)
- [ADR-006：trait 系统去重（TimeZone + DateTimeLike）](#adr-006)
- [ADR-007：方法系统 + derive 自动派生](#adr-007)
- [ADR-008：错误处理 suberror + raise + T?](#adr-008)
- [ADR-009：文档注释 /// + mbt check 文档测试](#adr-009)
- [ADR-010：多后端目标](#adr-010)
- [ADR-011：可选 LRU 缓存](#adr-011)
- [ADR-012：属性系统使用策略](#adr-012)
- [ADR-013：derive 派生策略](#adr-013)
- [ADR-014：方法系统 + trait 系统 + 运算符重载策略](#adr-014)
- [ADR-015：包管理与访问控制策略](#adr-015)
- [ADR-016：形式化验证策略（moon prove）](#adr-016)

---

## ADR-001：三包线性结构 + 根重导出

**状态**：已采纳

**背景**：时区库分核心类型、数据表、算法层三块，需决定包组织。

**决策**：`core`（零依赖核心类型）← `data`（纯数据常量）← `tz`（算法）三包，根包 `reexport.mbt` 重导出统一入口 `@chrono_tz-mbt`。

**理由**：
- 关注点分离：`core` 无依赖可被 `data`/`tz` 共用；`data` 纯数据可脚本生成；`tz` 装算法。
- 依赖线性无环：`core ← data ← tz ← root`。
- 按需导入：用户可只 `@tz` 而不拉根包。
- MoonBit 惯例：单 `moon.mod` + 子目录 `moon.pkg`。

**后果**：正面—边界清晰、编译可并行；负面—`reexport.mbt` 需手动维护新增类型。

---

## ADR-002：make() 构造函数模式

**状态**：已采纳

**背景**：大量类型需校验/归一化（如日期合法性、时区名解析），裸 struct 字面量会绕过校验。

**决策**：所有公共类型提供 `Type::make(...)` 静态构造函数；可能失败的用 `Type::from_xxx(...) -> T?` 或 `raise E`。

**理由**：
- 内聚校验，非法状态在构造时拦截。
- 无状态类型（如 `Tz`）用 `make()` 返回单例，API 一致。
- 可演进：`make()` 内部可加缓存，不影响调用方。

**后果**：正面—构造统一、自文档化；负面—比字面量多一层调用（可内联）。

---

## ADR-003：Hinnant civil↔days 算法

**状态**：已采纳

**背景**：公历日期 ↔ Unix 时间戳互转，要求支持负时间戳、无浮点误差、O(1)。

**决策**：采用 Howard Hinnant 的 `days_from_civil` / `civil_from_days` 算法。

**理由**：
- 纯整数运算，无浮点，跨平台一致。
- O(1)：几次乘除移位，无循环无查表。
- 天然支持负 days（公元前）。
- 业界验证：Rust chrono/chrono-tz 均采用。
- 往返正确：`civil_from_days ∘ days_from_civil = id`。

**后果**：正面—高效精确全范围；负面—算法非直觉，需注释。

---

## ADR-004：DST 三分支 LocalResult[T]

**状态**：已采纳

**背景**：夏令时转换时本地时间可能不存在（春进缺口）或对应两个 UTC 时刻（秋退重叠）。

**决策**：泛型三分支枚举：

```moonbit
pub enum LocalResult[T] {
  Single(T)           // 正常，唯一
  Ambiguous(T, T)     // 秋退重叠
  None                // 春进缺口
} derive(Eq, Compare, Show)
```

**理由**：
- 忠实移植 Rust chrono-tz `LocalResult`。
- `match` 穷尽检查，调用方必须显式处理缺口/重叠，不会静默出错。
- `Ambiguous(t1, t2)` 保留两时刻，可选 `earliest`/`latest`/`unwrap`。
- `None` 是枚举值非异常，无运行时开销。
- 泛型 `[T]`：`offset_from_local_date_time` 返回 `LocalResult[TzOffset]`，`from_local_date_time` 返回 `LocalResult[DateTime]`，复用同一类型。

**后果**：正面—DST 边界正确；负面—调用方需 match 三分支（正确性必要代价）。

---

## ADR-005：全局查表去重

**状态**：已采纳

**背景**：597 时区共有大量 timespan，偏移值与时区名大量重复（如 "+0800"/"CST" 被多时区共享）。

**决策**：全局 `tz_offset_table : Array[Int32]`（406 唯一值，升序）+ `tz_name_table : Array[String]`（178 唯一值，字典序），各时区 `FixedTimespanSet` 存索引而非原值。

**理由**：
- 体积优化：去重后 340 常量，大幅减小。
- 查表 O(1) 索引访问。
- 忠实移植 Rust chrono-tz 同策略。

**后果**：正面—体积小加载快；负面—多一层间接（数组访问极快）。

---

## ADR-006：trait 系统去重（TimeZone + DateTimeLike）

**状态**：已采纳

**背景**：`NaiveDateTime`/`DateTime`/`Date` 共享 year/month/day/weekday 等日历方法；`Tz` 与未来可能的动态时区都需 `offset_from_utc/local`。moon-chrono_tz 中这些方法分散重复。

**决策**：用 trait 抽象共用行为：

```moonbit
/// 时区抽象：任何能提供 UTC/本地偏移的类型都实现此 trait。
pub trait TimeZone {
  fn offset_from_utc_date_time(Self, NaiveDateTime) -> TzOffset
  fn offset_from_local_date_time(Self, NaiveDateTime) -> LocalResult[TzOffset]
}

/// 日历分量访问：NaiveDateTime/DateTime/Date 共用。
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

`Tz` 实现 `TimeZone`；`NaiveDateTime`/`DateTime`/`Date` 实现 `DateTimeLike`。

**理由**：
- 消除三类型间重复的日历方法（moon-chrono_tz 中各写一遍）。
- `TimeZone` trait 让 `DateTime::with_timezone[T : TimeZone]` 可泛化到任何时区实现。
- MoonBit trait 即接口，零运行时开销（静态派发）。

**后果**：正面—DRY、可扩展；负面—trait 方法需显式 `extend`。

---

## ADR-007：方法系统 + derive 自动派生

**状态**：已采纳

**背景**：moon-chrono_tz 手写大量 `to_string`/`op_equal`/比较，重复且易错。

**决策**：
- 所有公共类型用 `derive(Eq, Compare, Show, ToJson)` 自动派生，按需 `extend Type with Show::{to_string}` 等。
- 方法挂类型（`Type::method`）而非自由函数，API idiomatic。
- 用 `#alias` 给操作符别名（`op_equal`→`==`、`op_compare`→`<=>`）。

```moonbit
pub struct NaiveDateTime {
  year : Int64
  month : Int64
  day : Int64
  hour : Int64
  min : Int64
  sec : Int64
} derive(Eq, Compare, Show, ToJson)

pub extend NaiveDateTime with Eq::{op_equal}
pub extend NaiveDateTime with Compare::{op_compare}
pub extend NaiveDateTime with Show::{to_string}
```

**理由**：
- `derive` 一行替代手写几十行比较/序列化。
- 方法挂类型：`dt.year`/`dt.timestamp()` 比 `timestamp(dt)` 更 idiomatic。
- 操作符别名让 `dt1 < dt2` 自然可用。

**后果**：正面—大幅减码、少错；负面—`derive` 生成代码不可定制（需自定义时改手写）。

---

## ADR-008：错误处理 suberror + raise + T?

**状态**：已采纳

**背景**：仓颉用 `throw Exception`/`try-catch`/`Option<T>`/`Result<T,E>`。MoonBit 有更精细的错误系统。需决定移植策略。

**决策**：
- **可恢复的"查无"**（如 `Tz::from_str` 未知时区）：返回 `T?`（`Option`），不抛错。调用方用 `match`/`guard!`/`.unwrap()` 处理。
- **可恢复的"非法输入"**（如 `NaiveDateTime::make` 非法日期）：定义 `suberror`，`raise E`。
- **不可恢复的编程错误**（如内部不变量被破坏）：`fail!("msg")`（抛 `Failure`）。
- **错误多态**：高阶工具（如 `map`）用 `raise?` 适配可抛/不抛回调。
- **不抛错**的纯函数标 `noraise`（如 `days_from_civil`）。

```moonbit
suberror TzError {
  InvalidTzName(String)
  InvalidDate(Int64, Int64, Int64)   // year, month, day
  InvalidTime(Int64, Int64, Int64)   // hour, min, sec
} derive(Debug, Show)

pub extend TzError with Debug::{to_repr}
pub extend TzError with Show::{to_string}

/// 解析时区名，未知返回 None（不抛错，调用方常见处理）。
pub fn Tz::from_str(s : String) -> Tz?

/// 构造日期，非法抛 TzError。
pub fn NaiveDateTime::make(y, mo, d, h, mi, s : Int64) -> NaiveDateTime raise TzError
```

**理由**：
- `T?` 对"查无"最自然：时区名解析失败是常态而非异常，强制 `raise` 会污染调用链。
- `suberror` 让错误类型化、可模式匹配，优于仓颉泛泛 `Exception`。
- `fail!` 自动带源码位置，调试友好。
- `noraise` 让编译器证明纯函数不抛错，便于组合。
- 吸收 MoonBit 设计思想：错误处理是语言核心，`raise`/`try-catch`/`raise?`/`noraise` 分层表达。

**后果**：正面—错误分层清晰、类型安全；负面—调用方需区分 `T?` 与 `raise` 两种风格（但有规则：查无用 `T?`，非法用 `raise`）。

---

## ADR-009：文档注释 /// + mbt check 文档测试

**状态**：已采纳

**背景**：MoonBit 文档注释支持 Markdown，`mbt check` 代码块作为文档测试随 `moon check`/`moon test` 校验，保证示例常新。

**决策**：
- 所有 `pub fn`/`pub struct`/`pub enum`/`pub trait` 前写 `///` 文档注释（中文为主，关键术语英文）。
- 关键 API 附 `mbt check` 文档测试示例。
- 顶层条目用 `///|` 分隔。
- 包级文档用 `README.mbt.md`（文学化 Markdown）。

```moonbit
/// 解析 IANA 时区名，未知返回 None。
///
/// Example:
/// ```mbt check
/// test {
///   let tz = @chrono_tz-mbt.Tz::from_str("Asia/Shanghai")
///   assert_true(tz is Some(_))
/// }
/// ```
pub fn Tz::from_str(s : String) -> Tz?
```

**理由**：
- 文档测试随构建跑，示例不会腐化。
- `///|` 给工具链顶层边界，利于 `moon ide doc`/缓存。
- 文档测试是黑盒测试，验证公开 API 可用性。

**后果**：正面—文档即测试、常新；负面—私有定义不能写文档测试（改用 `_wbtest.mbt`）。

---

## ADR-010：多后端目标

**状态**：已采纳

**背景**：MoonBit 支持 wasm/wasm-gc/js/native 四后端。时区库应跨后端可用。

**决策**：`moon.mod` 声明 `supported_targets = "+wasm+wasm-gc+js+native"`，`preferred_target = "wasm"`。避免后端专属 API。

**理由**：
- 时区算法纯整数，无后端依赖，天然跨后端。
- wasm 产物小，适合嵌入；native 性能高，适合服务端。

**后果**：正面—一份代码四处跑；负面—需四后端 `moon check --target all` 验证。

---

## ADR-011：可选 LRU 缓存

**状态**：待定（S8 可选）

**背景**：时区偏移查询需二分 transitions（O(log n)），热点重复查询有开销。

**决策**（若做）：`TzCache` LRU 缓存 `(Tz, NaiveDateTime) → TzOffset`，固定容量 LRU 淘汰，可选启用，不启用回退二分。

**理由**：热点加速 O(1)；LRU 内存可控；可选层不影响正确性。

**后果**：正面—重复查询提速；负面—占少量内存、首次无加速。核心发布不依赖此项。

---

## ADR-012：属性系统使用策略

**状态**：已采纳

**背景**：MoonBit 提供属性（attribute）系统（`#alias`/`#deprecated`/`#inline`/`#doc(hidden)`/`#internal`/`#non_exhaustive`/`#as_free_fn`/`#cfg`/`#proof_pure` 等），用于给编译器/工具链提供附加提示。属性不改变语义，仅影响编译提示、文档生成、内联决策、可见性控制等。需决定移植中何时用哪些属性。

**决策**：按场景选用属性，不滥用：

| 属性 | 用途 | 本项目使用场景 |
|------|------|---------------|
| `#alias("name")` | 给方法/字段起外部别名（JS/C 互操作名） | 跨后端导出时给公共方法起稳定外部名 |
| `#deprecated("msg")` | 标记弃用，编译警告 | S8 重构旧 API 时用 |
| `#inline` | 提示内联 | `days_from_civil`/`civil_from_days` 等热路径 |
| `#doc(hidden)` | 文档中隐藏 | 内部辅助函数不暴露给用户文档 |
| `#internal` | 包内可见但不对外 | `core` 内部辅助不泄漏到 `.mbti` |
| `#non_exhaustive` | 枚举可扩展，match 需 `_` 兜底 | 暂不用于 `Tz`（597 variant 固定），预留未来扩展 |
| `#as_free_fn("name")` | 把方法导出为自由函数 | 不主动用，保持方法挂类型风格 |
| `#cfg(target = "...")` | 条件编译 | 多后端差异处（若有） |
| `#proof_pure` | 标记纯函数供证明器 | `days_from_civil`/`civil_from_days` 等纯整数算法 |
| `#warnings(off)` | 关闭特定警告 | 不主动用（用户规则：不抑制 warning） |

**理由**：
- 属性是编译提示非语义变更，零运行时开销，安全使用。
- `#inline` + `#proof_pure` 标注核心算法，既提示性能又支持证明器验证。
- `#doc(hidden)` + `#internal` 控制公开 API 面，`.mbti` 更干净。
- `#alias` 仅在跨后端互操作时用，不用于纯 MoonBit 内部。
- 不用 `#warnings(off)`：用户规则要求严格执行，不抑制 warning。
- 属性不改变语义，故可后期按需添加，不阻塞 S1-S7 实现。

**后果**：正面—API 面可控、热路径有内联提示、纯函数可证明；负面—属性语法需查文档（`#` 单井号非 `##`），误用不报错但不生效。

## ADR-013：derive 派生策略

**状态**：已采纳

**背景**：MoonBit 支持从类型定义自动派生内建特征（Eq/Compare/Debug/Default/Hash/Arbitrary/Shrink/FromJson/ToJson）。需决定派生哪些、如何声明方法式 API。

**决策**：
- 按需派生，不盲目全派生：
  - `derive(Eq, Compare)` — 所有值类型（NaiveDateTime/Date/TzOffset/Tz）
  - `derive(Debug)` — 需 `debug_inspect` 的类型（测试用）
  - `derive(Show)` — 需 `to_string` 的类型（用户展示）
  - `derive(Hash)` — 需放入 HashMap/HashSet 的类型（Tz/TzOffset）
  - `derive(Default)` — 有自然默认值的类型
  - `derive(FromJson, ToJson)` — S8 序列化扩展用
  - `derive(Arbitrary, Shrink)` — 需 @quickcheck 性质测试的类型
- **显式 extend 声明方法式 API**：`pub extend T with Eq::{equal, not_equal}` 等，不依赖已弃用的隐式附加
- 字段约束：派生 trait T 时所有字段必须实现 T
- 枚举 Compare：构造器按定义顺序升序（Tz 597 variant 的顺序需稳定）
- Debug 与 Show 分离：测试用 Debug（debug_inspect），用户展示用 Show（to_string）

**理由**：
- derive 一行替代手写几十行比较/序列化，DRY
- 显式 extend 避免隐式附加的弃用警告，重构安全
- 按需派生避免无用代码膨胀

**后果**：正面—大幅减码、类型安全；负面—derive 生成代码不可定制（需自定义时改手写 impl）。

---

## ADR-014：方法系统 + trait 系统 + 运算符重载策略

**状态**：已采纳

**背景**：MoonBit 方法是关联类型的顶层函数，trait 是结构特征系统，运算符通过内建 trait 重载。需决定移植中的方法/trait/运算符使用策略。

**决策**：
- **方法定义**：用 `fn Type::method(...)` 显式前缀，**不用** `fn method(self : Type)` 简短语法（已弃用）
- **点语法调用**：方法首参数为 Self 时 `x.method()`，需 `extend` 显式附加 trait 方法
- **trait 实现**：`impl Trait for Type with method(...) { ... }` + `pub extend Type with Trait::{method}`
- **trait 默认实现**：trait 中 `method(...) -> T = _` 标记 + `impl Trait with method(...) { ... }` 提供
- **子特征**：`trait Sub : Super1 + Super2 {}`，实现子特征需实现所有超特征
- **泛型约束**：`fn[X : Eq] contains(...)`，父 trait 方法用限定语法 `Trait::method(x)`
- **特征对象**：`t as &Trait` 运行时多态（对象安全：Self 首参 + 仅一个 Self）
- **运算符重载**：通过内建 trait（Add/Sub/Mul/...）+ `#alias("_[_]")` 索引/视图
- **本地方法**：可给外部类型加私有方法（覆盖时有警告），用于扩展上游 API

**本项目应用**：
- `Tz`/`NaiveDateTime`/`DateTime`/`Date`/`TzOffset` 用方法挂类型（`fn Tz::name(...)` 等）
- `TimeZone`/`DateTimeLike` trait（ADR-006）用 `impl + extend`
- `LocalResult[T]` 运算符：`derive(Eq, Compare)` 自动 `==`/`<=>`
- `FixedTimespanSet` 索引访问：可选 `#alias("_[_]")` 实现 `set[i]`

**理由**：
- 显式 `Type::method` 前缀比 `self` 简短语法更清晰、不弃用
- `impl + extend` 分离实现声明与方法式 API，重构安全
- 运算符重载通过 trait 统一，`#[_]` 用属性别名
- 特征对象用于未来动态时区扩展（S8）

**后果**：正面—API idiomatic、类型安全、可扩展；负面—`impl + extend` 双声明略冗（但安全）。

---

## ADR-015：包管理与访问控制策略

**状态**：已采纳

**背景**：MoonBit 包按目录组织，每目录含 `moon.pkg` 声明依赖。类型可见性分四级（`priv`/默认/`pub`/`pub(all)`），trait 可见性分四级（`priv`/默认/`pub`/`pub(open)`），另有 `internal` 包、`using`/`reexport`、虚拟包机制。需为本项目三包（core/data/tz）+ 根重导出确定每个类型/trait 的可见性，以及包间依赖与重导出策略。

**决策**：

### 1. 类型可见性四级语义

| 可见性 | 语义 | 外部可构造 | 外部可读字段 | 外部可模式匹配 |
|--------|------|-----------|-------------|---------------|
| `priv` | 包内私有 | 否 | 否 | 否 |
| 默认（无修饰） | 抽象：名称可见，结构隐藏 | 否 | 否 | 否 |
| `pub` | 只读：可读不可构造 | 否 | 是（只读） | 受限（构造器受限） |
| `pub(all)` | 完全公开 | 是 | 是 | 是 |

### 2. 本项目类型可见性决策表

| 类型 | 所在包 | 可见性 | 理由 |
|------|--------|--------|------|
| `FixedTimespan` | core | `pub(all)` | 数据载体，用户需构造（offset+name） |
| `Span` | core | `pub(all)` | 数据载体，用户需构造（begin/end） |
| `FixedTimespanSet` | core | `pub` | 构造复杂，用 `make()`（ADR-002）；暴露只读字段供查询 |
| `TzOffset` | core | `pub(all)` | 简单值类型，用户可构造 |
| `TzError`（suberror） | core | `pub(all)` | 错误枚举，用户需 `match` 分支处理 |
| `TZ_OFFSET_TABLE`/`TZ_NAME_TABLE` | core | `pub` | 全局只读查表，暴露访问不暴露修改 |
| `Tz` 枚举 | tz | `pub(all)` | 597 variant，用户需构造与匹配 |
| `NaiveDateTime` | tz | `pub(all)` | 用户直接构造 |
| `DateTime` | tz | `pub(all)` | 用户直接构造 |
| `Date` | tz | `pub(all)` | 用户直接构造 |
| `LocalResult[T]` | tz | `pub(all)` | 三分支枚举，用户需 `match` |
| 内部辅助函数/类型 | 各包 | 默认/`priv` | 实现细节不暴露 |

### 3. trait 可见性四级语义

| 可见性 | 语义 | 外部可实现 |
|--------|------|-----------|
| `priv` | 包内私有 | 否 |
| 默认（无修饰） | 抽象：封闭，外部不可实现 | 否 |
| `pub trait` | 只读：外部可见但封闭 | 否 |
| `pub(open) trait` | 完全公开：外部可实现 | 是 |

### 4. 本项目 trait 可见性决策

| trait | 所在包 | 可见性 | 理由 |
|-------|--------|--------|------|
| `TimeZone` | tz | `pub(open)` | S8 扩展点：允许用户实现自定义时区（如动态 tzdata） |
| `DateTimeLike` | tz | `pub(open)` | 允许用户扩展日历类型（如自定义 DateTime 变体） |
| 内部辅助 trait | 各包 | `priv`/默认 | 实现细节 |

### 5. 包间依赖与重导出

- **依赖链**（ADR-001）：`core` ← `data` ← `tz` ← 根 `reexport.mbt`，线性无环
- **`moon.pkg` 声明**：每包 `moon.pkg` 列 `deps`（如 tz 包 `"deps": ["core", "data"]`）
- **根重导出**：根包 `reexport.mbt` 用 `pub use` 汇集 core/data/tz 公共 API
  ```moonbit
  pub use @core.{FixedTimespan, Span, FixedTimespanSet, TzOffset, TzError}
  pub use @tz.{Tz, NaiveDateTime, DateTime, Date, LocalResult, TimeZone, DateTimeLike}
  ```
- **用户导入**：`use @chrono_tz_mbt` 即得全部公共 API

### 6. internal 包

- **本项目暂不使用** internal 包（三包线性结构足够清晰）
- **未来场景**：若测试辅助工具（如 mock 时区生成器）需跨包共享但不对外暴露，可拆 `internal` 包，仅被本项目包列入 `deps`，外部不可依赖

### 7. using 与 reexport

- **`using`**：在测试文件（`_test.mbt`/`_wbtest.mbt`）和文档示例中用 `using` 导入被测/演示包，简化引用
- **`reexport`**：仅根包用 `pub use` 重导出，子包不互相 reexport（避免循环）

### 8. 虚拟包

- **不适用本项目**。虚拟包用于多个实体包共享一个逻辑名（如 `foo/bar` 与 `foo/baz` 共享 `foo` 前缀），本项目三包线性结构无需此机制

### 9. 仓颉→MoonBit 包管理映射

| 仓颉 | MoonBit | 说明 |
|------|---------|------|
| `cjpm.toml` `[dependencies]` | `moon.mod` `[deps]` | 模块级依赖 |
| `package source/` | 目录 + `moon.pkg` | 包=目录 |
| `public class` | `pub(all) struct` | 完全公开 |
| `open class` | `pub(open) trait` + `impl` | 继承→trait 组合 |
| `private` | `priv` | 私有 |
| `internal` 修饰 | `internal` 包 | 包内可见 |
| 无 reexport 机制 | `pub use` 重导出 | MoonBit 独有 |

**本项目应用**：
- core 包：`FixedTimespan`/`Span`/`TzOffset`/`TzError` 用 `pub(all)`；`FixedTimespanSet`/查表用 `pub`
- tz 包：`Tz`/`NaiveDateTime`/`DateTime`/`Date`/`LocalResult` 用 `pub(all)`；`TimeZone`/`DateTimeLike` 用 `pub(open) trait`
- 根包：`reexport.mbt` 用 `pub use` 汇集公共 API
- 测试：`using @core`/`using @tz` 导入

**理由**：
- 数据载体类型 `pub(all)` 让用户直接构造，符合值类型语义
- 复杂构造类型 `pub` + `make()`（ADR-002）封装不变量
- `pub(open) trait` 为 S8 扩展预留，允许自定义时区实现
- 根重导出让用户单点导入，API 面清晰
- 不用 internal 包/虚拟包避免过度设计

**后果**：正面—API 面清晰、扩展点明确、用户单点导入；负面—`pub` vs `pub(all)` 需逐类型斟酌（但决策表已固化）。

---

## ADR-016：形式化验证策略（moon prove）

**状态**：可选——S8 扩展点，S1-S7 不启用

**背景**：MoonBit 通过 `moon prove` 提供实验性的形式化验证支持。在 `.mbt` 写可执行代码，在 `.mbtp` 写谓词/引理，包中 `proof_enabled = true` 启用，运行 `moon prove` 由 Why3 + SMT 求解器（z3/cvc5/alt-ergo）消解证明义务。程序侧（`.mbt`）与逻辑侧（`.mbtp`）分离，通过 `proof_require`/`proof_ensure`/`proof_assert`/`proof_invariant` 等注解桥接。当前为实验性特性，快速演进。

**决策**：

### 1. 主线不启用（S1-S7）

- S1-S7 的 `moon.pkg` **不设** `proof_enabled = true`
- 理由：实验性特性不稳定，主线优先交付功能；避免引入 Why3/求解器环境依赖阻塞 CI

### 2. S8 可选验证目标

| 验证目标 | 价值 | 难度 | 优先级 |
|---------|------|------|--------|
| **Hinnant civil↔days 互逆性** | 核心：`civil_from_days(days_from_civil(y,m,d)) == (y,m,d)` 且 `days_from_civil(civil_from_days(z)) == z` | 中（纯整数，适合无界整数模型） | 高 |
| **DST 三分支完备性** | `LocalResult` 对任意本地时间恰返回 Single/Ambiguous/None 之一 | 中（需建模 Span 覆盖） | 中 |
| **查表去重唯一性** | `TZ_OFFSET_TABLE`/`TZ_NAME_TABLE` 无重复 | 低（有限表，可穷举） | 低 |
| **RFC3339 解析-格式化往返** | `parse(format(dt)) == dt` | 高（字符串建模复杂） | 低 |

### 3. 若启用验证的工程结构

```
core/
  moon.pkg          # proof_enabled = true
  hinnant.mbt       # 可执行 + proof_require/proof_ensure 契约
  hinnant.mbtp      # 谓词：civil_inv, days_inv, roundtrip_ok
```

- `.mbtp` 定义逻辑侧谓词（`predicate civil_in_range(...)`、`predicate roundtrip_ok(...)`）
- `.mbt` 函数加 `where { proof_require: ..., proof_ensure: result => ... }`
- 循环（若有）加 `proof_invariant` + `proof_yield` + `proof_reasoning`

### 4. 关键机制使用策略

| 机制 | 用途 | 本项目应用 |
|------|------|-----------|
| `proof_require`/`proof_ensure` | 函数前置/后置条件 | Hinnant 算法契约 |
| `proof_assert` | 局部中间事实 | 分支合并处提示求解器 |
| `proof_invariant` | 循环不变量 | 查表循环（若有） |
| `proof_decrease` | 递归终止度量 | 递归引理 |
| `#proof_pure` | 纯函数双侧共用 | `height`/度量类辅助函数 |
| `proof_axiomatized` | 假定成立（谨慎） | 可信边界外的外部查表 |

### 5. 环境依赖

- **Why3** 1.7.2（opam 安装）
- **求解器**：z3 / cvc5 / alt-ergo（至少一个，多装提高覆盖率）
- **CI**：S8 验证用独立 job，不阻塞主线 test/build

### 6. 可信边界与限制

- **数学整数模型**：`moon prove` 推理无界整数，**不建模机器整数溢出**。Hinnant 用 `Int64`，验证时需加 `proof_require: INT64_MIN <= z && z <= INT64_MAX` 范围约束
- **`proof_axiomatized`**：标记为假定的定义成为可信边界，谨慎使用
- **`#proof_external`/`#proof_import`**：Why3 外部理论桥接，签名映射属可信集成
- **命令式限制**：可变状态需局部化，`FixedArray` 逃逸式使用不受支持→本项目查表用 `Array`（不可变）或局部 `FixedArray`

### 7. 推荐验证风格

- `.mbt` 可执行 + `.mbtp` 证明，两侧窄桥接
- 具名谓词（`civil_inv`/`roundtrip_ok`）优于内联公式
- 小而稳定的不变量（`*_inv`）与后置条件（`*_post`）
- 函数式风格优先（Hinnant 算法已是纯函数，天然适合）
- 基于模型的验证：定义 `model()` 抽象 + `*_inv` 表示不变量

**本项目应用**：
- **首选验证目标**：Hinnant civil↔days 互逆性（ADR-003 算法，纯整数 O(1)，最高价值）
- **次选**：DST 三分支完备性（ADR-004，需建模 Span 覆盖）
- **不验证**：RFC3339 字符串往返（建模成本过高）、597 时区数据（穷举无意义）

**理由**：
- 实验性特性快速演进，S1-S7 主线不依赖，避免环境/稳定性阻塞
- Hinnant 互逆性是核心不变量，机检价值最高，且纯整数适合当前无界整数模型
- 数学整数模型需显式加 Int64 范围约束，否则证明不反映运行时溢出
- 函数式风格 + 基于模型验证是 MoonBit 推荐路径，本项目 Hinnant 算法天然契合

**后果**：正面—S8 可为核心算法提供机检正确性保证，Hinnant 互逆性可证；负面—实验性特性可能变动需跟踪，环境依赖（Why3+求解器）增加 CI 复杂度（独立 job 隔离）。

> 文件结束 | chrono_tz-mbt architecture v1.4 | 2026-11-04