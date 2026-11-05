# 仓颉 → MoonBit 移植映射 / Migration Map

> 逐条对照仓颉（Cangjie v1.1.3）源 `chrono_tz_src/` 与 MoonBit 目标 `chrono_tz-mbt/`。
> 源时区核心在 `src/core/timezone_core.cj` + `src/base/tz/*.cj` + `src/data/*.cj`。

## 一、语法映射总表

| 仓颉 | MoonBit | 说明 |
|------|---------|------|
| `let x = ...` | `let x = ...` | 相同 |
| `let mut x = ...` | `let mut x = ...` | 相同 |
| `var x = ...`（字段） | `mut x : T`（字段） | 字段可变用 `mut` |
| `func foo(a: Int64): Int64 { }` | `fn foo(a : Int64) -> Int64 { }` | `func`→`fn`，返回 `->` |
| `public func foo()` | `pub fn foo()` | `public`→`pub` |
| `private func foo()` | `fn foo()`（默认私有） | MoonBit 默认私有 |
| `static func foo()` | `fn Type::foo()` 或顶层 `fn foo()` | 无 `static`，用方法或顶层函数 |
| `open class Foo` | `struct Foo`（或 `enum`） | MoonBit 无 class，用 struct/enum/trait |
| `class Foo { let x: Int }` | `struct Foo { x : Int }` | 字段语法 |
| `enum Color { Red Green Blue }` | `enum Color { Red Green Blue }` | 相同 |
| `interface I { func foo(): Int }` | `trait I { fn foo(Self) -> Int }` | `interface`→`trait`，首参 `Self` |
| `extend Foo <: I { ... }` | `extend Foo with I::{ ... }` | 实现语法 |
| `match x { case A => ... }` | `match x { A => ... }` | 去 `case` |
| `if (cond) { } else { }` | `if cond { } else { }` | 去括号 |
| `for (i in 0..n) { }` | `for i in 0..<n { }` 或 `for i = 0; i < n; i = i + 1 { }` | 区间或 C 风格 |
| `while (cond) { }` | `while cond { }` | 去括号 |
| `return x` | `return x` | 相同 |
| `break` / `continue` | `break` / `continue` | 相同（`nobreak` 为 MoonBit 特有） |
| `println("x")` | `println("x")` | 相同 |
| `"${expr}"` | `"\{expr}"` | 插值语法不同 |
| `// 注释` | `// 注释` | 相同 |
| `/// 文档` | `/// 文档` | 相同（MoonBit 支持 Markdown + `mbt check`） |

## 二、类型映射

| 仓颉 | MoonBit | 注意 |
|------|---------|------|
| `Int8`/`Int16`/`Int32`/`Int64` | `Int8`/`Int16`/`Int32`/`Int64` | 相同 |
| `UInt16`/`UInt32`/`UInt64` | `UInt16`/`UInt32`/`UInt64` | 相同 |
| `IntNative` | `Int`（平台相关，少用） | 尽量用定宽 |
| `Float64` / `Float32` | `Double` / `Float` | 名称不同 |
| `Bool` | `Bool` | 相同 |
| `Unit` | `Unit` | 相同，`()` |
| `String` | `String` | **⚠️ 仓颉 String 是 UTF-8 字节序列；MoonBit String 是 UTF-16 码点。时区名/缩写是 ASCII，安全；但若有字节级操作需用 `Bytes`/`@bytes`。** |
| `Array<T>` | `Array[T]` | 语法 `[T]` |
| `Rune` | `Char` | Unicode 字符 |
| `Option<T>` | `T?` | `Some(x)`/`None`，`?` 后缀 |
| `Result<T, E>` | 用 `raise E` 或 `Result[T, E]` | 见错误处理映射 |
| `Tuple<A, B>` | `(A, B)` | 元组 |
| `Map<K, V>` | `@hashmap.Map[K, V]` 或 `Map[K, V]` | 需导入 |
| `HashSet<T>` | `@hashset.Set[T]` | 需导入 |

## 三、错误处理映射（关键）

| 仓颉 | MoonBit | 说明 |
|------|---------|------|
| `throw Exception("msg")` | `raise SomeError("msg")` 或 `fail!("msg")` | 定义 `suberror`，类型化错误 |
| `try { f() } catch (e: Exception) { ... }` | `try f() catch { SomeError(s) => ... }` | `catch` 模式匹配 |
| `try { } catch (e) { handle(e) }` | `try f() catch { e => handle(e) }` | 通用捕获 |
| —（无对应） | `try! f()` | 捕获即 panic，用于"不应失败"处 |
| `Option<T>.Some(x)` / `.None` | `Some(x)` / `None`（`T?`） | 相同语义 |
| `match opt { case Some(x) => x case None => default }` | `match opt { Some(x) => x None => default }` | 去 `case` |
| `opt.getOrElse(default)` | `opt.or_else(default)` 或 `match` | MoonBit 用 `??`/`or_else`/`unwrap_or` |
| `opt.get()`（可能抛） | `opt.unwrap()`（抛 `Failure`）或 `guard! opt is Some(x)` | |
| `Result<T,E>.Ok(x)` / `.Err(e)` | `Ok(x)` / `Err(e)`（`Result[T,E]`） | MoonBit 保留 `Result`，但推荐 `raise E` |
| —（无对应） | `noraise` | 标注函数绝不抛错 |
| —（无对应） | `raise?` | 错误多态，高阶函数适配 |

