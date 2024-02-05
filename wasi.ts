import { promises } from "node:fs";
import { ConsoleStdout, File, OpenFile, WASI } from "@bjorn3/browser_wasi_shim";
const { readFile } = promises;

const wasi = new WASI(
  Deno.args,
  [],
  [
    new OpenFile(new File([])),
    ConsoleStdout.lineBuffered(console.log),
    ConsoleStdout.lineBuffered(console.error),
  ],
);

const wasm = await readFile("target/wasm-gc/release/build/wasi.wasm");
const module = await WebAssembly.compile(wasm);
const instance = await WebAssembly.instantiate(module, {
  "wasi_snapshot_preview1": wasi.wasiImport,
});

wasi.start(
  instance as {
    exports: {
      memory: WebAssembly.Memory;
      _start: () => unknown;
    };
  },
);
