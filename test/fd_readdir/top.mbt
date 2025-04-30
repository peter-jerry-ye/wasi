///|
pub fn start() -> Unit {
  let test_dir = @wasi.Fd(3)
  for cookie = @wasi.DirCookie(0) {
    let test_dir_entries = test_dir
      .fd_readdir?(buffer=Bytes::new(100), cookie~)
      .unwrap()
    let entries = test_dir_entries.0.map(fn {
      (name, entry) => "\{name} ~> \{entry.d_type}"
    })
    @wasi.stdout.fd_write?(["\{entries}\n" |> @wasi.encode_utf8]) |> ignore
    if test_dir_entries.1 {
      continue @wasi.DirCookie(
          cookie._ + test_dir_entries.0.length().to_uint64(),
        )
    } else {
      break
    }
  }
}