**策略**（见 ADR-008）：
- 查无（如 `from_str` 未知时区）→ `T?`
- 非法输入（如非法日期）→ `suberror TzError` + `raise TzError`
- 内部不变量破坏 → `fail!`
- 纯函数 → `noraise`

## 四、模块/文件映射

| 仓颉源文件 | MoonBit 目标 | 说明 |
|-----------|-------------|------|
| `src/core/timezone_core.cj` | `core/timezone_core.mbt` | `FixedTimespan`/`Span`/`FixedTimespanSet`/`Ordering` + 全局查表 |
| `src/data/data_africa.cj` | `data/data_africa.mbt` | 非洲时区常量 |
| `src/data/data_america.cj` | `data/data_america.mbt` | 美洲 |
| `src/data/data_asia.cj` | `data/data_asia.mbt` | 亚洲 |
| `src/data/data_australasia.cj` | `data/data_australasia.mbt` | 大洋洲 |
| `src/data/data_europe.cj` | `data/data_europe.mbt` | 欧洲 |
| `src/data/data_others.cj` | `data/data_others.mbt` | 南极/大西洋/等 |
| `src/base/tz/datetime.cj` | `tz/datetime.mbt` | `Duration`/`NaiveDateTime`/`DateTime`/`Date`（Hinnant） |
| `src/base/tz/tz_variants.cj` | `tz/tz_variants.mbt` | `Tz` 枚举 597 + `name`/`from_str` |
| `src/base/tz/timezone_impl.cj` | `tz/timezone_impl.mbt` | `TzOffset`/`LocalResult`/`TimeZone` trait/`binary_search`/`GapInfo` |
| `src/base/tz/tz_impl.cj` | `tz/tz_impl.mbt` | `timespans()` + DST 算法 |
| `src/base/tz/tz_format.cj` | `tz/tz_format.mbt` | strftime/strptime/RFC3339 |
| `src/base/tz/tz_utils.cj` | （S8 可选）`tz/tz_utils.mbt` | 便利查询 |
| `src/base/tz/tz_cache.cj` | （S8 可选）`tz/tz_cache.mbt` | LRU 缓存 |
| `src/base/tz/tz_calendar.cj` | （S8 可选）`tz/tz_calendar.mbt` | `BusinessCalendar`/`HolidayTable` |
| `src/base/tz/tz_daterange.cj` | （S8 可选）`tz/tz_daterange.mbt` | `DateRange` |
| `src/base/tz/tz_humanize.cj` | （不做）— | 非核心 |
| `src/base/tz/tz_serialize.cj` | （S8 可选）`tz/tz_serialize.mbt` | JSON 导出 |
| `src/base/tz/tz_leap.cj` | （S8 可选）`tz/tz_leap.mbt` | 闰秒 |
| `src/base/tz/schedule.cj` | （不做）— | 非核心 |
| `src/base/tz/tz_devex.cj` | （不做）— | 非核心 |

## 五、关键陷阱

### 1. String 编码差异（最高危）
仓颉 `String` 是 UTF-8 字节序列；MoonBit `String` 是 UTF-16 码点。时区名（如 `"Asia/Shanghai"`）和缩写（如 `"CST"`）都是 ASCII，直接移植安全。但若源码有**字节级操作**（如 `s.bytes()`/`s[i]` 取字节），需改用 MoonBit `Bytes` 或 `@bytes`。逐字段审查 `String` 用途：是文本还是字节？

### 2. Int64 字面量
仓颉 `Int64` 字面量如 `1462878000L`；MoonBit 同样用 `L` 后缀（`1462878000L`）。但 MoonBit 整数默认 `Int32`，时区秒数偏移需显式 `Int32`，时间戳需 `Int64`，注意类型转换 `.to_int64()`/`.to_int32()`。

### 3. 数组索引
仓颉 `arr[i]`；MoonBit `arr[i]` 相同，但 MoonBit `Array` 越界抛 `Failure`，`FixedArray` 越界行为不同。时区 transitions 表用 `Array` + 二分，注意边界。

### 4. 枚举 variant 数量
`Tz` 枚举 597 variant，MoonBit 单 enum 能容纳。但 `derive(Eq, Compare, Show)` 对大枚举生成代码量大，可接受（编译期生成）。`from_str` 用 `NAME_TO_TZ` 哈希表/二分表，勿用 597 层 `match`。

