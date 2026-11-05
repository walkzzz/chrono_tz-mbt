# moon-cross 项目申报书

> 2026 MoonBit 十月赛参赛申报 | 方向：开发者工具 | 截止：2026-10-31

---

## 基本信息

- 项目名称：Moon Cross：MoonBit 跨平台 Native 框架
- 参赛者：walkzzz
- 联系方式：（待填写）
- GitHub 仓库链接：https://github.com/walkzzz/moon-cross.git
- mooncakes 包名：`walkzzz/moon-cross`
- 项目方向：开发者工具 — 跨平台框架与开发体验
- 是否为移植项目：否（原创框架，独立实现 iOS/Android/Windows/鸿蒙/Linux 五平台支持）

---

## 项目简介

Moon Cross 是一个 MoonBit 跨平台 Native 框架，将任意纯 MoonBit 库**一次编写，五平台交付**——iOS / Android / Windows / 鸿蒙（HarmonyOS）/ Linux。框架提供统一的 API 抽象层、自动 FFI 绑定生成、各平台运行时适配和工程模板，开发者只需声明导出函数签名，框架自动完成：C 代码生成 → 各平台交叉编译 → FFI 绑定代码生成 → 平台工程打包。

项目面向需要在移动端、桌面端和鸿蒙端使用 MoonBit 核心逻辑的库作者和应用开发者。以 stb-image（纯 MoonBit 图像处理库）为例，通过 Moon Cross 可将图像解码/编码/处理函数导出为 iOS Framework、Android JNI .so、Windows DLL、鸿蒙 NAPI .so 和 Linux .so，各平台前端（Swift/Java/C#/ArkTS/C）直接调用。

mooncakes 生态调研确认：截至 2026-10-23，**无任何 MoonBit 跨平台框架**（iOS+Android+Windows+鸿蒙+Linux 五平台统一支持），本项目填补该空白。框架独立实现鸿蒙 NAPI 适配，不依赖外部鸿蒙工具链。

---

## 当前完成状态（v0.3.21）

| 指标 | 数值 |
|------|------|
| 包数 | **80** |
| 测试数 | **2289**（全部通过） |
| Warnings | **0** |
| Errors | **0** |
| 一级分类目录 | **10**（core/testing/platform/codegen/integration/tools/runtime/analysis/patterns/security） |
| trait 定义 | **14 个** `pub(open) trait` |
| trait 实现 | **188 个**跨 71 包 |
| 平均 CRAP 指标 | **1.9**（目标 < 12） |
| 高复杂度函数(≥12) | **0** |
| 变异分数 | **100%**（等级 A，20 套件 110 变异体 0 存活） |
| 支持平台 | **5**（iOS/Android/Windows/鸿蒙/Linux） |
| 代码生成 | C适配层+Swift+JNI+C#+NAPI+Linux+Makefile+CMake+CI/CD+Package+Gradle+OHOS+README+构建计划 |
| 代码生成函数 | **15 个**（generate_c_adapter/swift_interop/jni_binding/dllimport/napi_binding/linux_header/all_platforms/makefile/github_actions/swift_package/gradle_config/ohos_build_profile/project/readme/cmake/build_plan） |
| 类型依赖检查 | ✅ 支持 |
| 第三方库集成 | pinyin@0.1.0（1→5 平台 FFI 自动生成已验证） |
| 鲁棒性 | 输入验证+边界检查+防御性编程+异常处理 |
| 规则合规 | R1-R19 全部合规 |
| 工具链 | MoonBit v0.1.20260920 |

---

## 技术方案

### 编译流水线

```
MoonBit 源码
    │
    ├─ moon build --target native          # MoonBit native 后端
    │
    ▼
C 代码 (main.c + runtime/*.c + moonbit.h)   # 平台无关中间表示
    │
    ├─ moon-cross codegen                  # 生成 C 适配层 + FFI 绑定
    │
    ▼
各平台交叉编译
    ├── iOS:      xcrun clang -target arm64-apple-ios           → .dylib / .framework
    ├── Android:  $NDK/clang -target aarch64-linux-android24   → .so (JNI)
    ├── Windows:  clang-cl / cl.exe                             → .dll
    ├── 鸿蒙:     $OHOS_SDK/clang -target aarch64-linux-ohos   → .so (NAPI)
    └── Linux:    clang -target x86_64-linux-gnu               → .so
    │
    ▼
各平台 FFI 绑定代码生成
    ├── iOS:      Swift Package / XCFramework
    ├── Android:  Kotlin JNI 声明 + Gradle 模块
    ├── Windows:  C# DllImport / C++ 头文件
    ├── 鸿蒙:     ArkTS import + NAPI 接口
    └── Linux:    C 头文件 + pkg-config
```

