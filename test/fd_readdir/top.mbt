///|
pub fn start() -> Unit {
  let test_dir = @wasi.Fd(3)
  for cookie = @wasi.DirCookie(0) {
    let test_dir_entries = (try? test_dir.fd_readdir(
      buffer=Bytes::new(100),
      cookie~,
    )).unwrap()
    let entries = test_dir_entries.0.map(fn(name_entry) {
      let (name, entry) = name_entry
      "\{name} ~> \{entry.d_type}"
    })
    (try? @wasi.stdout.fd_write([
      "\{entries}\n" |> @encoding.encode(encoding=UTF8),
    ]))
    |> ignore
    if test_dir_entries.1 {
      continue @wasi.DirCookie(
          cookie.inner() + test_dir_entries.0.length().to_uint64(),
        )
    } else {
      break
    }
  }
}
