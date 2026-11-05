# chrono_tz-mbt 项目申报书

> 2026 MoonBit 国产基础软件开源大赛参赛申报 | 方向：开发者工具 | 申报日期：2026-11-05

---

## 基本信息

- 项目名称：chrono_tz-mbt：MoonBit IANA 时区库
- 参赛者：walkzzz
- 联系方式：13689047817 745244185@qq.com
- GitHub 仓库链接：https://github.com/walkzzz/chrono_tz-mbt.git
- mooncakes 包名：`walkzzz/chrono_tz-mbt`
- 项目方向：开发者工具 — 时区核心库
- 是否为移植项目：是（从 chrono_tz_cangjie 仓颉 v2.157.0 移植，溯源 Rust chrono-tz 0.11.0）

---

## 项目简介

chrono_tz-mbt 是一个 MoonBit IANA 时区库，提供完整的时区计算能力：IANA tzdata 2025b（597 时区）+ DST 三分支（Gap/Ambiguous/Normal）+ Hinnant civil↔days 算法 + RFC3339 解析/格式化 + strftime/strptime。库同时提供三种交付形态：MCP 服务器（JSON-RPC stdio，7 个时区工具）、CLI 工具（10 个子命令）、LLM Agent（DeepSeek 流式聊天 + 时区上下文注入 + 7 个 tz: 工具调用）。

项目从仓颉版 chrono_tz_cangjie 移植到 MoonBit，**独立重写**核心算法（非直接代码转换），追求更 idiomatic 的 MoonBit 风格（trait/方法/derive 去重）。源数据来自 IANA tzdata 2025b，覆盖全球 6 大洲 597 个时区，包含完整的 DST 历史规则。

mooncakes 生态调研确认：截至 2026-10-23，**无任何完整 IANA 时区库**（597 时区 + DST + RFC3339 + strftime/strptime）在 mooncakes 上发布，本项目填补该空白。

---

## 当前完成状态（v0.1.0）

| 指标 | 数值 |
|------|------|
| 包数 | **7**（根 + core + data + tz + cmd/mcp + cmd/cli + cmd/agent） |
| 测试数 | **156**（全部通过，native target） |
| Warnings | **0** |
| Errors | **0** |
| IANA 时区数 | **597**（tzdata 2025b，6 大洲） |
| DST 处理 | 三分支（Gap / Ambiguous / Normal） |
| 数据行数 | **38711**（6 大洲 IANA tzdata 数据文件） |
| Sprint 迭代 | **15** 轮（S1-S15 全部完成） |
| Hinnant 算法 | ✅ 纯整数 O(1)，支持负时间戳 |
| RFC3339 | ✅ parse_rfc3339 / to_rfc3339 往返一致 |
| strftime | ✅ %Y %m %d %H %M %S %Z %z %A %a %B %b %j %% |
| strptime | ✅ 扩展版（%Y %m %d %H %M %S %y %j %% 及字面字符，通用解析器） |
| JSON 序列化 | ✅ DateTime / NaiveDateTime to_json / to_json_compact |
| MCP 服务器 | ✅ 7 个时区工具（JSON-RPC stdio） |
| CLI 工具 | ✅ 10 个子命令（list/info/convert/now/parse/format/dst/search/diff/repl） |
| LLM Agent | ✅ DeepSeek 流式聊天 + 时区上下文注入 + 7 个 tz: 工具调用 |
| @quickcheck | ✅ 7 个 Hinnant 算法性质测试 |
| 基准测试 | ✅ 6 个（from_str/offset/timestamp/strftime/rfc3339/parse） |
| 工具链 | MoonBit v0.1.20260920 |

---

## 技术方案

### 三包线性架构

```
core（零依赖核心类型）
  ↑
data（6 大洲 IANA tzdata 数据）
  ↑
tz（时区算法：Tz 枚举 + DateTime + DST + RFC3339 + strftime/strptime）
  ↑
根包（文档入口 + 14 个便捷函数：tz_from_str/offset_from_utc/convert_timezone/to_rfc3339/parse_rfc3339/strftime/strptime/detect_gap/from_local/...）
```

线性无环依赖，core 零依赖可独立复用。

### Hinnant civil↔days 算法

纯整数 O(1) 转换，无浮点运算，支持负时间戳（1970 年前）：

