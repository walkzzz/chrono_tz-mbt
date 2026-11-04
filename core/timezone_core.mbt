///|
/// timezone_core.mbt — 运行时核心类型（chrono_tz-mbt MoonBit 移植）
/// 忠实移植自仓颉 src/core/timezone_core.cj（源自 Rust chrono-tz 0.11.0）。
/// 仅依赖 MoonBit core，无任何本库依赖，供 data 子包与 tz 算法层复用。

///|
/// IANA tzdb 版本号。
pub const IANA_TZDB_VERSION : String = "2025b"

///|
/// 三路比较结果：`Less` / `Equal` / `Greater`。
///
/// MoonBit 标准库未提供此枚举（其 `Compare` trait 的 `compare` 方法返回
/// `Int32` 的负/零/正），本项目为 DST 三分支判断的类型安全与可读性自定义。
/// 序关系按声明顺序：`Less < Equal < Greater`。
pub(all) enum Ordering {
  Less
  Equal
  Greater
} derive(Eq, Compare, Debug)

///|
pub extend Ordering with Eq::{not_equal, equal}

///|
pub extend Ordering with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Ordering with Debug::{to_repr}

///|
/// 单段固定偏移：从某过渡点起生效的 UTC 偏移（秒）及其缩写名。
pub(all) struct FixedTimespan {
  offset : Int32
  name : String
} derive(Eq, Compare, Debug)

///|
pub extend FixedTimespan with Eq::{not_equal, equal}

///|
pub extend FixedTimespan with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend FixedTimespan with Debug::{to_repr}

///|
/// 左闭右开的时间戳区间 `[begin, end)`，begin/end 为 None 表示无界。
pub(all) struct Span {
  begin : Int64?
  end : Int64?
} derive(Eq, Compare, Debug)

///|
pub extend Span with Eq::{not_equal, equal}

///|
pub extend Span with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Span with Debug::{to_repr}

///|
/// 返回 x 相对本区间的序：x 在区间内 Equal，x 早于区间 Greater，x 晚于区间 Less。
pub fn Span::cmp(self : Span, x : Int64) -> Ordering {
  match (self.begin, self.end) {
    (Some(a), Some(b)) =>
      if a <= x && x < b {
        Ordering::Equal
      } else if a <= x && b <= x {
        Ordering::Less
      } else {
        Ordering::Greater
      }
    (Some(a), None) => if a <= x { Ordering::Equal } else { Ordering::Greater }
    (None, Some(b)) => if b <= x { Ordering::Less } else { Ordering::Equal }
    (None, None) => Ordering::Equal
  }
}

///|
/// 判断 x 是否落在 `[begin, end)` 内（含无界语义）。
pub fn Span::contains(self : Span, x : Int64) -> Bool {
  match (self.begin, self.end) {
    (Some(a), Some(b)) => a <= x && x < b
    (Some(a), None) => a <= x
    (None, Some(b)) => b > x
    (None, None) => true
  }
}

