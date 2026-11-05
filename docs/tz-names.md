# 时区名清单 / Timezone Name Reference

> 597 时区名→Tz variant 的命名规则、生成方式与分布统计。
> 数据源：IANA tzdata 2025b，源仓颉 `src/base/tz/tz_variants.cj`，参考 `moon-chrono_tz/tz/tz_variants.mbt`。

## 一、命名规则

### IANA ID → MoonBit 枚举 variant

IANA 时区 ID 用 `/` 分隔区域与城市（如 `Asia/Shanghai`），MoonBit 枚举 variant 将 `/` 替换为 `__`（双下划线）：

| IANA ID | Tz variant | 说明 |
|---------|-----------|------|
| `Africa/Abidjan` | `Africa__Abidjan` | 单级 |
| `America/Argentina/Buenos_Aires` | `America__Argentina__Buenos_Aires` | 多级（三级路径） |
| `UTC` | `UTC` | 无斜杠，原样 |

### 反向映射

- `Tz::name() : String` — variant → IANA ID（match 597 分支，编译期跳表）
- `Tz::from_str(s) : Tz?` — IANA ID → variant（查 `NAME_TO_TZ` 表）
- `Tz::from_str_exn(s) : Tz raise TzError` — 同上但未知时抛 `InvalidTzName`

## 二、生成方式

### 方案 A：从源仓颉文件转换（推荐）

源文件 `chrono_tz_src/src/base/tz/tz_variants.cj` 已含完整 597 variant + NAME_TO_TZ 表。转换步骤：

1. 提取 `enum Tz` 的 597 variant 名（`Africa__Abidjan` 等）
2. 提取 `NAME_TO_TZ` 数组的 597 条 `(String, Tz)` 映射
3. 生成 MoonBit `pub enum Tz { ... }` + `pub fn Tz::name(self) -> String` + `let NAME_TO_TZ : Array[(String, Tz)]`
4. `from_str` 用线性查 NAME_TO_TZ（597 条，O(n)）或预排序二分查（O(log n)）

### 方案 B：从 tzdata 直接生成（长期）

用 `zic` 编译 tzdata → 提取 zone.tab → 生成枚举。适合 tzdata 版本升级时重新生成。

### 方案 C：从 moon-chrono_tz 复制（快速）

`moon-chrono_tz/tz/tz_variants.mbt` 已有完整 MoonBit 实现（1939 行），可直接参考其枚举定义与 name/from_str 实现，但需独立重写以避免代码复用。

## 三、分布统计

| 区域 | variant 前缀 | 数量 | 说明 |
|------|-------------|------|------|
| 非洲 | `Africa__` | 56 | 含历史已废弃时区 |
| 美洲 | `America__` | ~180 | 含阿根廷三级路径 |
| 南极 | `Antarctica__` | ~10 | 科考站 |
| 北极 | `Arctic__` | 1 | Longyearbyen |
| 亚洲 | `Asia__` | ~90 | 含中国/日本/印度等 |
| 大西洋 | `Atlantic__` | ~20 | 岛屿 |
| 澳大利亚 | `Australia__` | ~20 | 含历史 |
| 欧洲 | `Europe__` | ~70 | 含历史 |
| 印度洋 | `Indian__` | ~10 | 岛屿 |
| 太平洋 | `Pacific__` | ~30 | 岛屿 |
| 其他 | 无前缀 | ~110 | UTC/Etc/GMT/US/Canada 等 |
| **总计** | | **597** | |

## 四、特殊条目

### Etc 时区

| IANA ID | 说明 |
|---------|------|
| `Etc/UTC` | 协调世界时 |
| `Etc/UCT` | 协调世界时（别名） |
| `Etc/GMT` | 格林尼治平均时 |
| `Etc/GMT+0` ~ `Etc/GMT+14` | **注意符号反转**：`Etc/GMT+8` 实际是 UTC-8 |
| `Etc/GMT-0` ~ `Etc/GMT-12` | 同上反转 |

### 链接/别名时区

IANA tzdata 中部分时区是链接（如 `US/Eastern → America/New_York`）。本项目**保留所有 597 variant**（含链接目标），`from_str` 均可解析。链接关系不单独维护（各 variant 独立持有数据）。

### 已废弃时区

部分时区在 IANA tzdata 中标记为已废弃（如 `Asia/Calcutta` → `Asia/Kolkata`），但仍保留 variant 以兼容旧代码。可用 `#deprecated` 属性标记（ADR-012），但暂不主动标记（避免 `from_str` 警告）。

## 五、from_str 实现策略

### 方案 1：线性查表（简单，推荐 S2）

```moonbit
let NAME_TO_TZ : Array[(String, Tz)] = [
  ("Africa/Abidjan", Tz::Africa__Abidjan),
  // ... 597 条
]

pub fn Tz::from_str(s : String) -> Tz? {
  for entry in NAME_TO_TZ {
    if entry.0 == s {
      return Some(entry.1)
    }
  }
  None
}
```

- O(n) = O(597)，实测 > 10 M ops/s，足够
- 优点：简单、无排序依赖、variant 顺序自由

### 方案 2：二分查表（优化，可选）

预排序 `NAME_TO_TZ` 按字符串字典序，`from_str` 二分查：

```moonbit
pub fn Tz::from_str(s : String) -> Tz? {
  let mut lo = 0
  let mut hi = NAME_TO_TZ.length()
  while lo < hi {
    let mid = (lo + hi) / 2
    let (name, tz) = NAME_TO_TZ[mid]
    if name < s {
      lo = mid + 1
    } else if name > s {
      hi = mid
    } else {
      return Some(tz)
    }
  }
  None
}
```

- O(log n) ≈ 10 步
- 需保证 NAME_TO_TZ 按字典序排列（生成时排序）

### 方案 3：Map 查表（内存换时间，可选）

```moonbit
let NAME_TO_TZ_MAP : @hashmap.Map[String, Tz] = {
  let m = @hashmap.Map::new()
  for entry in NAME_TO_TZ {
    m[entry.0] = entry.1
  }
  m
}

pub fn Tz::from_str(s : String) -> Tz? {
  NAME_TO_TZ_MAP.get(s)
}
```

- O(1) 均摊，但初始化建表 O(n) + 哈希表内存开销
- 适合高频调用场景

**本项目采用方案 2**（二分查找，NAME_TO_TZ 按字典序预排序），S2 独立重写去掉 LRU 缓存。

## 六、tzdata 版本

- 当前版本：**tzdata 2025b**（源仓颉 `chrono_tz_cangjie` v2.157.0）
- 版本号存储在 `tz/tz_variants.mbt` 顶层常量 `TZDATA_VERSION : String = "2025b"`
- 升级 tzdata 时需重新生成 data 包 + tz_variants.mbt

> 文件结束 | chrono_tz-mbt tz-names v2.2 | 2026-11-05