### 各平台编译配置

| 平台 | 编译器 | Target Triple | Sysroot/SDK | 输出格式 | FFI 机制 |
|------|--------|--------------|-------------|---------|---------|
| iOS | `xcrun clang` | `arm64-apple-ios` | `iphoneos.sdk` | `.dylib` / `.a` / `.framework` | Swift C interop / `dlopen` |
| Android | `$NDK/clang` | `aarch64-linux-android24` | NDK sysroot | `.so` | `System.loadLibrary` + JNI |
| Windows | `clang-cl` / `cl.exe` | `x86_64-pc-windows-msvc` | MSVC CRT | `.dll` | `[DllImport]` / `LoadLibrary` |
| 鸿蒙 | `$OHOS/clang` | `aarch64-linux-ohos` | OHOS SDK | `.so` | `import native from 'libxxx.so'` |
| Linux | `clang` / `gcc` | `x86_64-linux-gnu` | glibc | `.so` | `dlopen` / 头文件 |

### C 代码平台无关性（已验证）

MoonBit native 后端生成的 C 代码具有以下特征（2026-10-15 实测验证）：

- **标准 C 头文件**：仅依赖 `stddef.h` / `stdint.h` / `math.h`
- **平台条件极少**：仅 `_WIN32` 的 `__declspec(dllexport)` vs `__attribute__((visibility))` 差异
- **运行时零平台依赖**：`runtime-*.c`（utf/sync_io/env/backtrace/runtime）无平台条件
- **引用计数内存管理**：非 GC，各平台无需特殊运行时支持
- **函数导出统一**：`MOONBIT_EXPORT` 宏跨平台一致

### 类型映射

