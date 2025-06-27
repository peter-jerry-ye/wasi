pub fn start() -> Unit {
  let (envc, size) = (try? @wasi.environ_sizes_get()).unwrap()
  (try? assert_eq(envc, 1)).unwrap()
  (try? assert_eq(size, 12)).unwrap()
  let args = (try? @wasi.environ_get()).unwrap()
  (try? assert_eq(args, [("hello", "world")])).unwrap()
}
