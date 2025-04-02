///|
pub fn start() -> Unit {
  let ret = @wasi.fd_write?(@wasi.Fd(1), [
    b"Hello\n".to_fixedarray(),
    b"World".to_fixedarray(),
    b"!\n".to_fixedarray(),
  ])
  match ret {
    Ok(len) =>
      @wasi.fd_write?(@wasi.Fd(1), ["\{len}" |> @wasi.encode_utf8]) |> ignore
    Err(err) => err.value() |> @wasi.proc_exit
  }
}