///|
/// 全局 UTC 偏移查表（406 个唯一值，升序排列）。
pub let tz_offset_table : Array[Int32] = [
  -57368, -54124, -51660, -47284, -43200, -42398, -41400, -41216, -41096, -40968,
  -40800, -40780, -39698, -39600, -38400, -38344, -37886, -37800, -37760, -36000,
  -35976, -35896, -34200, -33535, -33480, -33460, -32473, -32412, -32400, -32388,
  -32261, -31578, -31220, -30600, -29548, -29447, -28856, -28800, -28378, -28084,
  -27889, -27232, -26898, -26632, -26248, -25880, -25556, -25540, -25460, -25260,
  -25200, -25196, -25116, -25060, -24427, -24339, -24312, -24076, -23796, -23400,
  -23316, -21724, -21600, -21508, -21504, -21408, -21168, -21036, -21027, -21007,
  -20947, -20932, -20824, -20823, -20790, -20785, -20723, -20712, -20708, -20678,
  -20582, -20416, -20364, -20173, -19931, -19800, -19776, -19768, -19176, -19160,
  -19088, -19052, -18840, -18516, -18492, -18430, -18000, -17776, -17762, -17360,
  -17340, -17296, -17072, -17020, -16965, -16800, -16776, -16768, -16612, -16516,
  -16508, -16444, -16392, -16356, -16272, -16200, -16064, -16060, -16044, -15924,
  -15865, -15788, -15700, -15672, -15652, -15558, -15548, -15408, -15336, -15264,
  -14660, -14560, -14500, -14404, -14400, -14388, -14309, -14028, -13959, -13884,
  -13840, -13500, -13491, -13480, -13460, -13252, -13240, -13236, -13128, -13108,
  -12756, -12652, -12600, -12560, -12416, -11958, -11636, -11568, -11188, -10800,
  -9244, -9240, -9052, -9000, -8768, -8572, -8376, -7780, -7200, -6872, -6160, -5644,
  -5400, -5272, -4480, -4056, -3740, -3696, -3600, -3168, -2670, -2588, -2205, -1820,
  -1624, -1521, -1284, -1276, -968, -884, -75, 0, 364, 561, 732, 815, 1050, 1616,
  1786, 1800, 2048, 2079, 2444, 2996, 3164, 3208, 3464, 3484, 3600, 3612, 3921, 4104,
  4580, 4760, 4920, 5040, 5400, 5596, 5692, 5736, 5794, 5940, 5989, 6076, 6264, 6600,
  6616, 6720, 6900, 6920, 6952, 7016, 7200, 7324, 7509, 7588, 7808, 7818, 8008, 8148,
  8160, 8184, 8272, 8423, 8440, 8454, 8520, 8624, 8712, 8836, 9000, 9017, 9079, 9394,
  9900, 10656, 10660, 10680, 10751, 10800, 11058, 11212, 11532, 11616, 11928, 11964,
  12020, 12064, 12324, 12344, 12368, 12464, 12600, 12679, 13272, 13505, 13720, 13800,
  14012, 14400, 14553, 15268, 15712, 16073, 16092, 16200, 16279, 16512, 16608, 16631,
  17380, 17610, 17640, 17904, 18000, 18468, 19164, 19172, 19270, 19800, 19900, 20100,
  20391, 20476, 20700, 20928, 21020, 21200, 21208, 21516, 21600, 21700, 21996, 22286,
  23087, 23400, 24124, 24925, 25025, 25200, 25590, 25632, 25652, 26240, 26400, 26480,
  27000, 27232, 27250, 27402, 27804, 28656, 28800, 29032, 29143, 29160, 30000, 30140,
  30180, 30472, 30600, 30928, 31138, 31400, 31500, 31651, 32276, 32400, 32533, 33260,
  33539, 33768, 33948, 34200, 34248, 34374, 34740, 34792, 35100, 35312, 35320, 35356,
  35756, 36000, 36192, 36292, 36728, 36892, 37336, 37800, 38076, 38180, 38388, 39116,
  39600, 39948, 40060, 40160, 40312, 40320, 40396, 41400, 41524, 41944, 42596, 42944,
  43200, 44002, 44028, 44100, 44352, 44400, 45000, 45184, 45432, 45900, 46702, 46800,
  48056, 49500, 50400, 50424, 52865, 53927, 54139, 54822,
]