### 5. 仓颉 `open class` vs MoonBit `struct`
仓颉 `open class` 可继承；MoonBit `struct` 无继承，用 `trait` 组合。源码若用继承需重构为 trait + 组合。

### 6. 仓颉 `prop`（属性）
仓颉 `prop x: Int { get() set(v) }`；MoonBit 无 C# 风格 property，用 `struct` 字段（`pub` 字段可直接读写）或方法（`fn x(self) -> T`）。源码 `prop` 映射为 MoonBit 字段（若公开）或方法（若需计算）。

### 7. 静态成员
仓颉 `class Foo { static let X = 1 }`；MoonBit 用顶层 `let X = 1` 或 `fn Foo::x() -> Int { 1 }`。全局查表 `tz_offset_table` 用顶层 `pub let`。

### 8. `for` 循环区间
仓颉 `for (i in 0..n)` 含 `n`；MoonBit `for i in 0..<n` 不含 `n`（半开区间），或 `for i in 0..=n` 含 `n`。务必核对边界。

### 9. 默认参数 / 命名参数
仓颉 `func foo(a: Int, b: Int = 0)`；MoonBit 用命名参数 `fn foo(a~ : Int, b~ : Int = 0)`，调用 `foo(a=1)` 或 `foo(a=1, b=2)`。

### 10. `match` 穷尽性
MoonBit `match` 必须穷尽或用 `_` 兜底。仓颉 `match` 同要求，但 MoonBit 对 `enum` 强制检查。`LocalResult` 三分支 match 需全覆盖。

## 六、移植流程（每文件）

1. 读仓颉源 `.cj`，逐块理解语义（勿直译语法）。
2. 查本表做语法/类型/错误映射。
3. 用 MoonBit idiomatic 方式重写：`derive` 去重、方法挂类型、`T?`/`raise` 分层错误。
4. 写文档注释 `///` + `mbt check` 示例。
5. `moon check` 通过 → 写测试 → `moon test` 通过。
6. `moon info` 检查 `.mbti` API 面符合预期。

## 七、属性映射

仓颉用注解（`@Annotation`），MoonBit 用属性（`#attr`，单井号）。属性不改变语义，仅编译/工具提示。

| 仓颉注解 | MoonBit 属性 | 说明 |
|---------|------------|------|
| `@Deprecated("msg")` | `#deprecated("msg")` | 标记弃用，编译警告 |
| `@Inline` | `#inline` | 提示内联 |
| —（无对应） | `#alias("name")` | 外部别名（JS/C 互操作） |
| —（无对应） | `#doc(hidden)` | 文档隐藏 |
| —（无对应） | `#internal` | 包内可见不对外 |
| —（无对应） | `#non_exhaustive` | 枚举可扩展，match 需 `_` |
| —（无对应） | `#as_free_fn("name")` | 方法导出为自由函数 |
| `@Compile(target)` | `#cfg(target = "...")` | 条件编译 |
| —（无对应） | `#proof_pure` | 纯函数标记（证明器） |
| —（无对应） | `#skip` / `#coverage.skip` | 跳过测试/覆盖 |
| —（无对应） | `#callsite` | 调用点展开 |
| —（无对应） | `#must_implement_one` | trait 至少实现一个方法 |
| —（无对应） | `#warnings(off)` | 关闭警告（本项目不用） |

**使用策略**（见 ADR-012）：
- `#inline` + `#proof_pure`：核心纯整数算法（`days_from_civil`/`civil_from_days`）。
- `#doc(hidden)` + `#internal`：内部辅助不暴露到公开 API。
- `#deprecated`：S8 重构旧 API 时标记。
- `#alias`：仅跨后端互操作时用。
- **不用** `#warnings(off)`：用户规则要求严格执行警告。
- 属性可后期按需添加，不阻塞 S1-S7 实现。

**注意**：
- MoonBit 属性是 `#`（单井号），非 `##`（双井号）。
- 属性不改变语义，未使用不报错（部分会警告未使用）。
- 不支持运行时反射，属性仅编译期可见。

## 八、MoonBit 基础语法要点（移植相关）

> 吸收自 MoonBit 基础语法总览，仅列移植相关要点。

### 1. FixedArray::make 陷阱

`FixedArray::make(n, init)` 全部元素复用**同一个** init 值（引用类型时共享）。二维数组必须用 `makei(fn(i){...})`：

```moonbit
// ❌ 错误：所有行共享同一个 Array
let grid = FixedArray::make(n, Array::make(m, 0))

// ✅ 正确：每行独立
let grid = FixedArray::makei(n, _ => Array::make(m, 0))
```

### 2. 字面量重载

数字字面量 `42` 在上下文类型确定时自动适配 `Int32`/`Int64`/`UInt32`/`Double` 等，**不是强制后缀**。但变量转换必须用 `.to_int64()` / `.to_int32()` 等方法。

### 3. guard / guard!

