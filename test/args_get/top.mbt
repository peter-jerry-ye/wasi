pub fn start() -> Unit {
  let (argc, size) = @wasi.args_sizes_get?().unwrap()
  assert_eq?(argc, 1).unwrap()
  assert_eq?(size, 14).unwrap()
  let args = @wasi.args_get?().unwrap()
  assert_eq?(args, ["args_get.wasm"]).unwrap()
}
