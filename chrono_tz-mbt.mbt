///|
/// chrono_tz-mbt — IANA 时区库根包。
///
/// 移植自 chrono_tz_cangjie（仓颉 v2.157.0，Rust chrono-tz 0.11.0）。
/// 聚焦 IANA tzdata 2025b（597 时区）+ DST + Hinnant + RFC3339。
///
/// ## 包结构
///
/// - `core` — 零依赖核心类型（Hinnant civil↔days + FixedTimespan + 全局查表）
/// - `data` — 6 大洲 IANA tzdata 数据文件
/// - `tz` — 时区算法（Tz 枚举 + DateTime + DST + RFC3339 + strftime/strptime）
/// - `cmd/mcp` — MCP 服务器（stdio JSON-RPC，7 个时区工具）
/// - `cmd/cli` — CLI 工具（7 个子命令）
/// - `cmd/agent` — LLM Agent（DeepSeek 流式聊天 + 时区上下文注入）
///
/// ## 快速开始
///
/// ```moonbit
/// let tz = @tz.Tz::from_str("Asia/Shanghai").unwrap()
/// let naive = @tz.NaiveDateTime::from_timestamp(0L)
/// let off = tz.offset_from_utc_date_time(naive)
/// let dt = @tz.DateTime::make(0L, off)
/// println(dt.to_rfc3339())
/// ```
///
/// 依赖 `walkzzz/chrono_tz-mbt/tz` 包使用全部时区功能。

///|
/// 返回支持的 IANA 时区总数（597）。
pub fn tz_count() -> Int32 {
  @tz.Tz::all().length()
}

///|
/// 返回全部 IANA 时区名称。
pub fn tz_names() -> Array[String] {
  @tz.Tz::all_names()
}
