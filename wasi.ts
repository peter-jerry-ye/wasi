import Context from "https://deno.land/std@0.206.0/wasi/snapshot_preview1.ts";

const context = new Context({
  args: Deno.args,
  env: Deno.env.toObject(),
  preopens: { ".": "." },
});

await WebAssembly.instantiateStreaming(
  fetch(
    new URL("./target/wasm-gc/release/build/wasi.wasm", import.meta.url),
  ),
  {
    "wasi_snapshot_preview1": context.exports,
  },
).then((obj) => {
  try {
    context.start(obj.instance);
  } catch (e) {
    console.error(e);
  } finally {
    // const memory = obj.instance.exports["memory"] as WebAssembly.Memory;
    // console.log(new Uint8Array(memory.buffer, 0, 100));
    // console.log(new Uint8Array(memory.buffer, 1020, 100));
  }
});