```moonbit
guard idx >= 0 else { return None }   // 普通 guard，必须 else
guard! value is Some(v)                // guard! 等价 guard ... else { panic() }，不能带 else
```

### 4. defer / errdefer

- `defer expr { body }`：无论正常/return/异常退出都执行，逆序执行多个 defer
- `errdefer expr { body }`：仅在抛出错误时执行，正常 return 不跑（适合资源返回场景）

### 5. 级联运算符 `..`

`x..method()` 等价 `{ x.method(); x }`，链式调用返回 Unit 的可变方法：

```moonbit
StringBuilder()
  ..write_char('a')
  ..write_string("bc")
  .to_string()
```

### 6. extenum 可扩展枚举

```moonbit
pub extenum LogEvent[T]
pub(all) extenum LogEvent[T] += { Info(T) }
```

其他包可扩展；模式匹配必须 `_` 兜底。本项目暂不使用（Tz 枚举固定 597 variant）。

### 7. 类型别名 ≠ 新类型

`type Index = Int32` 只是别名，**不是新类型**，不能给别名加方法/impl trait。需要新类型用 `struct` 包装。

### 8. 列表推导式

```moonbit
let squares = [for x in 1..<=5 => x * x]          // Array[Int]
let evens = [for x in 1..<=10 if x % 2 == 0 => x]  // 带过滤
```

内部**不能 return / break / continue**。

### 9. 管道运算符

```moonbit
5 |> add(1, _)    // 左值填入 _ 位置（默认第一个参数）
div <| [text <| "hi"]  // 反向管道，x 作为最后一个参数
```

### 10. todo 占位

`...` 占位，编译通过，运行 panic，标记未实现代码。

### 11. 字节容器对比

| 类型 | 所有权 | 可变性 | 用途 |
|------|--------|--------|------|
| `Bytes` | 自有 | 不可变 | 最终字节负载、API 边界 |
| `BytesView` | 借用 | 不可变 | 切片，不复制 |
| `Array[Byte]` | 自有 | 可变 | 可变字节缓冲区 |
| `@buffer.Buffer` | 自有可变 | 可扩容 | 流式拼接，最后 `.contents()` 得 Bytes |

时区名是 ASCII String，无需 Bytes；若有字节级操作用 `Bytes`。

### 12. 字符串多行语法

```moonbit
let raw = #| hello \{lang} |    // 原始多行，不解析插值
let interp = $| hello \{lang} |  // 插值多行，支持 \{...}
```

### 13. is 表达式

`expr is pattern` 返回 Bool，并绑定变量到 `&&` 右侧、if 真分支、guard、while 循环：

```moonbit
if opt is Some(v) && v > 0 { ... }
```

### 14. nobreak 循环

`while cond { ... } nobreak { ... }` — nobreak 块在循环**正常退出**（非 break）时执行，作为循环返回值。

### 15. for .. in 迭代

依赖 `.iter()` / `.iter2()`；范围 `a..<b`（不含上界）/ `a..<=b`（含上界）：

```moonbit
for x in 0..<10 { }      // 0..9
for x in 0..<=10 { }     // 0..10
for k, v in map { }      // Map 迭代
for idx, elem in arr { } // 带索引
```

### 16. #callsite(autofill(...))

支持 `SourceLoc` / `ArgsLoc` 自动填充，用于 `fail!`/日志/断言的源码定位。

### 17. 字符串插值与字面量种类

| 字面量 | 语法 | 说明 |
|--------|------|------|
| 字符串 | `"..."` | 支持 `\n`/`\t`/`\u{...}` 转义 + `\{expr}` 插值 |
| 多行原始 | `#|...` | 原样文本，无转义无插值 |
| 多行插值 | `$|...` | 仅 `\{` 开始插值 |
| 字符 | `'c'` | 恰好一个 Unicode 标量值 |
| 字节序列 | `b"..."` | `\xHH`/`\oDDD` 写字节，非 ASCII 写 UTF-8，无多行 |
| 字节 | `b'c'` | 未转义必须 ASCII，无 Unicode 转义 |
| 正则 | `re"..."` | 反斜杠原样保留给正则解析器，`\{` 插值仅 lex-pattern 上下文 |

**插值**：`\{expr}` 表达式不能为空，嵌套大括号不影响匹配，不允许换行/`//`注释/属性/多行字符串。本项目 RFC3339 格式化用插值。

### 18. 注释规则

