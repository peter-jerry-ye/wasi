pub fn start() -> Unit {
  let stdin = @wasi.Fd(0)
  let buffer1 = FixedArray::make(64, b'\x00')
  let buffer2 = FixedArray::make(64, b'\x00')
  guard let Ok(len) = stdin.fd_read?([buffer1, buffer2])
  let buffer = FixedArray::make(len._.reinterpret_as_int(), b'\x00')
  if len._ <= 64 {
    buffer1.blit_to(buffer, len=len._.reinterpret_as_int())
    @wasi.Fd(1).fd_write?([buffer]) |> ignore
  } else if len._ <= 128 {
    let buffer = FixedArray::make(len._.reinterpret_as_int(), b'\x00')
    buffer1.blit_to(buffer, len=64)
    buffer2.blit_to(buffer, len=len._.reinterpret_as_int() - 64, dst_offset = 64)
    @wasi.Fd(1).fd_write?([buffer]) |> ignore
  } else {
    @wasi.Fd(1).fd_write?(["Input too long\n" |> @wasi.encode_utf8]) |> ignore
  }
}