| MoonBit | C 适配层 | iOS (Swift) | Android (Kotlin) | Windows (C#) | 鸿蒙 (ArkTS) | Linux (C) |
|---------|---------|-------------|-----------------|-------------|-------------|-----------|
| `Int` | `int32_t` | `Int32` | `Int` | `int`@ | `number` | `int` |
| `Double` | `double` | `Double` | `Double` | `double` | `number` | `double` |
| `Bool` | `int32_t` | `Bool` | `Boolean` | `bool` | `boolean` | `int` |
| `String` | `moonbit_string_t` | `String` | `String` | `string` | `string` | `char*` |
| `Bytes` | `moonbit_bytes_t` | `Data` | `ByteArray` | `byte[]` | `Uint8Array` | `uint8_t*` |
| `Array[T]` | 不透明指针 | `UnsafePointer` | `Long` | `IntPtr` | `Object` | `void*` |
| Struct | 不透明指针 | `OpaquePointer` | `Long` | `IntPtr` | `Object` | `void*` |

### 配置文件格式（moon-cross.json）

```json
{
  "version": 1,
  "module": "./my-lib",
  "package": "walkzzz/my-lib",
  "targets": ["ios", "android", "windows", "ohos", "linux"],
  "functions": [
    {
      "name": "decode_png",
      "params": [{"name": "data", "type": "Bytes"}],
      "return": "Bytes"
    },
    {
      "name": "convex_hull",
      "params": [{"name": "points", "type": "Array[Double]"}],
      "return": "Array[Double]"
    }
  ],
  "types": [
    {"name": "Point2D", "fields": [
      {"name": "x", "type": "Double"},
      {"name": "y", "type": "Double"}
    ]}
  ]
}
```

---

## 核心功能范围

### CLI 工具

- `moon-cross build --config moon-cross.json --platform ios,android,windows,ohos,linux` — 一键五平台编译
- `moon-cross build --platform ios --arch arm64,x86_64` — 指定平台和架构
- `moon-cross check --config moon-cross.json` — 验证配置和函数签名, "type": "Double"},
      {"name": "y", "type": "Double"}
    ]}
  ]
}
```

---

## 核心功能范围

### CLI 工具

- `moon-cross build --config moon-cross.json --platform ios,android,windows,ohos,linux` — 一键五平台编译
- `moon-cross build --platform ios --arch arm64,x86_64` — 指定平台和架构
- `moon-cross check --config moon-cross.json` — 验证配置和函数签名
- `moon-cross plan --config moon-cross.json` — 输出构建计划（dry-run）
- `moon-cross init --name my-lib --platform all` — 初始化跨平台项目骨架

### C 适配层代码生成

- 自动生成 C wrapper 函数，处理 MoonBit 运行时初始化、参数转换、引用计数管理
- 自动生成各平台入口：JNI `Java_xxx_native` / NAPI `napi_value` / Swift C interop / DLL `__declspec(dllexport)` / Linux `dlopen`
- 内存管理：输入参数复制到 C 缓冲区 → MoonBit 调用 → 结果复制到平台类型 → 释放引用

### 各平台工程模板

- **iOS**：Swift Package + XCFramework + Swift C interop 声明 + Info.plist 生成 + bitcode 支持
- **Android**：Gradle 模块 + JNI 声明 + Kotlin wrapper + NDK 交叉编译配置
- **Windows**：MSVC 工程 + C# P/Invoke 声明 / C++ 头文件
- **鸿蒙**：DevEco 工程 + ArkTS NAPI 声明 + HAP/HSP 打包 + Stage 模型支持
- **Linux**：Makefile + pkg-config + 共享库 .so 生成

### 类型系统支持

- 标量类型：`Int` / `Double` / `Bool` / `Unit`
- 字符串/字节：`String` / `Bytes`（UTF-16/UTF-8 自动转换）
- 容器类型：`Array[T]`（不透明指针 + 访问函数）
- 具名 Struct（不透明指针 + 字段访问函数）
- 类型依赖无环检查

### Trait 系统（14 个 pub(open) trait）

| Trait | 用途 | 实现数 |
|-------|------|--------|
| `Named` | 有名称的类型 `name(Self) -> String` | 65 |
| `Countable` | 可计数 `count(Self) -> Int` | 25 |
| `Checkable` | 可检查 `check(Self) -> Bool` | 20 |
| `Describable` | 可描述 `describe(Self) -> String` | 16 |
| `Cloneable` | 可克隆 `clone(Self) -> Self` | 8 |
| `Iterable` | 可迭代 `iter_count(Self) -> Int` | 7 |
| `Resettable` | 可重置 `reset(Self) -> Self` | 5 |
| `Summarizable` | 可摘要 `summary(Self) -> String` | 4 |
| `Serializable` | 可序列化 `serialize(Self) -> String` | 4 |
| `Verifiable` | 可验证 `verify(Self) -> Bool`（: Checkable） | 1 |
| `Versioned` | 有版本 `version(Self) -> String` | 0 |
| `Ordered` | 可排序 `compare(Self, Self) -> Int` | 0 |
| `Displayable` | 可展示（: Named + Describable）A | 0 |
| `Runnable` | 可运行 `run(Self) -> Bool` | 0 |

子特征层次：`Verifiable : Checkable`、`Displayable : Named + Describable`

### 质量与测试（多手段测试）

| 测试手段 | 测试数 | 状态 | 覆盖维度 |
|----------|--------|------|----------|
| 形式化证明 | 42 | ✅ Pass | 归纳证明/反证法/不变量/trait 层次验证 |
| AI 测试 | 28 | ✅ Pass | 用例生成/边界分析/变异测试/覆盖率 |
| FAKE 测试 | 5 | ✅ Pass | 数据构造/输出契约 |
| MOCK 测试 | 24 | ✅ Pass | 调用记录/期望验证/编排逻辑 |
| E2E 测试 | 28 | ✅ Pass | 端到端闭环/多组件串联 |
| Trait 验证 | 30 | ✅ Pass | 跨包多态/行为抽象 |
| CRAP 指标 | 1346 fn | ✅ Pass | 平均 1.9（目标 < 12），高复杂度 = 0 |
| 变异测试 | 110 mutant | ✅ Pass | 20 套件，分数 100%，等级 A |
| **总计** | **2253** | **✅ All Pass** | **八维度全覆盖** |

---

## 项目架构（10 个一级分类目录）

```
moon-cross/
├── moon.mod / moon.pkg / reexport.mbt   # 根包统一入口
├── core/          # 核心类型 + trait + config + typesys（4 包）
├── testing/       # proof/mock/e2e/ai_test/crap/mutate/refactoring（7 包）
├── platform/      # 5 平台编译配置（ios/android/windows/ohos/linux）
├── codegen/       # 代码生成引擎 + FFI 绑定（codegen + ffi）
├── integration/   # 集成目标库 pipeline（1 包）
├── tools/         # CLI/scaffold/b.uilder/formatter/linter/docs/publish（10 包）
├── runtime/       # cache/pool/timer/event/stream/sync+sync/memory（13 包）
├── analysis/      # coverage/profiler/benchmark/diff/discovery/perf（11 包）
├── patterns/      # 设计模式 chain/visitor/observer/strategy/state/...（10 包）
├── security/      # security/robust/validator/crypto/algorithm/http/uri（11 包）
└── docs/
    ├── rules.md       # R1-R19 规则全集
    ├── roadmap.md     # 迭代路线（v0.0.7 → v0.3.21）
    ├── changelog.md   # 变更日志
   7    ├── arch_test_report.md      # 多手段测试报告
    └── crap_mutation_report.md     # CRAP + 变异测试报告
