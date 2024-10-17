pub fn start() -> Unit {
  for i = 3; ; i = i + 1 {
    try {
      let fd = @wasi.fd_prestat_dir_name!(i)
      @wasi.Fd(1).fd_write?(
        ["Accessing \{i} got \{fd}\n" |> @wasi.encode_utf8()],
      )
      |> ignore
    } catch {
      errno => {
        @wasi.Fd(1).fd_write?(
          ["Error: Accessing \{i} got \{errno}\n" |> @wasi.encode_utf8()],
        )
        |> ignore
        break
      }
    }
  }
}
