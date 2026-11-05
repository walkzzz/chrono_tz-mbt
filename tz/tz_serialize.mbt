///|
/// tz_serialize.mbt — DateTime/NaiveDateTime JSON 序列化（chrono_tz-mbt MoonBit 移植）

///|
/// 序列化为 JSON 对象字符串。
///
/// 格式：`{"rfc3339":"2025-07-15T12:00:00+08:00","timestamp":1752667200,"timezone":"Asia/Shanghai","offset":28800}`
pub fn DateTime::to_json(self : DateTime) -> String {
  let rfc = self.to_rfc3339()
  let ts = self.timestamp()
  let tz = self.tz_id()
  let off = self.offset_sec()
  "{\"rfc3339\":\"" +
  rfc +
  "\",\"timestamp\":" +
  ts.to_string() +
  ",\"timezone\":\"" +
  tz +
  "\",\"offset\":" +
  off.to_string() +
  "}"
}

///|
/// 序列化为简洁 JSON（仅 rfc3339 + timezone）。
///
/// 格式：`{"rfc3339":"2025-07-15T12:00:00+08:00","timezone":"Asia/Shanghai"}`
pub fn DateTime::to_json_compact(self : DateTime) -> String {
  let rfc = self.to_rfc3339()
  let tz = self.tz_id()
  "{\"rfc3339\":\"" + rfc + "\",\"timezone\":\"" + tz + "\"}"
}

///|
/// 序列化 NaiveDateTime 为 JSON（无时区信息）。
///
/// 格式：`{"rfc3339":"2025-07-15T12:00:00","timestamp":1752667200}`
pub fn NaiveDateTime::to_json(self : NaiveDateTime) -> String {
  let rfc = self.to_rfc_string()
  let ts = self.timestamp()
  "{\"rfc3339\":\"" + rfc + "\",\"timestamp\":" + ts.to_string() + "}"
}
