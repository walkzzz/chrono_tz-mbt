///|
/// timezone_impl.mbt — 运行时上层算法（chrono_tz-mbt MoonBit 移植）
/// 移植自仓颉 src/base/tz/timezone_impl.cj + moon-chrono_tz/tz/timezone_impl.mbt。
/// binary_search / TzError / TzOffset / LocalResult / TimeZone trait。
/// GapInfo 延迟到 S5（依赖 DateTime）。

///|
/// 时区操作错误类型（suberror 自动提升 Error）。
/// 分层策略（ADR-008）：查无 → T?；非法输入 → raise TzError；不变量破坏 → abort。
pub(all) suberror TzError {
  InvalidTzName(String)
  InvalidDate(Int64, Int64, Int64)
  InvalidTime(Int64, Int64, Int64)
  InvalidDayOfYear(Int64, Int64, Int32)
  InvalidTimestamp(Int64)
  InvalidFormatString(String)
  ParseError(String, Int32)
  Rfc3339ParseError(String, Int32)
  TzOffsetOutOfRange(Int32)
} derive(Debug)

///|
pub extend TzError with Debug::{to_repr}

///|
/// 二分查找，镜像 Rust `slice::binary_search_by` 语义。
/// Ok(idx) = 命中元素索引；Err(idx) = 插入点索引。
pub fn binary_search(
  start : Int32,
  end : Int32,
  f : (Int32) -> @core.Ordering,
) -> Result[Int32, Int32] {
  let mut s = start
  let mut e = end
  while s < e {
    let mid = s + (e - s) / 2
    match f(mid) {
      @core.Ordering::Less => s = mid + 1
      @core.Ordering::Greater => e = mid
      @core.Ordering::Equal => return Ok(mid)
    }
  }
  Err(s)
}

///|
/// 某 UTC 瞬时在某时区下的偏移，由时区与命中的 FixedTimespan 段组成。
pub struct TzOffset {
  tz : Tz
  span : @core.FixedTimespan
} derive(Eq, Debug)

///|
pub extend TzOffset with Eq::{not_equal, equal}

///|
pub extend TzOffset with Debug::{to_repr}

///|
/// 由时区与命中的 FixedTimespan 构造。
pub fn TzOffset::make(tz : Tz, offset : @core.FixedTimespan) -> TzOffset {
  TzOffset::{ tz, span: offset, }
}

///|
/// 返回 IANA 时区 ID（如 `Europe/Paris`）。
pub fn TzOffset::tz_id(self : TzOffset) -> String {
  self.tz.name()
}

///|
/// 返回偏移缩写（如 `CET`、`CEST`）。
pub fn TzOffset::abbreviation(self : TzOffset) -> String {
  self.span.name
}

///|
/// 返回偏移秒数（如 CET = +3600）。
pub fn TzOffset::offset_sec(self : TzOffset) -> Int32 {
  self.span.offset
}

///|
/// 返回偏移展示名（与 abbreviation 同源）。
pub fn TzOffset::offset(self : TzOffset) -> String {
  self.abbreviation()
}

///|
/// 返回偏移缩写字符串（同 abbreviation）。
pub fn TzOffset::to_string(self : TzOffset) -> String {
  self.abbreviation()
}

///|
/// 本地墙钟→UTC 解析的三分支结果，表达 DST 歧义与缺口。
pub enum LocalResult[T] {
  Single(T)
  Ambiguous(T, T)
  None
}

///|
/// 若为 Single 则返回 Some(v)，否则 None。
pub fn[T] LocalResult::single(self : LocalResult[T]) -> T? {
  match self {
    LocalResult::Single(v) => Some(v)
    _ => None
  }
}

///|
/// 取最早候选：Single 取其值，Ambiguous 取第一个，None 抛异常。
pub fn[T] LocalResult::earliest(self : LocalResult[T]) -> T {
  match self {
    LocalResult::Single(v) => v
    LocalResult::Ambiguous(a, _) => a
    LocalResult::None => abort("LocalResult.earliest on None")
  }
}

///|
/// 取最晚候选：Single 取其值，Ambiguous 取第二个，None 抛异常。
pub fn[T] LocalResult::latest(self : LocalResult[T]) -> T {
  match self {
    LocalResult::Single(v) => v
    LocalResult::Ambiguous(_, b) => b
    LocalResult::None => abort("LocalResult.latest on None")
  }
}

///|
/// 取唯一的 Single 值，Ambiguous 或 None 时抛异常。
pub fn[T] LocalResult::unwrap(self : LocalResult[T]) -> T {
  match self {
    LocalResult::Single(v) => v
    _ => abort("LocalResult.unwrap on non-Single value")
  }
}

///|
/// 判定是否为 Single。
pub fn[T] LocalResult::is_single(self : LocalResult[T]) -> Bool {
  match self {
    LocalResult::Single(_) => true
    _ => false
  }
}

///|
/// 判定是否为 None（DST 春进缺口）。
pub fn[T] LocalResult::is_none(self : LocalResult[T]) -> Bool {
  match self {
    LocalResult::None => true
    _ => false
  }
}

///|
/// 判定是否为 Ambiguous（DST 秋退重叠）。
pub fn[T] LocalResult::is_ambiguous(self : LocalResult[T]) -> Bool {
  match self {
    LocalResult::Ambiguous(_, _) => true
    _ => false
  }
}

///|
/// 时区等价接口（最小子集）。
/// S5 中 Tz 实现此 trait：`pub extend Tz with TimeZone::{offset_from_utc_date_time, offset_from_local_date_time}`。
pub trait TimeZone {
  fn offset_from_utc_date_time(Self, NaiveDateTime) -> TzOffset
  fn offset_from_local_date_time(Self, NaiveDateTime) -> LocalResult[TzOffset]
}
