///|
pub fn start() -> Unit {
  let ret = try? @wasi.Fd(1).fd_write([b"Hello\n", b"World", b"!\n"])
  match ret {
    Ok(len) =>
      (try? @wasi.Fd(1).fd_write(["\{len}" |> @encoding.encode(encoding=UTF8)]))
      |> ignore
    Err(err) => err.value() |> @wasi.proc_exit
  }
}