```
NaiveDateTime ──from_timestamp──→ civil_from_days ──→ (year, month, day)
                                                    ↓
DateTime ──to_rfc3339──→ "2025-07-15T12:00:00+08:00"
                                                    ↑
NaiveDateTime ──timestamp──← days_from_civil ──← (year, month, day)
```

### DST 三分支处理

```
offset_from_local_date_time(tz, naive) → LocalResult[TzOffset]

enum LocalResult[T] {
  Single(T)       // Normal — 唯一解
  Ambiguous(T, T) // 秋季回拨 — 两个解（夏令时→标准时间）
  None            // 春季前跳 — 无解（标准时间→夏令时）
}
```

### 全局查表去重

core 包存储 406 个时区时间段 + 178 个偏移/缩写索引，通过 `FixedTimespanSet` 压缩存储（`first_offset_idx`/`first_abbr_idx` + `rest_compact`），避免重复存储相同偏移量和缩写。

### 类型映射

| MoonBit | 说明 | 示例 |
|---------|------|------|
| `Tz` | 597 时区枚举 | `Tz::from_str("Asia/Shanghai")` |
| `NaiveDateTime` | 墙钟时刻（无时区） | `NaiveDateTime::from_timestamp(0L)` |
| `DateTime` | 带时区时刻 | `DateTime::make(ts, offset)` |
| `Date` | 仅年月日 | `Date::make(2025, 7, 15)` |
| `TzOffset` | 时区偏移 | `tz.offset_from_utc_date_time(naive)` |
| `CjDuration` | 秒级时长 | `CjDuration::hours(3)` |
| `LocalResult[T]` | DST 三分支 | `Single / Ambiguous / None` |
| `GapInfo` | DST 缺口信息 | `GapInfo::detect(tz, naive)` |

---

## 核心功能范围

### tz 包 — 时区算法核心

- `Tz::from_str(name) -> Tz?` — 二分查找解析时区名（597 时区）
- `Tz::all() -> Array[Tz]` / `Tz::all_names() -> Array[String]` — 全部时区
- `Tz::offset_from_utc_date_time(naive) -> TzOffset` — UTC→本地偏移
- `Tz::offset_from_local_date_time(naive) -> LocalResult[TzOffset]` — 本地→UTC 偏移（DST 三分支）
- `DateTime::parse_rfc3339(s) -> DateTime?` — RFC3339 解析
- `DateTime::to_rfc3339() -> String` — RFC3339 格式化
- `DateTime::with_timezone(tz) -> DateTime` — 时区转换
- `DateTime::strftime(fmt) -> String` — strftime 格式化
- `DateTime::to_json() -> String` — JSON 序列化

### MCP 服务器（cmd/mcp）

JSON-RPC over stdio，7 个时区工具：

- `list_timezones` — 列出全部 597 时区
- `get_offset` — 获取指定时区偏移
- `convert_time` — 时区转换
- `parse_rfc3339` — RFC3339 解析
- `format_time` — strftime 格式化
- `get_current_time` — 获取当前时间
- `detect_dst` — DST 检测

### CLI 工具（cmd/cli）

10 个子命令：

- `list` — 列出全部 597 时区
- `info <tz>` — 时区详情（偏移/DST）
- `convert <ts> <from> <to>` — 时区转换
- `now <tz>` — 当前时间
- `parse <rfc3339>` — RFC3339 解析
- `format <fmt> <rfc3339>` — strftime 格式化
- `dst <tz>` — DST 检测
- `search <keyword>` — 模糊搜索时区名
- `diff <ts> <tz1> <tz2>` — 两时区时间差比较
- `repl` — 交互式 REPL 模式

### LLM Agent（cmd/agent）

DeepSeek 流式聊天（SSE）+ 系统提示注入时区上下文（当前 UTC 时间 + 14 常用时区偏移）+ 思考过程灰色显示 + Ctrl+C 中断 + 多轮对话 + **7 个 tz: 工具调用**：

- `tz:now <tz>` — 获取指定时区当前时间
- `tz:convert <ts> <from> <to>` — 时区转换
- `tz:offset <tz>` — 查询时区偏移
- `tz:dst <tz>` — DST 检测
- `tz:search <keyword>` — 模糊搜索时区
- `tz:list` — 列出全部时区
- `tz:help` — 显示帮助

### 质量与测试

