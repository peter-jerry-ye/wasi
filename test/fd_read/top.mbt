///|
pub fn start() -> Unit {
  let stdin = @wasi.Fd(0)
  let buffer1 = FixedArray::make(64, b'\x00')
  let buffer2 = FixedArray::make(64, b'\x00')
  guard (try? stdin.fd_read([buffer1, buffer2])) is Ok(len)
  let buffer = FixedArray::make(len.inner().reinterpret_as_int(), b'\x00')
  if len.inner() <= 64 {
    buffer1.blit_to(buffer, len=len.inner().reinterpret_as_int())
    (try? @wasi.Fd(1).fd_write([Bytes::from_fixedarray(buffer)])) |> ignore
  } else if len.inner() <= 128 {
    let buffer = FixedArray::make(len.inner().reinterpret_as_int(), b'\x00')
    buffer1.blit_to(buffer, len=64)
    buffer2.blit_to(
      buffer,
      len=len.inner().reinterpret_as_int() - 64,
      dst_offset=64,
    )
    (try? @wasi.Fd(1).fd_write([Bytes::from_fixedarray(buffer)])) |> ignore
  } else {
    (try? @wasi.Fd(1).fd_write([
      "Input too long\n" |> @encoding.encode(encoding=UTF8),
    ]))
    |> ignore
  }
}