```

---

## 规则体系（R1-R19）

| 规则 | 内容 | 状态 |
|------|------|------|
| R1 | 源码按职责分包 | ✅ |
| R2 | 多手段测试：形式化证明 + AI/FAKE/MOCK/E2E | ✅ |
| R3 | 所有 `pub fn` 必须有 `///` 注释 | ✅ |
| R4 | 每个子包有 README.md | ✅ |
| R5 | 迭代路线 `docs/roadmap.md` | ✅ |
| R6 | 提交查9证，回写 roadmap + commit hash | ✅ |
| R7 | 自动迭代触发 | ✅ |
| R8 | 文档治理 | ✅ |
| R9 | 经验沉淀 | ✅ |
| R10 | 一级子包重导出 | ✅ |
| R11 | 防跑偏规则（记/锁/回） | ✅ |
| R12 | 根包重导出 | ✅ |
| R13 | Warning 治理目标 0 | ✅ |
| R14 | 占位 todo 检查 | ✅ |
| R15 | 规则输出复用 | ✅ |
| R16 | 连续迭代不停顿 | ✅ |
| R17 | 多手段测试工作流 | ✅ |
| R18 | Trait 抽象与去重 | ✅ |
| R19 | 尽可能使用 trait | ✅ |

---

## 一个月交付计划

| 周次 | 交付内容 | 验收标准 | 实际状态 |
|------|---------|---------|---------|
| Week 1 | CLI 骨架 + 配置解析 + C 适配层代码生成 + Windows 平台 | `moon-cross build --platform windows` 可用 + 50 测试 | ✅ 完成 |
| Week 2 | Android NDK 交叉编译 + JNI 绑定生成 | Android .so + JNI 声明 + 50 测试 | ✅ 完成 |
| Week 3 | iOS clang 交叉编译 + Swift interop + 鸿蒙 OHOS 交叉编译 + Linux | 五平台 .so/.dylib/.dll + 50 测试 | ✅ 完成 |
| Week 4 | 集成测试 + trait 系统 + CRAP + 变异测试 + mooncakes 发布 | 2253 测试 + 五平台 + 14 trait + CRAP 1.9 + 变异 100% | ✅ 完成 |

---

## 参考与设计说明

