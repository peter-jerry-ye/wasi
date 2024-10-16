import { assertEquals } from '@std/assert';
import { assertSnapshot } from '@std/testing/snapshot';

const textDecoder = new TextDecoder('utf-8');

Deno.test("arg_get", async (t) => {
    const output = await new Deno.Command("wasmtime", {
        args: ['test/target/wasm/debug/build/args_get/args_get.wasm'],
        stdout: 'piped',
        stderr: 'piped',
    }).spawn().output()
    assertEquals(output.code, 0);
    const stdout = textDecoder.decode(output.stdout)
    await assertSnapshot(t, stdout);
})