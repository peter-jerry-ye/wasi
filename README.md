# WASI

WASI binding for MoonBit (GC ver)

## Usage

Requires `deno`.

Use the `build.ts` and `wasi.ts` that come with this package to build your project.

### Build

- `deno run -A build.ts`

### Run

- `deno.run -A wasi.ts`

## Example

Assuming the alias of this package is @lib

```moonbit
fn init {
  let scanner = @lib.Scanner::make(@lib.stdin)
  let str = scanner.next_line(Pos(0))
  match str {
    Some(s) => @lib.stdout.println(s, Pos(0))
    None => @lib.stdout.println("None", Pos(0))
  }
  @lib.stderr.println("Error", Pos(0))
}
```
