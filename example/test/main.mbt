pub fn start() -> Unit {
  let scanner = @wasi.Scanner::make(@wasi.stdin)
  let str = scanner.next_line()
  match str {
    Some(s) => @wasi.stdout.println(s)
    None => @wasi.stderr.println("None")
  }
}
