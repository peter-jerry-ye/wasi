pub fn start() -> Unit {
  let (argc, size) = (try? @wasi.args_sizes_get()).unwrap()
  (try? assert_eq(argc, 1)).unwrap()
  (try? assert_eq(size, 14)).unwrap()
  let args = (try? @wasi.args_get()).unwrap()
  (try? assert_eq(args, ["args_get.wasm"])).unwrap()
}
