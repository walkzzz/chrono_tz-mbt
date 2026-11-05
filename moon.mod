// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "walkzzz/chrono_tz-mbt"

version = "0.1.2"

readme = "README.mbt.md"

repository = "https://github.com/walkzzz/chrono_tz-mbt.git"

license = "Apache-2.0"

keywords = [
  "timezone",
  "iana",
  "tzdata",
  "dst",
  "rfc3339",
  "strftime",
  "hinnant",
  "chrono",
]

preferred_target = "wasm"

supported_targets = "+wasm+wasm-gc+js+native"

description = "MoonBit IANA 时区库 — 597 时区 + DST 三分支 + Hinnant civil↔days + RFC3339 + strftime/strptime，移植自 Rust chrono-tz 0.11.0"

import {
  "moonbitlang/async@0.22.5",
  "moonbit-community/tty@0.6.2",
}
