# 测试策略 / Testing Strategy

> 吸收 MoonBit 测试/基准/文档测试设计思想。覆盖黑盒/白盒/快照/性质/基准/文档六层。

## 一、测试分层

| 层 | 文件 | 能见度 | 用途 |
|----|------|--------|------|
| 文档测试 | `///` 中 ` ```mbt check ` | 黑盒（公开 API） | 示例常新、API 可用性 |
| 黑盒测试 | `*_test.mbt` | 公开 API | 行为契约、用户视角 |
| 白盒测试 | `*_wbtest.mbt` | 包内私有 | 内部不变量、辅助函数 |
| 快照测试 | `debug_inspect`/`json_inspect` | 同上 | 结构化输出固化 |
| 性质测试 | `@quickcheck` | 黑盒 | Hinnant 往返等不变量 |
| 基准测试 | `@bench.T` | 黑盒 | 性能回归监控 |

## 二、命令

```bash
moon fmt                                  # 格式化
moon check                                # 类型检查，0 error 0 warning
moon test --target native                 # 运行测试（165 个，native target）
moon test --update                        # 刷新快照
moon info                                 # 更新 .mbti，审查 API diff
moon coverage analyze > uncovered.log     # 覆盖率盲区
```

每个 Sprint 交付前跑：`moon fmt && moon check --target all && moon test --target native && moon info`。

## 三、文档测试（`mbt check`）

关键 `pub fn` 的 `///` 注释中嵌入 ` ```mbt check ` 块，随 `moon test` 一起跑，保证示例不腐化。

```moonbit
/// 解析 IANA 时区名，未知返回 None。
///
/// Example:
/// ```mbt check
/// test {
///   let tz = @chrono_tz-mbt.Tz::from_str("Asia/Shanghai")
///   assert_true(tz is Some(_))
///   assert_true(@chrono_tz-mbt.Tz::from_str("Foo/Bar") is None)
/// }
/// ```
pub fn Tz::from_str(s : String) -> Tz?
```

**注意**：文档测试是**黑盒**，只能用公开 API；私有定义的测试改放 `_wbtest.mbt`。

## 四、黑盒测试（`_test.mbt`）

验证公开 API 行为。按主题分文件：

| 文件 | 主题 |
|------|------|
| `tz_test.mbt` | `Tz::from_str`/`name` 597 往返、`timespans` |
| `datetime_test.mbt` | `NaiveDateTime` Hinnant 互转、算术、日历分量 |
| `dst_test.mbt` | DST 三分支：春进缺口/秋退重叠/正常 |
| `format_test.mbt` | RFC 3339、strftime/strptime |
| `offset_test.mbt` | `TzOffset` 偏移正确性（抽样比对 Rust chrono-tz） |
| `e2e_test.mbt` | 端到端：解析→构造→转换→格式化 |

**DST 边界用例**（必做）：

```moonbit
test "dst_spring_gap_new_york" {
  let ny = @tz.Tz::from_str("America/New_York").unwrap()
  let gap = @tz.NaiveDateTime::make(2026L, 3L, 8L, 2L, 30L, 0L)
  assert_true(ny.offset_from_local_date_time(gap) is R::None)
}

test "dst_fall_ambiguous_new_york" {
  let ny = @tz.Tz::from_str("America/New_York").unwrap()
  let amb = @tz.NaiveDateTime::make(2026L, 11L, 1L, 1L, 30L, 0L)
  match ny.offset_from_local_date_time(amb) {
    R::Ambiguous(a, b) => {
      assert_eq(a.offset_sec(), -14400)   // EDT
      assert_eq(b.offset_sec(), -18000)   // EST
    }
    _ => fail!("expected Ambiguous")
  }
}

