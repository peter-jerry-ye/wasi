pub fn start() -> Unit {
  let stdin = @wasi.Fd(0)
  let buffer1 = Bytes::new(64)
  let buffer2 = Bytes::new(64)
  guard let Ok(len) = stdin.fd_read?([buffer1, buffer2])
  let buffer = Bytes::new(len._.reinterpret_as_int())
  if len._ <= 64 {
    buffer.blit(0, buffer1, 0, len._.reinterpret_as_int())
    @wasi.Fd(1).fd_write?([buffer]) |> ignore
  } else if len._ <= 128 {
    let buffer = Bytes::new(len._.reinterpret_as_int())
    buffer.blit(0, buffer1, 0, 64)
    buffer.blit(64, buffer2, 0, len._.reinterpret_as_int() - 64)
    @wasi.Fd(1).fd_write?([buffer]) |> ignore
  } else {
    @wasi.Fd(1).fd_write?(["Input too long\n" |> @wasi.encode_utf8]) |> ignore
  }
}
