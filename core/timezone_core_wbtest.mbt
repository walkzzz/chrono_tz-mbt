///|
/// Hinnant civil↔days 已知值测试
test "days_from_civil 1970-01-01 -> 0" {
  assert_eq(days_from_civil(1970L, 1L, 1L), 0L)
}

///|
test "days_from_civil 2000-01-01 -> 10957" {
  assert_eq(days_from_civil(2000L, 1L, 1L), 10957L)
}

///|
test "civil_from_days 0 -> 1970-01-01" {
  assert_eq(civil_from_days(0L), (1970L, 1L, 1L))
}

///|
test "civil_from_days 10957 -> 2000-01-01" {
  assert_eq(civil_from_days(10957L), (2000L, 1L, 1L))
}

///|
/// 往返测试：civil_from_days ∘ days_from_civil = id
test "roundtrip days_from_civil civil_from_days" {
  let cases = [
    (1970L, 1L, 1L),
    (2000L, 1L, 1L),
    (2026L, 11L, 4L),
    (1900L, 3L, 15L),
    (1800L, 6L, 30L),
    (2100L, 12L, 31L),
    (1L, 1L, 1L),
  ]
  for (y, m, d) in cases {
    let days = days_from_civil(y, m, d)
    assert_eq(civil_from_days(days), (y, m, d))
  }
}

///|
/// 负 days（公元前）正确性
test "negative days BCE" {
  // -1L 是 1969-12-31
  assert_eq(civil_from_days(-1L), (1969L, 12L, 31L))
  // 1970-01-01 前一天
  assert_eq(days_from_civil(1969L, 12L, 31L), -1L)
}

///|
/// Span::cmp 测试
test "Span::cmp boundaries" {
  // [Some, Some] 区间内
  let s1 = Span::{ begin: Some(100L), end: Some(200L), }
  assert_eq(Span::cmp(s1, 150L), Ordering::Equal)
  // [Some, Some] 早于
  assert_eq(Span::cmp(s1, 50L), Ordering::Greater)
  // [Some, Some] 晚于
  assert_eq(Span::cmp(s1, 250L), Ordering::Less)
  // [Some, None] 区间内
  let s2 = Span::{ begin: Some(100L), end: None, }
  assert_eq(Span::cmp(s2, 150L), Ordering::Equal)
  // [Some, None] 早于
  assert_eq(Span::cmp(s2, 50L), Ordering::Greater)
  // [None, Some] 晚于
  let s3 = Span::{ begin: None, end: Some(200L), }
  assert_eq(Span::cmp(s3, 250L), Ordering::Less)
  // [None, Some] 区间内
  assert_eq(Span::cmp(s3, 150L), Ordering::Equal)
  // [None, None] 总是 Equal
  let s4 = Span::{ begin: None, end: None, }
  assert_eq(Span::cmp(s4, 999L), Ordering::Equal)
}

///|
/// Span::contains 测试
test "Span::contains boundaries" {
  let s1 = Span::{ begin: Some(100L), end: Some(200L), }
  assert_true(Span::contains(s1, 100L))
  assert_true(Span::contains(s1, 199L))
  assert_false(Span::contains(s1, 200L))
  assert_false(Span::contains(s1, 99L))
  let s2 = Span::{ begin: Some(100L), end: None, }
  assert_true(Span::contains(s2, 100L))
  assert_true(Span::contains(s2, 999L))
  assert_false(Span::contains(s2, 99L))
  let s3 = Span::{ begin: None, end: Some(200L), }
  assert_true(Span::contains(s3, 199L))
  assert_false(Span::contains(s3, 200L))
  let s4 = Span::{ begin: None, end: None, }
  assert_true(Span::contains(s4, 999L))
}

///|
/// FixedTimespan 构造与字段访问
test "FixedTimespan construction" {
  let ft = FixedTimespan::{ offset: 3600, name: "CET", }
  assert_eq(ft.offset, 3600)
  assert_eq(ft.name, "CET")
}

///|
/// FixedTimespanSet 基本测试
test "FixedTimespanSet basic" {
  // 构造一个简单时区：UTC offset 0，name "UTC"，无过渡
  let fts = FixedTimespanSet::make(
    lookup_offset_idx_for_test(0),
    lookup_abbr_idx_for_test("UTC"),
    [],
  )
  assert_eq(FixedTimespanSet::len(fts), 1)
  assert_eq(FixedTimespanSet::offset_at(fts, 0), 0)
  assert_eq(FixedTimespanSet::name_at(fts, 0), "UTC")
  let ft = FixedTimespanSet::get(fts, 0)
  assert_eq(ft.offset, 0)
  assert_eq(ft.name, "UTC")
}

///|
/// FixedTimespanSet utc_span/local_span 测试
test "FixedTimespanSet spans" {
  // 构造一个有 2 段的时区：先 UTC+0，后在 ts=1000000 切到 UTC+3600
  let fts = FixedTimespanSet::make(
    lookup_offset_idx_for_test(0),
    lookup_abbr_idx_for_test("UTC"),
    [
      (
        1000000L,
        lookup_offset_idx_for_test(3600),
        lookup_abbr_idx_for_test("CET"),
      ),
    ],
  )
  assert_eq(FixedTimespanSet::len(fts), 2)
  // 第 0 段 UTC span: [None, 1000000)
  let span0 = FixedTimespanSet::utc_span(fts, 0)
  assert_true(span0.begin is None)
  assert_true(span0.end is Some(1000000L))
  // 第 1 段 UTC span: [1000000, None)
  let span1 = FixedTimespanSet::utc_span(fts, 1)
  assert_true(span1.begin is Some(1000000L))
  assert_true(span1.end is None)
  // 第 0 段 local span: [None, 1000000+0)
  let lspan0 = FixedTimespanSet::local_span(fts, 0)
  assert_true(lspan0.begin is None)
  assert_true(lspan0.end is Some(1000000L))
  // 第 1 段 local span: [1000000+3600, None) — 过渡点用新段 offset
  let lspan1 = FixedTimespanSet::local_span(fts, 1)
  assert_true(lspan1.begin is Some(1003600L))
  assert_true(lspan1.end is None)
}

///|
/// 测试辅助：查 offset 索引（包内可见）
fn lookup_offset_idx_for_test(offset : Int32) -> Int32 {
  lookup_offset_idx(offset)
}

///|
/// 测试辅助：查 abbr 索引（包内可见）
fn lookup_abbr_idx_for_test(name : String) -> Int32 {
  lookup_abbr_idx(name)
}
