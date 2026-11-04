# 构建与 CI 方案 / Build & CI

> moon check / test / fmt / info / coverage 的具体命令与 CI 集成方案。
> 对应 ADR-010 多后端目标。

## 一、MoonBit 工具链命令

### 基础命令

| 命令 | 作用 | 使用场景 |
|------|------|---------|
| `moon check` | 类型检查 + 编译（不运行） | 每次修改后 |
| `moon check --target all` | 四后端检查（wasm/wasm-gc/js/native） | CI / 发布前 |
| `moon test` | 运行所有测试（黑盒+白盒+文档测试） | 每次修改后 |
| `moon test --target all` | 四后端测试 | CI |
| `moon test --update` | 更新快照测试 | 输出变化时 |
| `moon test --bench` | 运行基准测试 | 性能验收 |
| `moon fmt` | 格式化代码 | 提交前 |
| `moon info` | 更新 `.mbti` 接口文件 | API 变更后 |
| `moon coverage analyze` | 覆盖率分析 | 测试验收 |
| `moon build --target wasm` | 构建 wasm 产物 | 发布/体积检查 |
| `moon ide` | IDE 辅助（peek-def/outline/find-references） | 开发时 |

### 典型工作流

```bash
# 开发循环
moon check && moon test

# 提交前
moon fmt && moon check && moon test && moon info

# CI 完整
moon fmt --check && moon check --target all && moon test --target all && moon info --check
```

## 二、项目配置

### moon.mod

```toml
[module]
name = "walkzzz/chrono_tz-mbt"
version = "0.1.0"
description = "IANA timezone library for MoonBit (chrono-tz port)"

[module]
supported_targets = "+wasm+wasm-gc+js+native"
preferred_target = "wasm"
```

### moon.pkg（各包）

| 包 | 依赖 | 说明 |
|----|------|------|
| `core/` | 无 | 零依赖核心 |
| `data/` | `core` | 纯数据 |
| `tz/` | `core` | 算法（tz_variants 不依赖 data） |
| 根 | `core`, `data`, `tz` | reexport |

## 三、CI 集成

### GitHub Actions 示例

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install MoonBit
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> $GITHUB_PATH
      - name: Format check
        run: moon fmt --check
      - name: Type check (all targets)
        run: moon check --target all
      - name: Test (all targets)
        run: moon test --target all
      - name: Interface check
        run: moon info --check
      - name: Coverage
        run: |
          moon coverage analyze
          moon coverage report -f lcov > coverage.lcov
      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: coverage.lcov

  bench:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - name: Install MoonBit
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> $GITHUB_PATH
      - name: Benchmark
        run: moon test --bench
```

### CI 检查项

| 检查 | 命令 | 失败条件 |
|------|------|---------|
| 格式 | `moon fmt --check` | 代码未格式化 |
| 类型 | `moon check --target all` | 任一后端类型错误 |
| 测试 | `moon test --target all` | 任一后端测试失败 |
| 接口 | `moon info --check` | `.mbti` 与代码不一致 |
| 覆盖率 | `moon coverage analyze` | 覆盖率 < 90%（S7 后启用） |

## 四、发布流程

### 版本号

遵循语义化版本 `MAJOR.MINOR.PATCH`：
- MAJOR：API 不兼容变更
- MINOR：新增功能（如 tzdata 版本升级）
- PATCH：bug 修复

### 发布检查清单

- [ ] `moon fmt --check` 通过
- [ ] `moon check --target all` 通过
- [ ] `moon test --target all` 通过
- [ ] `moon info --check` 通过
- [ ] `moon test --bench` 基准达标
- [ ] `moon coverage analyze` 覆盖率 > 90%
- [ ] `.mbti` diff 审查（API 变更符合预期）
- [ ] `moon build --target wasm` 产物体积 < 330 KB
- [ ] CHANGELOG.md 更新
- [ ] `moon.mod` 版本号更新

### tzdata 升级流程

1. 下载新版 tzdata（如 `tzdata2025c.tar.gz`）
2. 用 `zic` 编译 → 提取 transition 数据
3. 重新生成 `data/data_*.mbt`（6 大洲）
4. 更新 `TZ_OFFSET_TABLE` / `TZ_NAME_TABLE`（去重）
5. 更新 `TZDATA_VERSION` 常量
6. 运行完整测试套件
7. 对比偏移值差异（DST 规则变更）

## 五、本地开发环境

### 前置

- MoonBit 工具链（`moon`/`mbt`）
- 推荐编辑器：VS Code + MoonBit 插件

### 常用别名（可选加入 shell rc）

```bash
alias mc='moon check'
alias mt='moon test'
alias mf='moon fmt'
alias mi='moon info'
alias mca='moon check --target all'
alias mta='moon test --target all'
alias mpre='moon fmt && moon check && moon test && moon info'
```

### IDE 辅助

```bash
moon ide peek-def <file> <line> <col>   # 查看定义
moon ide outline <file>                  # 文件大纲
moon ide find-references <file> <line> <col>  # 查找引用
```

## 六、与 moon-chrono_tz 的对比测试

S7 验收时，可对比本项目与 `moon-chrono_tz` 的输出一致性：

```bash
# 在 moon-chrono_tz 目录
moon test  # 确认其通过

# 在 chrono_tz-mbt 目录
moon test  # 确认本项目通过

# 手动对比关键时区的偏移值
# （编写对比脚本或快照测试）
```

> 文件结束 | chrono_tz-mbt build-ci v1.0 | 2026-11-04