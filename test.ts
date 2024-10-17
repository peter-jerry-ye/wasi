import { assertEquals } from '@std/assert';
import { assertSnapshot } from '@std/testing/snapshot';

const textDecoder = new TextDecoder('utf-8');
const textEncoder = new TextEncoder();

Deno.test("arg_get", async (t) => {
    const output = await new Deno.Command("wasmtime", {
        args: ['--argv0', 'args_get.wasm', 'test/target/wasm/debug/build/args_get/args_get.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("environ_get", async (t) => {
    const output = await new Deno.Command("wasmtime", {
        args: ["--env", "hello=world", 'test/target/wasm/debug/build/environ_get/environ_get.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("fd_fdstat_get", async (t) => {
    const output = await new Deno.Command("wasmtime", {
        args: ['--dir', 'test', 'test/target/wasm/debug/build/fd_fdstat_get/fd_fdstat_get.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("fd_read", async (t) => {
    // Notice that wasmtime may only read into the first buffer.
    let process = new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/fd_read/fd_read.wasm'],
        stdin: 'piped',
        stdout: 'piped',
        stderr: 'piped',
    }).spawn()
    let writer = process.stdin.getWriter()
    await writer.write(textEncoder.encode("hello"))
    await writer.close()
    let output = await process.output()
    assertEquals(output.code, 0);
    let stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);

    process = new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/fd_read/fd_read.wasm'],
        stdin: 'piped',
        stdout: 'piped',
        stderr: 'piped',
    }).spawn()
    writer = process.stdin.getWriter()
    await writer.write(textEncoder.encode("hello, this is a longer sentence, as a quick brown fox jumps over another buffer"))
    await writer.close()
    output = await process.output()
    assertEquals(output.code, 0);
    stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("fd_readdir", async (t) => {
    const output = await new Deno.Command("wasmtime", {
        args: ['--dir', 'test/fd_readdir', 'test/target/wasm/debug/build/fd_readdir/fd_readdir.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("fd_write", async (t) => {
    // Notice that wasmtime may only write from the first buffer.
    const output = await new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/fd_write/fd_write.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})

Deno.test("proc_exit", async () => {
    const output = await new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/proc_exit/proc_exit.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 122);
})