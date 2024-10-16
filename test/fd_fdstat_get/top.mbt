pub fn start() -> Unit {
  let stdout = @wasi.Fd(1)
  let stdout_stat = stdout.fd_fdstat_get?().unwrap()
  stdout.fd_write?(["\{stdout_stat}\n" |> @wasi.encode_utf8]) |> ignore
  let test_dir = @wasi.Fd(3)
  let test_dir_stat = test_dir.fd_fdstat_get?().unwrap()
  stdout.fd_write?(["\{test_dir_stat}\n" |> @wasi.encode_utf8]) |> ignore
}
