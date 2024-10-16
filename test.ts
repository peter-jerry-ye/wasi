import { assertEquals } from '@std/assert';
import { assertSnapshot } from '@std/testing/snapshot';

const textDecoder = new TextDecoder('utf-8');

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

Deno.test("fd_write", async (t) => {
    // Notice that wasmtime may not write everything required in the buffer.
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
    // Notice that wasmtime may not write everything required in the buffer.
    const output = await new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/proc_exit/proc_exit.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 122);
})