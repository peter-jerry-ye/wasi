pub fn start() -> Unit {
  let (envc, size) = @wasi.environ_sizes_get?().unwrap()
  assert_eq?(envc, 1).unwrap()
  assert_eq?(size, 12).unwrap()
  let args = @wasi.environ_get?().unwrap()
  assert_eq?(args, [("hello", "world")]).unwrap()
}
