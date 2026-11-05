///|
/// posix_extrapolate.mbt — POSIX TZ footer 外推（超出内置 transition 后的 DST 计算）
/// 引入 caijiewei295/tzif-engine 的 parse_footer + apply_posix_rule 实现外推。
/// 当 UTC 时间戳超出内置 FixedTimespanSet 最后一个 transition 时，
/// 用 IANA tzdata 的 POSIX TZ footer（如 EST5EDT,M3.2.0,M11.1.0）外推未来 DST 规则。

///|
/// 构造 TZif footer 格式的 Bytes：\n<posix>\n（parse_footer 期望的输入格式）。
fn frame_posix_footer(posix_str : String) -> Bytes {
  let arr : Array[Byte] = [b'\n']
  for byte in @utf8.encode(posix_str) {
    arr.push(byte)
  }
  arr.push(b'\n')
  Bytes::from_array(arr)
}

///|
/// 解析 POSIX TZ 字符串为 PosixTzRule，失败返回 None。
fn parse_posix_rule(posix_str : String) -> @types.PosixTzRule? {
  let framed = frame_posix_footer(posix_str)
  match @parser.parse_footer(framed, offset=0, version=b'2') {
    Ok(Some(rule)) => Some(rule)
    _ => None
  }
}

///|
/// 查找时区对应的 POSIX TZ 规则，失败返回 None。
fn get_posix_rule(tz : Tz) -> @types.PosixTzRule? {
  let name = tz.name()
  match @data.lookup_posix_tz(name) {
    Some(posix_str) => parse_posix_rule(posix_str)
    None => None
  }
}

///|
/// 判断 UTC 时间戳是否超出内置 FixedTimespanSet 最后一个 transition。
fn is_beyond_last_transition(span : @core.FixedTimespanSet, ts : Int64) -> Bool {
  let rest = span.rest_compact
  if rest.length() == 0 {
    false
  } else {
    let (last_ts, _, _) = rest[rest.length() - 1]
    ts >= last_ts
  }
}

///|
/// 给定 UTC 瞬时，返回其在本时区的偏移，超出内置 transition 时用 POSIX TZ footer 外推。
/// 主路径：内置 FixedTimespanSet binary_search（覆盖历史 + 当前）。
/// Fallback：当 ts 超出最后 transition 且有 POSIX TZ 规则时，用 apply_posix_rule 外推未来 DST。
pub fn Tz::offset_from_utc_extrapolated(
  self : Tz,
  dt : NaiveDateTime,
) -> TzOffset {
  let ts = dt.timestamp()
  let span = self.timespans()
  if is_beyond_last_transition(span, ts) {
    match get_posix_rule(self) {
      Some(rule) =>
        match @posix.apply_posix_rule(rule, ts) {
          Ok((offset, _is_dst, abbr)) => {
            let ft = @core.FixedTimespan::{ offset, name: abbr, }
            return TzOffset::make(self, ft)
          }
          Err(_) => ()
        }
      None => ()
    }
  }
  let i = binary_search(0, span.len(), fn(n) { span.utc_span(n).cmp(ts) })
  let idx = match i {
    Ok(n) => n
    Err(n) => n
  }
  TzOffset::make(self, span.get(idx))
}

///|
/// 给定本地墙钟，返回 LocalResult[TzOffset]，超出内置 transition 时用 POSIX TZ footer 外推。
pub fn Tz::offset_from_local_extrapolated(
  self : Tz,
  dt : NaiveDateTime,
) -> LocalResult[TzOffset] {
  let ts = dt.timestamp()
  let span = self.timespans()
  if is_beyond_last_transition(span, ts) {
    match get_posix_rule(self) {
      Some(rule) =>
        match @posix.apply_posix_rule(rule, ts) {
          Ok((offset, _is_dst, abbr)) => {
            let ft = @core.FixedTimespan::{ offset, name: abbr, }
            return LocalResult::Single(TzOffset::make(self, ft))
          }
          Err(_) => ()
        }
      None => ()
    }
  }
  let i = binary_search(0, span.len(), fn(n) { span.local_span(n).cmp(ts) })
  match i {
    Ok(0) if span.len() == 1 =>
      LocalResult::Single(TzOffset::make(self, span.get(0)))
    Ok(0) if span.local_span(1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(0)),
        TzOffset::make(self, span.get(1)),
      )
    Ok(0) => LocalResult::Single(TzOffset::make(self, span.get(0)))
    Ok(n) if span.local_span(n - 1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(n - 1)),
        TzOffset::make(self, span.get(n)),
      )
    Ok(n) if n == span.len() - 1 =>
      LocalResult::Single(TzOffset::make(self, span.get(n)))
    Ok(n) if span.local_span(n + 1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(n)),
        TzOffset::make(self, span.get(n + 1)),
      )
    Ok(n) => LocalResult::Single(TzOffset::make(self, span.get(n)))
    Err(_) => LocalResult::None
  }
}