- `///` 文档注释优先于 `//` 行注释（同位置两者可匹配时）
- **不支持块注释** `/* */`
- `///` 用于 ADR-009 文档测试（```mbt check）

### 19. 标识符与命名约定

| 类别 | 规则 | 示例 |
|------|------|------|
| `uident` | ASCII 大写字母开头 | `Tz`/`FixedTimespan`/`LocalResult` |
| `lident` | ASCII 小写/`_`/non-ascii 开头 | `from_str`/`civil_from_days`/`_internal` |
| `_` | 专用词法单元 | match 通配 |

- non-ascii 范围广（含 CJK 等），**不进行 Unicode 规范化**，按原样使用
- 关键字优先于标识符；保留字使用会警告
- **命名约定**：变量/函数 `snake_case`（小写开头）；常量/类型 `PascalCase` 或 `SCREAMING_SNAKE_CASE`（大写开头）
- 本项目：类型 `Tz`/`NaiveDateTime`（PascalCase），函数 `from_str`/`civil_from_days`（snake_case），常量 `TZ_OFFSET_TABLE`（SCREAMING_SNAKE_CASE）

### 20. 数字字面量后缀

| 后缀 | 类型 | 本项目用 |
|------|------|---------|
| 无（整数） | `Int32`（默认） | offset/年月日时分秒 |
| `L` | `Int64` | Unix 时间戳、days |
| `UL` | `UInt64` | — |
| `U` | `UInt32` | — |
| `N` | `BigInt` | — |
| `F` | `Float` | — |
| 无（浮点） | `Double` | — |

- 下划线分隔：`1_000_000L`，首数字后可重复，可出现在末尾
- 进制：`0x`/`0o`/`0b` 前缀
- 浮点必须含小数点；`1.` 和 `1.F` 合法
- **关键**：紧接 `..` 时整数先结束，`1..=2` 词法为 `1` 和 `..=`
- 本项目：时间戳用 `1700000000L`（Int64），offset 用 `28800`（Int32）

### 21. 点号前缀与运算符

- **元组访问器** `.0`/`.1`：数字直接跟点，无下划线
- **点号标识符** `.method`/`.if`：不查关键字表，故 `.if` 合法
- 单独 `.` 报词法错误
- **运算符最长匹配**：`..`/`..=`/`..<`/`..<=`/`>..`/`>=..`/`...`/`|>`/`<|`/`->`/`=>` 等，列出的词法单元中最长者优先

### 22. 自动分号插入

换行后，若前一词法单元可结束语句且后一可开始语句，词法分析器插入 `;`。文件末尾可作有效后继。**不在 `}` 前插入**，不在多行字符串相邻行间插入。影响代码格式：块末表达式无需显式 `;`。

### 23. 表达式 vs 语句 + 变量绑定 + init/main/test

**表达式 vs 语句**：
- 函数体只有最后一个子句是表达式（返回值），其余是语句
- 表达式：字面量/算术逻辑比较/字段访问 `r.x`/元组 `t.0`/数组 `a[0]`/枚举构造器/匿名函数/`match`/`if`/`loop`
- 语句：命名本地函数/`let`绑定/赋值/`return`/返回 `Unit` 的表达式

**变量绑定**：
- `let mut x` 可变，`let x` 不可变
- `const` 仅顶层，不可改
- **顶层变量绑定**：需显式类型注释（除非字面量），不能可变（用 `Ref` 代替）

**init/main/test**：
- `fn init`：无参无返回，可多个，隐式调用，只含语句
- `fn main`：无参无返回，程序入口，初始化后执行，仅 main 包可定义（`moon.pkg` 配 `pkgtype(kind: "executable")`）
- `test "name" { ... }`：内联测试块，本项目测试主力

## 九、derive 派生特征

| derive | 生成 | 用途 | 本项目使用 |
|--------|------|------|-----------|
| `Eq` | `op_equal` | 相等比较 | 所有值类型 |
| `Compare` | `compare`/`op_lt`/... | 排序 | NaiveDateTime/Date/TzOffset/Tz |
| `Debug` | `to_repr` | debug_inspect | 测试用 |
| `Show` | `to_string` | 用户展示 | 需 to_string 的类型 |
| `Default` | `default` | 默认值 | 有自然默认的类型 |
| `Hash` | `hash`/`hash_combine` | HashMap/HashSet | Tz/TzBypass |
| `Arbitrary` | 随机值生成 | @quickcheck | 性质测试类型 |
| `Shrink` | `shrink` | @quickcheck 缩小 | 性质测试类型 |
| `FromJson`/`ToJson` | JSON 序列化 | S8 扩展 | 序列化用 |

**规则**：
- 派生 trait T 时所有字段必须实现 T
- 枚举 Compare：构造器按定义顺序升序
- `derive(Default)` 枚举：唯一无参构造器为默认值；多无参构造器不能派生
- **显式 extend**：`pub extend T with Trait::{method}` 声明方法式 API，不依赖已弃用隐式附加
- JSON：`style="legacy"`（`{"$tag":"A","x":1}`）/ `style="flat"`（`["A",1]`）
- JSON Option：结构体直接字段 `T?` → `T | undefined`，否则 `[T] | null`

## 十、方法与特征系统

### 方法定义

| 语法 | 说明 | 本项目用 |
|------|------|---------|
| `fn Type::method(...)` | 显式前缀，推荐 | 是 |
| `fn method(self : Type)` | 简短语法，**已弃用** | 否 |
| `x.method()` | 点调用（首参为 Self） | 是 |
| `Type::method(x)` | 限定调用 | 是 |

方法重载：不同类型同名方法处于不同命名空间，天然支持。

### 本地方法

可给外部类型定义私有方法（覆盖时有警告），用于扩展上游 API。

### 运算符重载

| 运算符 | 重载方式 |
|--------|---------|
| `+`/`-`/`*`/`/`/`%` | trait Add/Sub/Mul/Div/Mod |
| `==` | trait Eq |
| `<<`/`>>` | trait Shl/Shr |
| `-`（一元） | trait Neg |
| `&`/`|`/`^` | trait BitAnd/BitOr/BitXOr |
| `_[_]` | `#alias("_[_]")` 方法 |
| `_[_]=_` | `#alias("_[_]=_")` 方法 |
| `[_:_]` | `#alias("_[_:_]")` 方法 |

