pub fn start() -> Unit {
  let str = @wasi.stdin.read_all_bytes(1)
  match str {
    Ok(bytes) => {
      @wasi.stdout.println("Hello World") |> ignore
      // @wasi.stdout.write(bytes) |> ignore
    }
    _ => @wasi.stderr.println("Error reading from stdin") |> ignore
  }
}
