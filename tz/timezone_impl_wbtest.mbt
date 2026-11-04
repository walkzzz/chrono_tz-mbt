///|
/// timezone_impl_wbtest.mbt — TzOffset / LocalResult / binary_search 白盒测试

///|
test "binary_search found" {
  let result = binary_search(0, 5, fn(i) {
    if i < 3 {
      @core.Ordering::Less
    } else if i > 3 {
      @core.Ordering::Greater
    } else {
      @core.Ordering::Equal
    }
  })
  assert_true(result is Ok(3))
}

///|
test "binary_search not found" {
  let result = binary_search(0, 5, fn(i) {
    if i < 3 {
      @core.Ordering::Less
    } else {
      @core.Ordering::Greater
    }
  })
  assert_true(result is Err(3))
}

///|
test "binary_search empty range" {
  let result = binary_search(0, 0, fn(_) { @core.Ordering::Less })
  assert_true(result is Err(0))
}

///|
test "binary_search single element found" {
  let result = binary_search(0, 1, fn(_) { @core.Ordering::Equal })
  assert_true(result is Ok(0))
}

///|
test "binary_search single element not found" {
  let result = binary_search(0, 1, fn(_) { @core.Ordering::Less })
  assert_true(result is Err(1))
}

///|
test "TzOffset basic" {
  let tz = match Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(tz, span)
  assert_eq(off.tz_id(), "UTC")
  assert_eq(off.abbreviation(), "UTC")
  assert_eq(off.offset_sec(), 0)
  assert_eq(off.offset(), "UTC")
  assert_eq(off.to_string(), "UTC")
}

///|
test "TzOffset CET" {
  let tz = match Tz::from_str("Europe/Paris") {
    Some(t) => t
    None => abort("Europe/Paris not found")
  }
  let span = @core.FixedTimespan::{ offset: 3600, name: "CET", }
  let off = TzOffset::make(tz, span)
  assert_eq(off.tz_id(), "Europe/Paris")
  assert_eq(off.abbreviation(), "CET")
  assert_eq(off.offset_sec(), 3600)
}

///|
test "TzOffset Eq" {
  let tz = match Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off1 = TzOffset::make(tz, span)
  let off2 = TzOffset::make(tz, span)
  assert_eq(off1, off2)
}

///|
test "LocalResult::Single" {
  let r : LocalResult[Int64] = LocalResult::Single(42L)
  assert_eq(r.single(), Some(42L))
  assert_eq(r.earliest(), 42L)
  assert_eq(r.latest(), 42L)
  assert_eq(r.unwrap(), 42L)
  assert_true(r.is_single())
  assert_false(r.is_none())
  assert_false(r.is_ambiguous())
}

///|
test "LocalResult::Ambiguous" {
  let r : LocalResult[Int64] = LocalResult::Ambiguous(10L, 20L)
  assert_eq(r.single(), None)
  assert_eq(r.earliest(), 10L)
  assert_eq(r.latest(), 20L)
  assert_false(r.is_single())
  assert_false(r.is_none())
  assert_true(r.is_ambiguous())
}

///|
test "LocalResult::None" {
  let r : LocalResult[Int64] = LocalResult::None
  assert_eq(r.single(), None)
  assert_true(r.is_none())
  assert_false(r.is_single())
  assert_false(r.is_ambiguous())
}

///|
test "LocalResult with TzOffset" {
  let tz = match Tz::from_str("UTC") {
    Some(t) => t
    None => abort("UTC not found")
  }
  let span = @core.FixedTimespan::{ offset: 0, name: "UTC", }
  let off = TzOffset::make(tz, span)
  let single : LocalResult[TzOffset] = LocalResult::Single(off)
  assert_eq(single.earliest().offset_sec(), 0)
  let ambig : LocalResult[TzOffset] = LocalResult::Ambiguous(off, off)
  assert_eq(ambig.earliest().offset_sec(), 0)
  assert_eq(ambig.latest().offset_sec(), 0)
}
