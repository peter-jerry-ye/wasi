///|
pub fn start() -> Unit {
  let stdout = @wasi.Fd(1)
  let stdout_stat = (try? stdout.fd_fdstat_get()).unwrap()
  (try? stdout.fd_write(["\{stdout_stat}\n" |> @encoding.encode(encoding=UTF8)]))
  |> ignore
  let test_dir = @wasi.Fd(3)
  let test_dir_stat = (try? test_dir.fd_fdstat_get()).unwrap()
  (try? stdout.fd_write([
    "\{test_dir_stat}\n" |> @encoding.encode(encoding=UTF8),
  ]))
  |> ignore
}