| 测试手段 | 测试数 | 状态 | 覆盖维度 |
|----------|--------|------|----------|
| 白盒测试 | 122 | ✅ Pass | Hinnant/FixedTimespan/DateTime/DST/RFC3339/strftime/strptime/序列化/根包便捷API |
| 黑盒测试 | 15 | ✅ Pass | from_str roundtrip/RFC3339 往返/时区转换/597 扫描/strftime |
| @quickcheck | 7 | ✅ Pass | civil↔day 互逆/timestamp 往返/分量范围/weekday/ordinal |
| 基准测试 | 6 | ✅ Pass | from_str/offset/timestamp/strftime/rfc3339/parse 性能 |
| strptime 扩展 | 8 | ✅ Pass | %y/%j/%%/自定义格式/日期only |
| **总计** | **156** | **✅ All Pass** | **五维度全覆盖** |

---

## 项目架构（7 个包）

```
chrono_tz-mbt/
├── moon.mod / moon.pkg          # 根包（文档入口 + 14 个便捷函数）
├── core/                        # 零依赖核心类型
│   ├── hinnant.mbt              #   Hinnant civil↔days 算法
│   └── timezone_core.mbt       #   Ordering + FixedTimespan + Span + 全局查表
├── data/                        # 6 大洲 IANA tzdata 数据（38711 行）
│   ├── africa.mbt
│   ├── america.mbt
│   ├── antarctica.mbt
│   ├── asia.mbt
│   ├── australasia.mbt
│   └── europe.mbt
├── tz/                          # 时区算法
│   ├── tz_variants.mbt          #   Tz 枚举 597 + from_str（二分查找）
│   ├── datetime.mbt             #   NaiveDateTime + Date + DateTime + CjDuration
│   ├── timezone_impl.mbt        #   TzOffset + LocalResult + TimeZone trait
│   ├── tz_impl.mbt              #   timespans + offset_from_utc/local + GapInfo
│   ├── tz_format.mbt            #   strftime + strptime + RFC3339
│   ├── tz_serialize.mbt         #   JSON 序列化
│   └── tz_bench.mbt             #   公开基准测试 API
├── cmd/mcp/                     # MCP 服务器（JSON-RPC + 7 时区工具）
├── cmd/cli/                     # CLI 工具（10 子命令：list/info/convert/now/parse/format/dst/search/diff/repl）
├── cmd/agent/                   # LLM Agent（DeepSeek 流式聊天 + 7 tz: 工具调用）
└── docs/                        # 开发文档（10 份）
    ├── roadmap.md
    ├── architecture.md          # ADR-001~016
    ├── api.md
    ├── migration-map.md
    ├── testing.md
    ├── performance.md
    ├── error-codes.md
    ├── tz-names.md
    ├── sprint-tasks.md
    └── build-ci.md
```

---

## Sprint 交付计划

| Sprint | 交付内容 | 验收标准 | 实际状态 |
|--------|---------|---------|---------|
| S1 | core 包 — Hinnant + FixedTimespan + 全局查表 | 11 白盒测试 | ✅ 完成 |
| S2 | data 包 + Tz 枚举 597 + from_str | 3 黑盒测试 | ✅ 完成 |
| S3 | NaiveDateTime / Date / CjDuration | 28 白盒测试 | ✅ 完成 |
| S4 | TzOffset + LocalResult + TimeZone trait | 12 白盒测试 | ✅ 完成 |
| S5 | DateTime + DST + GapInfo | 22 白盒测试 | ✅ 完成 |
| S6 | strftime / strptime / RFC3339 | 24 白盒测试 | ✅ 完成 |
| S7 | 黑盒/白盒/基准测试（全 597 扫描） | 2 黑盒 + 10 白盒 + 6 基准 | ✅ 完成 |
| S8 | @quickcheck + JSON 序列化 | 7 quickcheck + 5 序列化 | ✅ 完成 |
| S9 | MCP 服务器 | 7 时区工具 | ✅ 完成 |
| S10 | CLI 工具 | 7 子命令 | ✅ 完成 |
| S11 | LLM Agent | DeepSeek 流式聊天 + 时区上下文 | ✅ 完成 |
| S12 | 根包文档 + 申报书 | 6 白盒 + 5 黑盒 | ✅ 完成 |
| S13 | 消除 warning + strptime 扩展 + CLI 增强 + Agent 工具集成 | 8 strptime 测试 + 3 CLI 子命令 + 7 tz: 工具 | ✅ 完成 |
| S14 | 文档完善 + 元数据修正 | moon.mod/README/docs 全部更新 v2.0 | ✅ 完成 |
| S15 | 根包便捷 API 扩展 + 接口文档完善 | 2→14 函数 + 9 smoke test（147→156） | ✅ 完成 |

