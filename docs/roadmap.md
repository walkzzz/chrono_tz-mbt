# chrono_tz-mbt 迭代路线 / Roadmap

> 移植自 [chrono_tz_cangjie](https://gitcode.com/LOOYIABC/chrono_tz_cangjie.git)（仓颉 v2.157.0）→ MoonBit。
> 忠实移植 Rust [chrono-tz](https://github.com/chronotope/chrono-tz) 0.11.0 算法（Hinnant civil↔days、binary_search、DST 三分支）。
> IANA tzdata **2025b**，**597 时区**（340 规范 + 257 别名链接）。

## 项目定位

`chrono_tz-mbt` 聚焦 **IANA 时区核心**，不包含农历/八字/术数（那部分由姊妹项目 `moon-chrono_tz` 承载）。本项目追求比 `moon-chrono_tz/tz` 更 idiomatic 的 MoonBit：用 trait 系统与方法系统消除重复、用 `suberror`+`raise` 做错误处理、用 `derive` 自动生成 Eq/Compare/Show/ToJson、用文档测试（`mbt check`）保证示例常新。

## 范围

### 核心（必做）
- IANA tzdata 2025b：597 时区枚举 + `from_str`/`name` 往返
- DST 三分支：春进缺口（`None`）、秋退重叠（`Ambiguous`）、正常（`Single`）
- Hinnant civil↔days 算法：公历 ↔ Unix 时间戳 O(1) 互转，支持负时间戳
- UTC⇄本地双向转换
- `NaiveDateTime` / `DateTime` / `Date` / `TzOffset` / `CjDuration` 核心类型
- RFC 3339 输出 + 常用 strftime/strptime 格式符子集
- 全局查表去重（`tz_offset_table` / `tz_name_table`）

### 可选扩展（后续 Sprint，不阻塞核心发布）
- `TzCache` LRU 缓存
- `TzFormat` 偏移字符串解析
- `TzUtils` 便利查询（常用时区快捷构造、DST 判定、按偏移/前缀检索）
- 闰秒表 `LeapSecondTable`
- `DateRange` / `BusinessCalendar` / `HolidayTable`
- `TzSerialize` JSON 导出
- `TzGrouping` / `TzHumanize` / `TzLocale`

### 明确不做
- 农历 / 干支 / 节气 / 八字 / 术数（留给 `moon-chrono_tz`）

## 包结构

```
chrono_tz-mbt/                  # 根包：reexport.mbt 统一入口 @chrono_tz-mbt
├── core/                       # 运行时核心类型（零依赖）
│   └── timezone_core.mbt      # FixedTimespan/Span/FixedTimespanSet + 全局查表
├── data/                       # 时区数据（自动生成，340 常量）
│   ├── data_africa.mbt
│   ├── data_america.mbt
│   ├── data_asia.mbt
│   ├── data_australasia.mbt
│   ├── data_europe.mbt
│   └── data_others.mbt
├── tz/                         # 时区算法层
│   ├── datetime.mbt           # CjDuration/NaiveDateTime/DateTime/Date（Hinnant）
│   ├── timezone_impl.mbt      # binarySearch/TzOffset/LocalResult/TimeZone trait/GapInfo
│   ├── tz_variants.mbt        # Tz 枚举(597)/name()/from_str + NAME_TO_TZ 表
│   ├── tz_impl.mbt            # timespans() + offset_from_utc/local（DST 算法）
│   └── tz_format.mbt          # strftime/strptime/RFC3339
├── reexport.mbt                # 根包重导出
└── docs/                       # 开发文档（10 份）
    ├── roadmap.md              # 本文件：项目定位/范围/Sprint 计划/验收门禁
    ├── architecture.md         # ADR-001~016 架构决策记录
    ├── api.md                  # core/tz 公共 API 契约
    ├── migration-map.md        # 仓颉→MoonBit 移植映射 + 语法/类型/错误/属性 + 陷阱
    ├── testing.md              # 六层测试策略 + 验收用例
    ├── performance.md          # 性能预算表（复杂度/体积/基准目标）
    ├── error-codes.md          # TzError 子错误清单
    ├── tz-names.md             # 597 时区名命名规则/生成方式/from_str 策略
    ├── sprint-tasks.md         # S1-S8 详细任务拆解（文件/函数/测试）
    └── build-ci.md             # 构建命令/CI 集成/发布流程
```

依赖方向：`core ← data ← tz ← root`，线性无环。

## Sprint 计划

| Sprint | 内容 | 状态 | commit |
|--------|------|------|--------|
| S1 | `core` 包：`FixedTimespan`/`Span`/`FixedTimespanSet` + `tz_offset_table`(406)/`tz_name_table`(178) + Hinnant + `Ordering` | ✅ 完成 | - |
| S2 | `data` 包：6 文件 38711 行 + `Tz` 枚举 597 + `name`/`from_str`（纯二分查找） | ✅ 完成 | - |
| S3 | `tz/datetime.mbt`：`CjDuration`/`NaiveDateTime`/`Date`（Hinnant 集成） | ✅ 完成 | - |
| S4 | `tz/timezone_impl.mbt`：`TzOffset`/`LocalResult[T]`/`TimeZone` trait/`binary_search`/`GapInfo` | ✅ 完成 | - |
| S5 | `tz/tz_impl.mbt`：`timespans()`(597 arm) + DST 算法 + `DateTime` + `from_local` | ✅ 完成 | - |
| S6 | `tz/tz_format.mbt`：strftime + strptime + RFC3339 | ✅ 完成 | - |
| S7 | 黑盒/白盒/基准测试（全 597 扫描 + DST 检测 + UTC 零偏移） | ✅ 完成 | - |
| S8 | quickcheck 性质测试 + JSON 序列化（`to_json`/`to_json_compact`） | ✅ 完成 | - |
| S9 | MCP 服务器（JSON-RPC + 7 时区工具） | ✅ 完成 | - |
| S10 | CLI 工具（10 子命令：list/info/convert/now/parse/format/dst/search/diff/repl） | ✅ 完成 | - |
| S11 | LLM Agent（DeepSeek 流式聊天 + 时区上下文注入） | ✅ 完成 | - |
| S12 | 根包文档 + hackathon 申报书 | ✅ 完成 | - |
| S13 | 消除 warning + strptime 扩展 + CLI 增强 + Agent 工具集成 | ✅ 完成 | - |

## 验收门禁

每个 Sprint 完成前必须通过：

- `moon fmt`（代码已格式化）
- `moon check --target all` 0 error 0 warning
- `moon test --target native` 全通过
- `moon info --target native` 后 `.mbti` diff 符合预期（API 变更需记录）
- 文档测试（`///` 中的 `mbt check` 块）随 `moon test` 一起跑

核心验收用例：

- **DST 边界**：春进缺口（`LocalResult::None`）、秋退重叠（`Ambiguous(t1,t2)`）、正常（`Single(o)`）
- **Hinnant 往返**：`from_timestamp ∘ timestamp = id`，含负时间戳（1970 前）
- **597 时区遍历**：`from_str(name(tz)).unwrap() == tz` 对全部 597 时区成立
- **偏移正确性**：与 Rust chrono-tz 0.11.0 参考输出逐时区比对（抽样 + 边界年份）
- **RFC 3339**：`to_rfc3339` 输出与 chrono-tz 一致

## 与 moon-chrono_tz 的关系

| 维度 | chrono_tz-mbt（本项目） | moon-chrono_tz |
|------|------------------------|----------------|
| 范围 | 时区核心 | 时区 + 农历 + 八字 + 术数 |
| 设计目标 | idiomatic MoonBit（trait/方法/derive 去重） | 功能完备 |
| 错误处理 | `suberror`+`raise`+`T?` | `T?` + `Result` |
| 复用关系 | 参考 `moon-chrono_tz/tz` 与 `core` 的实现思路，但独立重写更精炼版本 | 既有实现，不改动 |

> 文件结束 | chrono_tz-mbt roadmap v2.0 | 2026-11-05