### trait 系统

| 语法 | 说明 |
|------|------|
| `pub(open) trait I { method(Self) -> T }` | 声明 |
| `trait Sub : Super1 + Super2 {}` | 子特征 |
| `impl Trait for Type with method(...) { ... }` | 实现 |
| `impl Trait for Type` | 检查所有方法有实现（无方法体） |
| `pub extend Type with Trait::{method}` | 显式附加方法式 API（点语法） |
| `fn[X : Eq] foo(...)` | trait 约束泛型 |
| `Trait::method(value)` | 直接调用 |
| `t as &Trait` | 特征对象（运行时多态） |

**关键规则**：
- **自动附加已弃用**：必须 `extend` 显式声明方法式 API
- 默认实现：trait 中 `method(...) -> T = _` 标记 + `impl Trait with method`
- 特征对象安全：Self 必须首参 + 类型中仅一个 Self
- 父 trait 方法在泛型中用限定语法 `Trait::method(x)`

## 十一、包管理与访问控制

### 包配置文件

| 文件 | 作用 | 示例 |
|------|------|------|
| `moon.mod` | 模块元数据 + 模块级依赖 | `[deps]\n` / `preferred_target = "wasm"` |
| `moon.pkg` | 包级依赖 + 导出控制 | `"deps": ["core", "data"]` |

每目录=一包，含 `moon.pkg`。根目录 `moon.mod` 定义模块。

### 四级类型可见性

| 修饰 | 语义 | 外部构造 | 外部读字段 | 外部模式匹配 |
|------|------|---------|-----------|-------------|
| `priv T` | 包内私有 | 否 | 否 | 否 |
| `T`（默认） | 抽象：名称可见结构隐藏 | 否 | 否 | 否 |
| `pub T` | 只读：可读不可构造 | 否 | 是（只读） | 受限 |
| `pub(all) T` | 完全公开 | 是 | 是 | 是 |

**关键**：`pub` 与 `pub(all)` 区别—`pub` 暴露字段只读访问但不允许外部构造，`pub(all)` 允许外部完整构造与匹配。数据载体用 `pub(all)`，复杂不变量类型用 `pub` + `make()`。

### 四级 trait 可见性

| 修饰 | 语义 | 外部可实现 |
|------|------|-----------|
| `priv trait` | 包内私有 | 否 |
| `trait`（默认） | 抽象：封闭 | 否 |
| `pub trait` | 只读：外部可见但封闭 | 否 |
| `pub(open) trait` | 完全公开：外部可实现 | 是 |

**关键**：仅 `pub(open)` 允许外部包 `impl Trait for Type`。扩展点 trait 用 `pub(open)`，内部 trait 用 `priv`/默认。

### internal 包

`internal` 包仅被同模块内包依赖，外部模块不可引用。用于跨包共享实现细节（如测试辅助工具）而不暴露给用户。

```moonbit
// moon.pkg of internal package
{
  "internal": true  // 标记为内部包
}
```

本项目暂不使用（三包线性足够）。

### using 与 reexport

**`using`**：在文件顶部导入包/类型，简化引用。测试与示例常用。

```moonbit
using @core  // 导入 core 包
using @core.{FixedTimespan, Span}  // 导入特定类型
```

**`pub use`（reexport）**：在包中重导出其他包的 API。

```moonbit
// reexport.mbt（根包）
pub use @core.{FixedTimespan, Span, TzOffset, TzError}
pub use @tz.{Tz, NaiveDateTime, DateTime, TimeZone}
```

用户 `use @chrono_tz_mbt` 即得全部重导出 API。

### 虚拟包

虚拟包用于多个实体包共享一个逻辑前缀名（如 `foo/bar` + `foo/baz` 共享 `foo`）。通过在 `moon.mod` 声明虚拟包实现。本项目不适用（三包线性无共享前缀需求）。

### 仓颉→MoonBit 包管理映射