---

## 参考与设计说明

- 参考项目 1：[chrono-tz](https://github.com/chronotope/chrono-tz) — Rust 原版（0.11.0）
- 参考项目 2：[chrono_tz_cangjie](https://github.com/walkzzz/chrono_tz_cangjie) — 仓颉移植版（v2.157.0）
- 参考项目 3：[Hinnant algorithms](http://howardhinnant.github.io/date_algorithms.html) — civil↔days 算法
- 参考项目 4：[IANA tzdata](https://www.iana.org/time-zones) — 时区数据库 2025b
- 本项目许可证：Apache-2.0

### 设计原则

- **独立重写**：核心算法独立重写，非直接代码转换，追求 idiomatic MoonBit
- **纯整数运算**：Hinnant 算法无浮点，O(1) 复杂度，支持负时间戳
- **DST 三分支**：Gap/Ambiguous/None 泛型枚举，完整处理 DST 转换
- **全局查表去重**：406 时区段 + 178 偏移索引，压缩存储避免重复
- **零依赖核心**：core 包零依赖可独立复用
- **三包线性无环**：core ← data ← tz，清晰的依赖层次

### 生态协同

- **MCP 服务器**：可被任意 MCP 客户端（Claude Desktop / VS Code Copilot）直接调用
- **CLI 工具**：命令行时区查询/转换，可嵌入 shell 脚本
- **LLM Agent**：DeepSeek 流式聊天 + 时区上下文注入，自然语言时区问答

---

## 验收标准对齐（大赛要求）

| 大赛验收项 | 本项目满足方式 |
|-----------|-------------|
| MoonBit 为主 | 库自身 100% MoonBit 实现（时区算法 + DST + RFC3339 + MCP + CLI + Agent） |
| 仓库公开 | GitHub 公开仓库，持续提交（S1-S14，14 轮 Sprint） |
| 能够运行 | README + 可运行示例 + 156 测试 + 0 warnings |
| 工作有效 | 从仓颉移植到 MoonBit，独立重写核心算法，2026-11 完成 |
| 开源合规 | Apache-2.0 License，参考来源已标注 |
| AI 可解释 | AI 辅助开发，所有算法经人工审查 |

---

## 技术亮点

1. **597 IANA 时区全覆盖** — tzdata 2025b，6 大洲，含完整 DST 历史规则
2. **DST 三分支完整处理** — Gap（春进缺口）/ Ambiguous（秋退重叠）/ Normal，泛型 LocalResult[T]
3. **Hinnant 纯整数算法** — civil↔days O(1) 互逆转换，无浮点，支持负时间戳
4. **全局查表去重** — 406 段 + 178 索引压缩存储，内存高效
5. **RFC3339 往返一致** — parse_rfc3339 ∘ to_rfc3339 = id
6. **@quickcheck 性质测试** — 7 个 Hinnant 算法性质测试（civil↔day 互逆 / timestamp 往返 / 分量范围）
7. **三种交付形态** — MCP 服务器（JSON-RPC）+ CLI 工具（10 子命令）+ LLM Agent（DeepSeek 流式 + 7 tz: 工具调用）
8. **零 warnings** — moon check 0 warnings 0 errors，代码质量严格
9. **156 测试全通过** — 白盒 122 + 黑盒 15 + quickcheck 7 + 基准 6 + strptime 8，五维度全覆盖
10. **线性无环架构** — core ← data ← tz 三包线性，core 零依赖可独立复用

---

## 技术风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| WASM local count 限制 | 597 match arm 在 WASM 报错 | 用 native target 测试（`--target native`） |
| tzdata 版本更新 | 时区规则变更 | 数据文件按大洲分离，可独立更新 |
| MoonBit 语言 beta-preview | 语言本身尚未 stable | 已可用于生产，不兼容变更严格评估 |
| strptime 格式扩展 | 已支持 %Y %m %d %H %M %S %y %j %% 及字面字符 | 通用解析器架构，可继续扩展完整规格 |
| LLM Agent 依赖外部 API | DeepSeek API 变更 | API 调用隔离在 agent 包，不影响核心库 |