import {
  ConsoleStdout,
  File,
  OpenFile,
  WASI,
} from "npm:@bjorn3/browser_wasi_shim@0.2.19";

const wasi = new WASI(
  Deno.args,
  [],
  [
    new OpenFile(new File(new TextEncoder().encode(""))),
    ConsoleStdout.lineBuffered(console.log),
    ConsoleStdout.lineBuffered(console.error),
  ],
);

const wasm = await Deno.readFile("./example/test/target/wasm-gc/release/build/wasi-test.wasm");
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
