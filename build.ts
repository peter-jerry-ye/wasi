const target = "target/wasm-gc/release/build/wasi";
const decoder = new TextDecoder();
const encoder = new TextEncoder();

console.group("Build MoonBit");
let output = await new Deno.Command("moon", {
  args: ["build", "--target", "wasm-gc"],
}).output();
console.log(decoder.decode(output.stdout));
console.groupEnd();

console.group("WASI compliant process");

output = await new Deno.Command("wasm-tools", {
  args: ["print", `${target}.wasm`, "-o", `${target}.wat`],
}).output();
console.log(decoder.decode(output.stdout));

const wat_bytes = await Deno.readFile(`${target}.wat`);
let wat = decoder.decode(wat_bytes);

wat = wat.replace(
  /\(import "spectest" "print_char" (\(func \(;\d+;\) \(type \d+\)\))\)/,
  "$1",
);
wat = wat.replace(/moonbit\.memory/, "memory");

await Deno.writeFile(
  `${target}.wat`,
  encoder.encode(wat),
);

output = await new Deno.Command("wasm-tools", {
  args: ["parse", `${target}.wat`, "-o", `${target}.wasm`],
}).output();
console.log(decoder.decode(output.stdout));

console.groupEnd();