| 仓颉 | MoonBit | 说明 |
|------|---------|------|
| `cjpm.toml` | `moon.mod` | 模块元数据+依赖 |
| `cjpm.toml` `[dependencies]` | `moon.mod` `[deps]` | 模块级依赖 |
| `package source/` | 目录 + `moon.pkg` | 包=目录 |
| `public class` | `pub(all) struct` | 完全公开 |
| `public open class` | `pub(open) trait` + `impl` | 继承→trait 组合 |
| `private` | `priv` | 私有 |
| `internal` 修饰 | `internal` 包 | 包内可见 |
| 无 reexport | `pub use` 重导出 | MoonBit 独有 |
| `using` 导入 | `using` 导入 | 相同 |

### 本项目包管理决策（见 ADR-015）

- **core**：`FixedTimespan`/`Span`/`TzOffset`/`TzError` 用 `pub(all)`；`FixedTimespanSet`/查表用 `pub`
- **data**：数据生成函数 `priv`（仅 core 调用），生成的表数据 `pub`
- **tz**：`Tz`/`NaiveDateTime`/`DateTime`/`Date`/`LocalResult` 用 `pub(all)`；`TimeZone`/`DateTimeLike` 用 `pub(open) trait`
- **根**：`reexport.mbt` 用 `pub use` 汇集公共 API

## 十二、形式化验证（moon prove）

### 概述

MoonBit 通过 `moon prove` 提供实验性形式化验证：在 `.mbt` 写可执行代码，`.mbtp` 写谓词/引理，包启用 `proof_enabled = true`，运行 `moon prove` 由 Why3 + SMT 求解器消解证明义务。

### 工作流程

1. `.mbt` 编写可执行代码
2. `.mbtp` 编写谓词、逻辑辅助函数、引理
3. `moon.pkg` 设 `proof_enabled = true`
4. 运行 `moon prove`

### 程序侧 vs 逻辑侧

| 层 | 文件 | 性质 | 可调用 |
|----|------|------|--------|
| 程序侧 | `.mbt` | 可执行 | 普通代码可调用 |
| 逻辑侧 | `.mbtp` | 规范与证明 | 不对应运行时，程序侧不调用 |

两侧分离，通过契约注解桥接。需双侧共用时用 `#proof_pure`。

### 契约与证明注解

| 注解 | 位置 | 用途 |
|------|------|------|
| `proof_require: P` | 函数 `where{}` | 前置条件 |
| `proof_ensure: result => Q` | 函数 `where{}` | 后置条件（`result` 指代返回值） |
| `proof_assert P` | 函数体内 | 局部中间事实，提示求解器 |
| `proof_invariant: P` | 循环 `where{}` | 循环不变量 |
| `proof_yield: res => Q` | 循环 `where{}` | `break` 产出值的事实 |
| `proof_reasoning: (...)` | 循环 `where{}` | 结构化证明说明文字 |
| `proof_decrease: m` | 递归函数 | 终止度量 |
| `proof_axiomatized: true` | 函数/引理 | 假定成立（非证明），属可信边界 |

### 证明专用属性

| 属性 | 用途 |
|------|------|
| `#proof_pure` | 标记函数纯函数，程序侧+逻辑侧共用（如 `height`/度量） |
| `#proof_external("module", "symbol")` | 用 Why3 模块类型表示抽象 MoonBit 类型 |
| `#proof_import("module")` | 为 Why3 操作声明证明专用 stub（函数体为符号名字符串） |

### 基于模型的验证

数据结构/有状态系统推荐：
1. 定义抽象模型 `fn Type::model(self) -> Abstract`
2. 定义表示不变量 `predicate type_inv(x)`
3. 针对抽象模型写规范 `predicate type_post(x, result)`

```moonbit
// .mbtp
predicate civil_in_range(y, m, d) { ... }
predicate roundtrip_ok(z, result) { days_from_civil(result) == z }

// .mbt
pub fn civil_from_days(z : Int64) -> (Int32, Int32, Int32)
where {
  proof_require: INT64_MIN <= z && z <= INT64_MAX,
  proof_ensure: result => civil_in_range(result) && roundtrip_ok(z, result),
}
{ ... }
```

### 环境配置

- **Why3** 1.7.2（`opam install why3=1.7.2`）
- **求解器**（至少一个）：z3 / cvc5 / alt-ergo
- **运行**：模块根 `moon prove`，或定向 `moon prove path/to/package`

### 可信边界与限制

- **数学整数模型**：推理无界整数，**不建模机器整数溢出**→用 `Int64` 需加范围 `proof_require`
- **`proof_axiomatized`**：假定而非证明，属可信边界
- **`#proof_external`/`#proof_import`**：Why3 外部理论桥接，签名映射属可信集成
- **命令式限制**：可变状态需局部化，`FixedArray` 逃逸式使用不受支持
- **当前状态**：实验性，快速演进，面向强保证需求包

### 推荐风格

