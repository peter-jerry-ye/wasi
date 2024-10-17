pub fn start() -> Unit {
  let test_dir = @wasi.Fd(3)
  let test_dir_entries = test_dir.fd_readdir?().unwrap()
  @wasi.Fd(1).fd_write?(["\{test_dir_entries}\n" |> @wasi.encode_utf8])
  |> ignore
}
