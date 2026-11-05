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
/// - `cmd/cli` — CLI 工具（10 个子命令）
/// - `cmd/agent` — LLM Agent（DeepSeek 流式聊天 + 时区上下文注入 + 7 个 tz: 工具调用）
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
///
/// ## 根包便捷 API
///
/// 根包提供一组无状态便捷函数，委托 `@tz` 完成常见时区操作，
/// 让调用方不必直接引用 `@tz` 的静态方法即可完成解析、转换、格式化等任务。
/// 涉及 `Tz` / `DateTime` / `NaiveDateTime` 等类型的构造与判别仍需 `@tz`。

///|
/// 返回支持的 IANA 时区总数（597）。
pub fn tz_count() -> Int32 {
  @tz.Tz::all().length()
}

///|
/// 返回全部 IANA 时区名称，顺序与 `@tz.Tz::all()` 一致。
pub fn tz_names() -> Array[String] {
  @tz.Tz::all_names()
}

///|
/// 解析 IANA 时区名称（如 `"Asia/Shanghai"`、`"UTC"`），失败返回 `None`。
///
/// 内部委托 `@tz.Tz::from_str`，采用纯二分查找，无 LRU 缓存。
pub fn tz_from_str(name : String) -> @tz.Tz? {
  @tz.Tz::from_str(name)
}

///|
/// 返回时区的 IANA 名称（如 `"Asia/Shanghai"`）。
pub fn tz_name(tz : @tz.Tz) -> String {
  tz.name()
}

///|
/// 返回时区在给定 **UTC 时间戳**（Unix 秒）下的偏移量（秒）。
///
/// 东区为正、西区为负。例如 `Asia/Shanghai` 全年 +28800（+08:00）。
/// 该函数按 UTC 时刻查表，自动包含 DST 偏移，不会产生歧义。
pub fn offset_from_utc(tz : @tz.Tz, timestamp : Int64) -> Int32 {
  let naive = @tz.NaiveDateTime::from_timestamp(timestamp)
  tz.offset_from_utc_date_time(naive).offset_sec()
}

///|
/// 返回时区在给定**本地时刻**下的偏移结果，处理 DST gap（时钟前跳）与
/// ambiguous（时钟回拨）两种边界。
///
/// - `Single(off)` — 唯一偏移
/// - `Ambiguous(off1, off2)` — 时钟回拨，两个偏移都合法
/// - `None` — 时钟前跳，该本地时刻不存在
pub fn offset_from_local(
  tz : @tz.Tz,
  naive : @tz.NaiveDateTime,
) -> @tz.LocalResult[@tz.TzOffset] {
  tz.offset_from_local_date_time(naive)
}

///|
/// 从 UTC 时间戳（Unix 秒）和时区构造 `DateTime`。
///
/// 构造出的 `DateTime` 携带该时区在 `timestamp` 时刻的偏移，
/// `timestamp` 字段与传入值一致，`to_rfc3339()` 输出对应本地时间。
pub fn datetime_from_timestamp(timestamp : Int64, tz : @tz.Tz) -> @tz.DateTime {
  let naive = @tz.NaiveDateTime::from_timestamp(timestamp)
  let off = tz.offset_from_utc_date_time(naive)
  @tz.DateTime::make(timestamp, off)
}

///|
/// 将 `DateTime` 转换到目标时区，时间戳不变、偏移与本地表示随之改变。
///
/// 这是纯时区转换，不涉及任何时长加减。
pub fn convert_timezone(dt : @tz.DateTime, target : @tz.Tz) -> @tz.DateTime {
  dt.with_timezone(target)
}

///|
/// 将 `DateTime` 序列化为 RFC 3339 字符串，如 `"2026-11-05T12:34:56+08:00"`。
pub fn to_rfc3339(dt : @tz.DateTime) -> String {
  dt.to_rfc3339()
}

///|
/// 解析 RFC 3339 字符串为 `DateTime`，失败返回 `None`。
///
/// 接受形如 `2026-11-05T12:34:56+08:00`、`2026-11-05T12:34:56Z` 的输入，
/// 偏移信息直接内嵌于结果，无需额外传入时区。
pub fn parse_rfc3339(s : String) -> @tz.DateTime? {
  @tz.DateTime::parse_rfc3339(s)
}

///|
/// 按 `strftime` 格式串格式化 `DateTime`。
///
/// 支持 `%Y %m %d %H %M %S %Z %z %A %a %B %b %j %%` 等 specifier。
pub fn strftime(fmt : String, dt : @tz.DateTime) -> String {
  @tz.strftime(fmt, dt)
}

///|
/// 按 `strptime` 格式串解析字符串为 `DateTime`，需指定结果所属时区。
///
/// 支持 `%Y %m %d %H %M %S %y %j %%` 及字面字符。失败返回 `None`。
pub fn strptime(fmt : String, s : String, tz : @tz.Tz) -> @tz.DateTime? {
  @tz.strptime(fmt, s, tz)
}

///|
/// 检测给定本地时刻在指定时区是否处于 DST gap（时钟向前跳，该本地时刻不存在）。
///
/// 返回 `Some(GapInfo)` 表示处于 gap，`None` 表示正常。
pub fn detect_gap(tz : @tz.Tz, naive : @tz.NaiveDateTime) -> @tz.GapInfo? {
  @tz.GapInfo::detect(naive, tz)
}

///|
/// 从本地时刻构造 `DateTime`，处理 DST gap 与 ambiguous。
///
/// - `Single(dt)` — 唯一对应
/// - `Ambiguous(dt1, dt2)` — 时钟回拨，两个时刻都合法
/// - `None` — 时钟前跳，该本地时刻不存在
pub fn from_local(
  tz : @tz.Tz,
  naive : @tz.NaiveDateTime,
) -> @tz.LocalResult[@tz.DateTime] {
  tz.from_local_date_time(naive)
}
