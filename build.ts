import binaryen from "binaryen";
import { promises } from "node:fs";
const { writeFile, readFile } = promises;

const wasm = await readFile("target/wasm-gc/release/build/wasi.wasm").then(
  (buffer) => new Uint8Array(buffer),
);

const module = binaryen.readBinary(wasm);
module.setFeatures(binaryen.Features.All);

const funcs = module.getNumFunctions();
const printc = Array.from(Array(funcs).keys()).find((i) => {
  const info = binaryen.getFunctionInfo(module.getFunctionByIndex(i));
  return info.module === "spectest" && info.base === "print_char";
});

if (printc) {
  const name = binaryen.getFunctionInfo(module.getFunctionByIndex(printc)).name;
  module.removeFunction(name);
  module.addFunction(name, binaryen.i32, binaryen.none, [], module.nop());
}

module.removeExport("moonbit.memory");
module.addMemoryExport("0", "memory");

module.optimize();

await writeFile(
  "target/wasm-gc/release/build/wasi.wasm",
  module.emitBinary(),
);
await writeFile(
  "target/wasm-gc/release/build/wasi.wat",
  module.emitText(),
);