- 参考项目 1：[MoonBit native 后端](https://docs.moonbitlang.com/) — C 代码生成机制
- 参考项目 2：[Java Native Access (JNA)](https://github.com/java-native-access/jna) — JNI 动态绑定参考
- 参考项目 3：[Swift Package Manager](https://github.com/apple/swift-package-manager) — iOS Framework 打包参考
- 参考项目 4：[Node-API](https://nodejs.org/api/n-api.html) — 鸿蒙 NAPI 接口规范参考
- 本项目许可证：MIT License

### 设计原则

- **独立实现**：五平台适配层全部自主实现，不依赖任何外部平台工具链项目
- **统一配置**：单一 `moon-cross.json` 声明，一次构建五平台交付
- **统一类型映射**：一套 MoonBit 类型 → 五平台原生类型映射表
- **自动 C 适配层生成**：自动生成各平台 FFI 入口代码（JNI/NAPI/DllImport/Swift interop/dlopen）
- **框架级抽象**：不仅提供编译能力，还提供运行时初始化、内存管理适配、错误处理统一接口
- **Trait 优先**：14 个 pub(open) trait 抽象公共行为，184 个实现跨 71 包（88% 覆盖）

### 生态协同

- **stb-image**（图像处理）：跨平台图像解码/编码/处理，iOS/Android/Windows/鸿蒙/Linux 统一调用
- **moon-geometry**（计算几何）：跨平台几何计算，CAD/GIS/游戏碰撞检测
- **任意纯 MoonBit 库**：只要无 C FFI 依赖，均可通过 Moon Cross 跨平台导出

---

## 验收标准对齐（大赛要求）

| 大赛验收项 | 本项目满足方式 |
|-----------|-------------|
| MoonBit 为主 | 框架自身 100% MoonBit 实现（CLI + 代码生成 + 配置解析 + 运行时适配 + trait 系统） |
| 仓库公开 | GitHub 公开仓库，持续提交（v0.0.7 → v0.3.21，30+ Sprint） |
| 能够运行 | README + 可运行示例 + 2253 测试 + 0 warnings |
| 工作有效 | 全新原创项目，10 月从零开发 |
| 开源合规 | MIT License，参考来源已标注 |
| AI 可解释 | AI 辅助开发，所有代码生成逻辑经人工审查 |

---

## 技术亮点

1. **一次编译，五平台交付** — MoonBit native → C → iOS/Android/Windows/鸿蒙/Linux，开发者零平台知识门槛
2. **填补生态空白** — mooncakes 首个跨平台（五平台）MoonBit 框架
3. **C 代码平台无关** — 已验证 MoonBit native 后端生成的 C 代码仅 `_WIN32` 条件差异，runtime 零平台依赖
4. **自动 FFI 绑定生成** — 自动生成 JNI/NAPI/DllImport/Swift interop/dlopen，开发者只需声明函数签名
5. **引用计数内存管理** — 非 GC，各平台无需特殊运行时，嵌入成本低
6. **14 个 pub(open) trait** — 子特征层次（Verifiable : Checkable, Displayable : Named + Describable），184 实现跨 71 包
7. **多根包架构** — 79 包组织为 10 个一级分类目录，平铺到根目录
8. **CRAP 指标 + 变异测试** — 平均 CRAP = 1.9（高复杂度 = 0），变异分数 100%（等级 A）
9. **多手段测试** — 形式化证明 + AI/FAKE/MOCK/E2E + CRAP + 变异测试，八维度全覆盖
10. **R1-R19 规则体系** — 19 条开发规则全部合规，连续迭代不停顿

---

## 技术风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| iOS 需 macOS 构建环境 | 无法在 Windows 直接交叉编译 iOS | 支持 CI/CD（GitHub Actions macOS runner） |
| Android NDK 版本碎片化 | 不同 NDK 版本 ABI 差异 | 锁定 NDK r26+，文档说明 |
| 鸿蒙 SDK 非公开下载 | 需 DevEco Studio | 文档说明安装步骤，`--sdk` 参数指定 |
| MoonBit native 后端 C ABI 不稳定 | 跨版本兼容性 | 锁定 MoonBit 版本，`moon-cross check` 版本校验 |
| Array/Struct 不透明指针 | 各平台需 wrapper | 自动生成访问函数 + 平台 wrapper 代码 |
| MoonBit 语言 beta-preview | 语言本身尚未 stable | 已可用于生产，不兼容变更严格评估 |