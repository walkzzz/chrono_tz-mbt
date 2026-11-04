# 性能预算表 / Performance Budget

> 各操作的目标时间复杂度与空间占用，作为 S1-S7 验收基准。
> 基于源仓颉 `chrono_tz_cangjie` 与参考 `moon-chrono_tz` 的实测数据。

## 一、核心操作复杂度

| 操作 | 时间复杂度 | 空间 | 说明 |
|------|-----------|------|------|
| `Tz::from_str(s)` | O(n) 或 O(log n) | O(1) | n=597；线性查 NAME_TO_TZ 或二分查排序表 |
| `Tz::name()` | O(1) | O(1) | match 597 分支，编译期跳表 |
| `FixedTimespanSet::get(i)` | O(1) | O(1) | 数组索引 + 两次查表 |
| `FixedTimespanSet::offsetAt(i)` | O(1) | O(1) | 数组索引 + 一次查表 |
| `FixedTimespanSet::utcSpan(i)` | O(1) | O(1) | 数组索引 |
| `FixedTimespanSet::localSpan(i)` | O(1) | O(1) | 数组索引 + 一次查表 |
| `binary_search(transitions, ts)` | O(log m) | O(1) | m=该时区 transition 数（1~200+） |
| `offset_from_utc_date_time(tz, dt)` | O(log m) | O(1) | 二分查 transitions + get |
| `offset_from_local_date_time(tz, dt)` | O(log m) | O(1) | 二分查 local spans，三分支判定 |
| `NaiveDateTime::make(...)` | O(1) | O(1) | 字段校验 + Hinnant |
| `days_from_civil(y, m, d)` | O(1) | O(1) | 纯整数算术 |
| `civil_from_days(days)` | O(1) | O(1) | 纯整数算术 |
| `NaiveDateTime::timestamp()` | O(1) | O(1) | days_from_civil × 86400 + 时分秒 |
| `NaiveDateTime::from_timestamp(ts)` | O(1) | O(1) | civil_from_days + 余数分解 |
| `DateTime::from_local(dt, tz)` | O(log m) | O(1) | offset_from_local + 加偏移 |
| `DateTime::to_utc(dt)` | O(1) | O(1) | 已存 offset，减偏移 |
| `strftime(fmt, dt)` | O(|fmt|) | O(|out|) | 扫格式串，逐 specifier 输出 |
| `strptime(fmt, s)` | O(|fmt| + |s|) | O(1) | 扫格式串 + 输入串 |
| `RFC3339::parse(s)` | O(|s|) | O(1) | 固定格式线性扫 |
| `RFC3339::format(dt)` | O(1) | O(1) | 固定长度输出 |

## 二、全局查表体积

| 表 | 条目数 | 元素类型 | 估算内存 | 说明 |
|----|--------|---------|---------|------|
| `TZ_OFFSET_TABLE` | 406 | Int32 | ~1.6 KB | 406 唯一偏移值，升序 |
| `TZ_NAME_TABLE` | 178 | String | ~3.5 KB | 178 唯一缩写，字典序 |
| `NAME_TO_TZ` | 597 | (String, Tz) | ~15 KB | 时区名→枚举映射（from_str 用） |
| 6 大洲 data | 597 时区 | FixedTimespanSet | ~200 KB | 每时区 restCompact 平均 ~330 字节 |

**总静态数据**：约 220 KB（wasm 产物中常量段）。

## 三、单时区 FixedTimespanSet 体积

| 字段 | 类型 | 说明 |
|------|------|------|
| `firstOffsetIdx` | Int64 | 8 字节 |
| `firstAbbrIdx` | Int64 | 8 字节 |
| `restCompact` | Array[(Int64, Int64, Int64)] | 每条 24 字节 + 数组开销 |

- 最小时区（无 DST，1 段）：restCompact 为空，~16 字节
- 最大时区（多 DST 历史，200+ 段）：~4.8 KB
- 平均：~330 字节（源仓颉 36446 段 / 597 时区 ≈ 61 段）

## 四、DST 三分支开销

| 场景 | 操作 | 开销 |
|------|------|------|
| 正常（Single） | 一次二分 + 一次比较 | O(log m) |
| 秋退重叠（Ambiguous） | 两次二分 + 两次比较 | O(log m) |
| 春进缺口（None） | 一次二分 + 区间检查 | O(log m) |

三分支判定无额外渐进开销，常数因子 ~2x。

## 五、目标基准（native 后端，单核 3GHz）

| 操作 | 目标吞吐 | 说明 |
|------|---------|------|
| `Tz::from_str` | > 10 M ops/s | 597 条线性查或二分 |
| `offset_from_utc_date_time` | > 5 M ops/s | 二分 ~7 步 |
| `offset_from_local_date_time` | > 3 M ops/s | 二分 + 三分支 |
| `NaiveDateTime::timestamp` | > 20 M ops/s | 纯整数算术 |
| `civil_from_days` | > 20 M ops/s | 纯整数算术 |
| `strftime`（短格式） | > 2 M ops/s | 扫格式串 |
| `RFC3339::parse` | > 5 M ops/s | 固定格式线性扫 |

> 基准用 `@bench.T` + `b.bench` + `b.keep` 编写，`moon test --bench` 运行。
> S7 验收时与 moon-chrono_tz 对比，应持平或更优。

## 六、wasm 产物体积目标

| 组件 | 目标 | 说明 |
|------|------|------|
| core 包 | < 30 KB | 类型 + 查表 + Hinnant |
| data 包 | < 250 KB | 597 时区数据 |
| tz 包 | < 50 KB | 算法 + 格式化 |
| 总计（wasm） | < 330 KB | 压缩前 |

> `moon build --target wasm` 后检查 `.wasm` 文件大小。

> 文件结束 | chrono_tz-mbt performance v1.0 | 2026-11-04