- `.mbt` 可执行 + `.mbtp` 证明，窄桥接
- 具名谓词（`*_inv`/`*_post`）优于内联公式
- 小而稳定的不变量
- 函数式风格优先（命令式受限）
- 从简单算法证明开始→过渡到基于模型的验证
- 递归辅助用 `#proof_pure` + `proof_decrease`

### 仓颉→MoonBit 验证映射

| 仓颉 | MoonBit | 说明 |
|------|---------|------|
| 无形式化验证 | `moon prove` | MoonBit 独有 |
| 无 `.mbtp` 对应 | `.mbtp` 谓词/引理 | 逻辑侧 |
| 单元测试断言 | `proof_assert` | 机检 vs 运行时抽检 |

### 本项目验证策略（见 ADR-016）

- **S1-S7 不启用**（实验性，主线优先）
- **S8 可选**：首选 Hinnant civil↔days 互逆性（纯整数，高价值）
- **不验证**：RFC3339 字符串往返（建模成本高）、597 时区数据（穷举无意义）
- **注意**：Hinnant 用 `Int64`，验证需加 `INT64_MIN <= z <= INT64_MAX` 范围约束

## 十三、工程实践要点

### supported_targets 多后端配置

`moon.mod` 中 `supported_targets` 声明模块支持的目标：

```toml
preferred_target = "wasm"          # 默认目标
supported_targets = "+wasm+wasm-gc+js+native"  # 支持多后端
```

- `preferred_target`：`moon build`/`moon test` 默认目标
- `supported_targets`：`+` 分隔，可选 `wasm`/`wasm-gc`/`js`/`native`
- 包级覆盖：`moon.pkg` 可设 `supported_targets = "js"` 限定单后端
- 本项目（ADR-010）：`preferred_target = "wasm"`，`supported_targets = "+wasm+wasm-gc+js+native"`

### derive(ToJson, FromJson) + suberror 实践

全栈示例展示 derive + 显式 extend 的标准模式：

```moonbit
pub(all) struct SubmitTitleRequest { title : String }
derive(Eq, ToJson, FromJson)
///|
pub extend SubmitTitleRequest with Eq::{not_equal, equal}
///|
pub extend SubmitTitleRequest with ToJson::{to_json}
///|
pub extend SubmitTitleRequest with @moonbitlang/core/json.FromJson::{from_json}
///|

pub(all) suberror TitleValidationError { EmptyTitle; TooLong(Int32); ForbiddenHash }
derive(Eq, ToJson, FromJson)
// ... 显式 extend 每个 trait ...
```

**关键模式**：
- `derive(Eq, ToJson, FromJson)` 后**每个 trait 都需显式 `pub extend T with Trait::{method}`**
- `suberror` 自动提升 `Error`，可 `derive(ToJson, FromJson)` 序列化
- 本项目应用：`TzError`（suberror）可 derive(ToJson, FromJson) 供 RFC3339 错误序列化；`Tz`/`NaiveDateTime` 可 derive(ToJson, FromJson) 供序列化扩展（S8）

### async 函数与效应系统

| 修饰 | 语义 |
|------|------|
| `async fn` | 异步函数，隐式抛错 |
| `async fn -> T noraise` | 异步不抛普通错误 |
| `async fn -> T nocancel` | 异步不可取消（可调同步+nocancel，不可调可取消 async） |
| `async fn -> T noraise + nocancel` | 同时排除普通错误和取消 |

- 异步函数只能在异步函数中调用（类似 await）
- `async fn main` / `async test` 声明异步入口/测试
- **本项目不使用 async**（纯计算库），但 `noraise` 概念已吸收到 ADR-008（纯函数标 `noraise`）

### 结构化并发（不适用本项目，记录备查）

- `@async.with_task_group(group => { ... })` 创建任务组
- `group.spawn_bg(() => { ... })` 后台创建任务
- 规则：任务组所有任务结束才返回；失败时自动取消其余任务
- 超时/重试：`@async.with_timeout` / `@async.retry` 基于取消机制
- 本项目纯计算，无并发需求

### 库包 + cmd/main 拆分（不适用本项目，记录备查）

- 库包：参数解析+业务逻辑（可测试纯逻辑）
- `cmd/main`：接线（读 argv→构造配置→调库入口）
- `pkgtype(kind: "executable")` 标可执行包
- 本项目是库（`pkgtype` 默认 lib），无 `cmd/main`

### Makefile 工作流（参考 build-ci.md）

```makefile
check:  moon check --deny-warn --target all
test:   moon test --deny-warn --target all
verify: check test
```

- `--deny-warn`：警告视为错误（严格执行，符合用户偏好）
- `--target all`：所有支持后端
- 本项目 build-ci.md 已有 CI 配置，Makefile 可选补充

### Hurl API 测试（不适用本项目，记录备查）

- `hurl --test backend/api.hurl`：HTTP API 测试
- 本项目无 HTTP API，不适用；若 S8 添加 CLI 工具可考虑

> 文件结束 | chrono_tz-mbt migration-map v2.2 | 2026-11-05