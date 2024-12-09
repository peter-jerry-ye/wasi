pub fn start() -> Unit {
  guard let Ok(len) = @wasi.fd_write?(
    @wasi.Fd(1),
    [b"Hello\n".to_fixedarray(), b"World".to_fixedarray(), b"!\n".to_fixedarray()],
  ) else {
    Ok(_) => ()
    Err(err) => err.value() |> @wasi.proc_exit
  }
  @wasi.fd_write?(@wasi.Fd(1), ["\{len}" |> @wasi.encode_utf8]) |> ignore
}