///|
/// 全局时区缩写查表（178 个唯一值，字典序排列）。
pub let tz_name_table : Array[String] = [
  "+00", "+0030", "+01", "+0130", "+02", "+0230", "+0245", "+03", "+0330", "+04",
  "+0430", "+05", "+0530", "+0545", "+06", "+0630", "+07", "+0720", "+0730", "+08",
  "+0820", "+0845", "+09", "+0930", "+0945", "+10", "+1030", "+11", "+1112", "+1130",
  "+12", "+1215", "+1220", "+1230", "+1245", "+13", "+1345", "+14", "-00", "-01",
  "-0130", "-02", "-0230", "-03", "-0330", "-0345", "-04", "-0430", "-05", "-0530",
  "-06", "-07", "-08", "-0830", "-09", "-0930", "-10", "-1030", "-1040", "-11", "-1120",
  "-1130", "-12", "ACDT", "ACST", "ADDT", "ADT", "AEDT", "AEST", "AHDT", "AHST",
  "AKDT", "AKST", "AMT", "APT", "AST", "AWDT", "AWST", "AWT", "BDST", "BDT", "BMT",
  "BST", "CAST", "CAT", "CDT", "CEMT", "CEST", "CET", "CMT", "CPT", "CST", "CWT",
  "ChST", "DMT", "EAT", "EDT", "EEST", "EET", "EMT", "EPT", "EST", "EWT", "FFMT",
  "FMT", "GDT", "GMT", "GST", "HDT", "HKST", "HKT", "HKWT", "HMT", "HPT", "HST",
  "HWT", "IDDT", "IDT", "IMT", "IST", "JDT", "JMT", "JST", "KDT", "KMT", "KST", "LMT",
  "LST", "MDST", "MDT", "MMT", "MPT", "MSD", "MSK", "MST", "MWT", "NDDT", "NDT",
  "NPT", "NST", "NWT", "NZDT", "NZMT", "NZST", "PDT", "PKST", "PKT", "PLMT", "PMMT",
  "PMT", "PPMT", "PPT", "PST", "PWT", "QMT", "RMT", "SAST", "SDMT", "SJMT", "SMT",
  "SST", "TBMT", "TMT", "UTC", "WAST", "WAT", "WEMT", "WEST", "WET", "WIB", "WIT",
  "WITA", "WMT", "YDDT", "YDT", "YPT", "YST", "YWT",
]

///|
/// 二分查找 offset 在 tz_offset_table 中的索引，未找到返回 -1。
fn lookup_offset_idx(offset : Int32) -> Int32 {
  let mut lo = 0
  let mut hi = tz_offset_table.length()
  while lo < hi {
    let mid = (lo + hi) / 2
    if tz_offset_table[mid] < offset {
      lo = mid + 1
    } else if tz_offset_table[mid] > offset {
      hi = mid
    } else {
      return mid
    }
  }
  -1
}

///|
/// 线性查找 name 在 tz_name_table 中的索引，未找到返回 -1。
fn lookup_abbr_idx(name : String) -> Int32 {
  for i in 0..<tz_name_table.length() {
    if tz_name_table[i] == name {
      return i
    }
  }
  -1
}

///|
/// 单个时区的预计算过渡表，由 IANA tzdata 离线生成，零运行期解析。
/// rest_compact 每条为 (transitionUtcSec, offsetIdx, abbrIdx)。
pub struct FixedTimespanSet {
  first_offset_idx : Int32
  first_abbr_idx : Int32
  rest_compact : Array[(Int64, Int32, Int32)]
} derive(Eq, Compare, Debug)

///|
pub extend FixedTimespanSet with Eq::{not_equal, equal}

///|
pub extend FixedTimespanSet with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend FixedTimespanSet with Debug::{to_repr}

///|
/// 由压缩索引直接构造（数据文件用，零转换开销）。
pub fn FixedTimespanSet::make(
  first_offset_idx : Int32,
  first_abbr_idx : Int32,
  rest_compact : Array[(Int64, Int32, Int32)],
) -> FixedTimespanSet {
  FixedTimespanSet::{ first_offset_idx, first_abbr_idx, rest_compact, }
}

