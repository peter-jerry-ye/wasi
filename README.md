# WASI

WASI Preview 1 implementation for MoonBit (GC ver)

月兔的WASI Preview 1实现

## Usage 使用

需要使用`deno`。利用本项目的`build.ts`与`wasi.ts`来构建你的项目。在安装依赖后从`.mooncakes`中取。

Requires `deno`. Use the `build.ts` and `wasi.ts` that come with this package to build your project. Find them in `.mooncakes` after installed dependencies.

### Build 构建

- `deno run -A build.ts`

### Run 运行

- `deno.run -A wasi.ts`

## Example 使用案例

假设这个包的别名为`@lib`

Assuming the alias of this package is `@lib`

```moonbit
fn init {
  let scanner = @lib.Scanner::make(@lib.stdin)
  let str = scanner.next_line()
  match str {
    Some(s) => @lib.stdout.println(s)
    None => @lib.stdout.println("None")
  }
  @lib.stderr.println("Error")
}
```
