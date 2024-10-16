pub fn start() -> Unit {
  guard let Ok(len) = @wasi.fd_write?(
    @types.Fd(1),
    [b"Hello\n", b"World", b"!\n"],
  ) else {
    Ok(_) => ()
    Err(err) => err.value() |> @wasi.proc_exit
  }
  @wasi.fd_write?(@types.Fd(1), ["\{len}" |> @wasi.encode_utf8]) |> ignore
}