///|
/// 由最早段与后续段数组构造（兼容 API，内部转换为索引）。
pub fn FixedTimespanSet::from_first_rest(
  first : FixedTimespan,
  rest : Array[(Int64, FixedTimespan)],
) -> FixedTimespanSet {
  let rest_len = rest.length()
  let rest_compact : Array[(Int64, Int32, Int32)] = Array::make(
    rest_len,
    (0L, 0, 0),
  )
  for i in 0..<rest_len {
    let (ts, ft) = rest[i]
    rest_compact[i] = (
      ts,
      lookup_offset_idx(ft.offset),
      lookup_abbr_idx(ft.name),
    )
  }
  FixedTimespanSet::{
    first_offset_idx: lookup_offset_idx(first.offset),
    first_abbr_idx: lookup_abbr_idx(first.name),
    rest_compact,
  }
}

///|
/// 返回段总数（1 + rest_compact.length）。
pub fn FixedTimespanSet::len(self : FixedTimespanSet) -> Int32 {
  1 + self.rest_compact.length()
}

///|
/// 返回第 index 段的 UTC 时间戳区间（左闭右开，无歧义）。
pub fn FixedTimespanSet::utc_span(
  self : FixedTimespanSet,
  index : Int32,
) -> Span {
  let rest = self.rest_compact
  let last_idx = rest.length()
  let begin : Int64? = if index == 0 {
    None
  } else {
    let (ts, _, _) = rest[index - 1]
    Some(ts)
  }
  let end : Int64? = if index == last_idx {
    None
  } else {
    let (ts, _, _) = rest[index]
    Some(ts)
  }
  Span::{ begin, end, }
}

///|
/// 返回第 index 段的本地时间戳区间（左闭右开，可能产生缺口/歧义）。
pub fn FixedTimespanSet::local_span(
  self : FixedTimespanSet,
  index : Int32,
) -> Span {
  let rest = self.rest_compact
  let last_idx = rest.length()
  let begin : Int64? = if index == 0 {
    None
  } else {
    let (ts, off_idx, _) = rest[index - 1]
    Some(ts + tz_offset_table[off_idx].to_int64())
  }
  let end : Int64? = if index == last_idx {
    None
  } else if index == 0 {
    let (ts, _, _) = rest[0]
    Some(ts + tz_offset_table[self.first_offset_idx].to_int64())
  } else {
    let (cur_ts, _, _) = rest[index]
    let (_, prev_off_idx, _) = rest[index - 1]
    Some(cur_ts + tz_offset_table[prev_off_idx].to_int64())
  }
  Span::{ begin, end, }
}

///|
/// 返回第 index 段的 FixedTimespan（查表还原）。
pub fn FixedTimespanSet::get(
  self : FixedTimespanSet,
  index : Int32,
) -> FixedTimespan {
  if index == 0 {
    FixedTimespan::{
      offset: tz_offset_table[self.first_offset_idx],
      name: tz_name_table[self.first_abbr_idx],
    }
  } else {
    let (_, off_idx, abbr_idx) = self.rest_compact[index - 1]
    FixedTimespan::{
      offset: tz_offset_table[off_idx],
      name: tz_name_table[abbr_idx],
    }
  }
}

///|
/// 返回第 index 段的 offset 秒数（直接查表）。
pub fn FixedTimespanSet::offset_at(
  self : FixedTimespanSet,
  index : Int32,
) -> Int32 {
  if index == 0 {
    tz_offset_table[self.first_offset_idx]
  } else {
    let (_, off_idx, _) = self.rest_compact[index - 1]
    tz_offset_table[off_idx]
  }
}

///|
/// 返回第 index 段的缩写名（直接查表）。
pub fn FixedTimespanSet::name_at(
  self : FixedTimespanSet,
  index : Int32,
) -> String {
  if index == 0 {
    tz_name_table[self.first_abbr_idx]
  } else {
    let (_, _, abbr_idx) = self.rest_compact[index - 1]
    tz_name_table[abbr_idx]
  }
}

///|
/// 返回压缩存储的内存估算（字节）。
pub fn FixedTimespanSet::estimated_memory_bytes(
  self : FixedTimespanSet,
) -> Int64 {
  self.rest_compact.length().to_int64() * 16L + 8L
}