test "dst_normal" {
  let ny = @tz.Tz::from_str("America/New_York").unwrap()
  let normal = @tz.NaiveDateTime::make(2026L, 7L, 15L, 12L, 0L, 0L)
  match ny.offset_from_local_date_time(normal) {
    R::Single(o) => assert_eq(o.offset_sec(), -14400)
    _ => fail!("expected Single")
  }
}
```

**597 时区遍历**：

```moonbit
test "all_tz_from_str_name_roundtrip" {
  for tz in @tz.TzUtils::all_timezones() {
    let name = tz.name()
    match @tz.Tz::from_str(name) {
      Some(tz2) => assert_eq(tz, tz2)
      None => fail!("from_str failed for \{name}")
    }
  }
}
```

## 五、白盒测试（`_wbtest.mbt`）

验证内部不变量与辅助函数，可访问私有定义：

```moonbit
// tz_wbtest.mbt — 可访问 tz 包私有
test "binary_search_internal" {
  let arr = [1, 3, 5, 7, 9]
  assert_eq(binary_search(0, arr.length(), fn(i) { compare(arr[i], 5) }), Some(2))
}

test "hinnant_days_from_civil_internal" {
  assert_eq(days_from_civil(1970L, 1L, 1L), 0L)
  assert_eq(days_from_civil(1969L, 12L, 31L), -1L)
}
```

## 六、快照测试

### Show 快照（`debug_inspect`）

用于结构化值固化输出：

```moonbit
test "naive_dt_show" {
  let dt = @tz.NaiveDateTime::make(2026L, 7L, 15L, 12L, 0L, 0L)
  debug_inspect(dt, content="NaiveDateTime::{ year: 2026, month: 7, day: 15, hour: 12, min: 0, sec: 0 }")
}
```

需 `derive(Debug)` + `extend T with Debug::{to_repr}`。`content` 可省略，`moon test --update` 自动插入。

### JSON 快照（`json_inspect`）

复杂结构用 JSON 更可读，需 `derive(ToJson)` + `extend T with ToJson::{to_json}`：

```moonbit
test "tz_offset_json" {
  let off = @tz.Tz::from_str("Asia/Shanghai").unwrap()
    .offset_from_utc_date_time(@tz.NaiveDateTime::make(2026L, 1L, 1L, 0L, 0L, 0L))
  json_inspect(off, content=["Asia/Shanghai", ["+08", 28800]])
}
```

### 原始输出快照

捕获任意输出（stdout/格式化串）：

```moonbit
test "rfc3339_snapshot" (t : @test.Test) {
  let tz = @tz.Tz::from_str("Europe/London").unwrap()
  for year in [2016L, 2020L, 2026L] {
    let dt = tz.ymd(year.to_int32(), 7, 15).and_hms(12, 0, 0)
    t.writeln(dt.to_rfc3339())
  }
  t.snapshot(filename="london_summer_rfc3339.txt")
}
```

## 七、性质测试（QuickCheck）

`moon.pkg` 加 `test-import "moonbitlang/core/quickcheck"`。验证不变量对大量随机输入成立：

```moonbit
test "hinnant_roundtrip_property" {
  @quickcheck.check(
    (ts : Int64) => {
      let dt = @tz.NaiveDateTime::from_timestamp(ts)
      dt.timestamp() == ts
    },
    count=1000,
    seed=2026,
  )
}
```

**Hinnant 往返**是核心不变量：`from_timestamp ∘ timestamp = id`。用 `check` 验证 1000 个随机 `Int64` 时间戳（含负值）。

发现反例后用 `report` 记录，并写固定回归测试保留该 case：

```moonbit
test "hinnant_roundtrip_regression" {
  let ts : Int64 = -62167219200L   // 0001-01-01 附近
  let dt = @tz.NaiveDateTime::from_timestamp(ts)
  assert_eq(dt.timestamp(), ts)
}
```

## 八、基准测试（`@bench.T`）

监控性能回归。`moon.pkg` 加 `test-import "moonbitlang/core/bench"`：

```moonbit
test "bench_offset_lookup" (b : @bench.T) {
  let tz = @tz.Tz::from_str("America/New_York").unwrap()
  let dt = @tz.NaiveDateTime::make(2026L, 7L, 15L, 12L, 0L, 0L)
  b.bench(name="offset_from_utc", fn() {
    b.keep(tz.offset_from_utc_date_time(dt))
  })
  b.bench(name="offset_from_local", fn() {
    b.keep(tz.offset_from_local_date_time(dt))
  })
}
```

`b.keep` 阻止编译器优化消除被测代码。`name` 用于批量对比。

## 九、验收用例清单

| 类别 | 用例 | 数量 |
|------|------|------|
| 597 遍历 | `from_str ∘ name = id` | 597 |
| Hinnant 往返 | `from_timestamp ∘ timestamp = id`（含负时间戳） | 性质 1000 + 回归若干 |
| DST 缺口 | 春进 `None`（NY/London/Sydney 等） | ≥6 |
| DST 重叠 | 秋退 `Ambiguous`（NY/London/Sydney 等） | ≥6 |
| DST 正常 | `Single` | ≥6 |
| 偏移正确性 | 与 Rust chrono-tz 抽样比对（边界年份） | ≥50 |
| RFC 3339 | 格式与 chrono-tz 一致 | ≥10 |
| 日历分量 | weekday/ordinal/days_in_month/leap_year | ≥20 |
| 算术 | add_seconds/add_days/add_months/add_years 往返 | ≥15 |
| 解析 | strptime 往返 | ≥10 |

## 十、测试组织约定

- 黑盒测试文件名 `<topic>_test.mbt`，白盒 `<topic>_wbtest.mbt`。
- 每个测试块带描述名：`test "dst_spring_gap_new_york" { ... }`。
- 优先 `assert_eq`/`assert_true(pattern is Pattern(...))`；结构化输出用 `debug_inspect`/`json_inspect`。
- 性质测试用 `@quickcheck.check`；发现反例后保留回归测试。
- 文档测试覆盖所有 `pub fn` 关键 API。
- `panic` 开头的测试名表示预期 panic。

## 十一、测试质量度量：CRAP Score + 变异测试

> CRAP 找"哪里危险"；变异测试验证"测试能不能守住危险区域"。

### CRAP Score（Change Risk Anti-Patterns）

公式：`CRAP(m) = comp(m)² × (1 - cov(m))³ + comp(m)`

- `comp(m)`：方法圈复杂度
- `cov(m)`：测试覆盖率（0~1）
- 阈值：**>30 高风险**，建议重构/补测试

| 场景 | CRAP | 含义 |
|------|------|------|
| 复杂但全覆盖 | ≈ 圈复杂度 | 风险低 |
| 简单没测试 | 不爆炸 | 风险低 |
| 高复杂 + 低覆盖 | 急剧升高 | 高危 |

**缺点**：只看"有没有跑到"，不校验断言有效性。空 assert 测试照样压低 CRAP。

### 变异测试（Mutation Testing）

原理：自动对源码做微小改动（`+→-`/`&&→||`/`>`→`>=`/常量修改等）→ 跑测试集 → 测试失败=杀死变异体（有效），测试通过=变异体存活（测试质量差）。

变异得分 = 杀死变异体 / 总有效变异体（排除等价变异体）

| 项 | CRAP | 变异测试 |
|----|------|---------|
| 本质 | 代码风险度量 | 测试有效性评估 |
| 速度 | 很快 | 很慢 |
| 识别假测试 | 否 | 是 |
| 适合 | CI 门禁 | 核心模块深度校验 |

### 推荐链路

1. 用 CRAP 筛选高风险函数（`moon coverage analyze` + 圈复杂度）
2. 只在高 CRAP 核心函数上跑变异测试（不全库跑，成本爆炸）
3. 变异存活的变异体 → 补断言、新增测试
4. 修复后 CRAP 下降、变异得分上升

### 本项目应用

- S7 验收：`moon coverage analyze` 检查覆盖率 > 90%
- 高 CRAP 函数：`offset_from_local_date_time`（DST 三分支，圈复杂度高）→ 重点补测试
- 变异测试：MoonBit 暂无原生工具，可手动构造等价变异体验证测试有效性

> 文件结束 | chrono_tz-mbt testing v2.0 | 2026-11-05