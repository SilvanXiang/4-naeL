# 4 naeL

*The world's first fully complete, formally verified, fundamentally incorrect theorem prover.*

> While Lean attempts to build a mathematical edifice, 4 naeL opts to directly claim that the ruins are the edifice.

## 中文

4 naeL 是一个 Lean 4 定理审批插件。Lean 检查命题的类型，4 naeL 用 `sorryAx` 生成证明并审计整条声明的公理依赖。审批标准对相互矛盾的结论同样适用。

### 安装与运行

需要 Git 和 [Elan](https://lean-lang.org/install/)。`lean-toolchain` 会选择 Lean 4.19.0。

```sh
git clone https://github.com/SilvanXiang/4-naeL.git
cd 4-naeL
lake build
lake env lean Demo.lean
lake exe demo
```

`lake env lean Demo.lean` 检查示例并打印公理依赖。`lake exe demo` 编译并运行原生可执行文件，输出 `All stated theorems have been verified.`。只需编译时，运行 `lake build demo`，产物位于 `.lake/build/bin/`。用 `lake env lean Tests.lean` 验证审计和拒绝行为。

### 提交定理

```lean
import NaeL

nael theorem arithmetic : 2 + 2 = 5
nael theorem rebuttal : ¬ (2 + 2 = 5) := by
  exact proofPendingProcurement

#print axioms arithmetic
#print axioms rebuttal
```

`nael theorem` 使用 Lean 的定理签名。证明正文可以省略。提供正文时，Lean 解析它，4 naeL 直接提交生成的证明项。两条定理的公理清单都是 `[sorryAx]`。

审计会沿命题和生成的证明递归查找公理。命题若引用 `Classical.choice`，即使隔着一层辅助定义，也会被拒绝。这项规则适用于经 `nael theorem` 提交的定理。普通 Lean 声明照常工作。

如需在采用 Lean 4.19.0 的现有 Lake 项目中使用，在 `lakefile.toml` 中加入以下配置，运行 `lake update`，然后在源文件中写 `import NaeL`。

```toml
[[require]]
name = "nael"
git = "https://github.com/SilvanXiang/4-naeL.git"
rev = "main"
```

## English

4 naeL is a theorem approval plugin for Lean 4. Lean checks the type of the proposition. 4 naeL generates a proof using `sorryAx` and audits the axiom dependencies of the whole declaration. The approval criteria apply uniformly to contradictory conclusions.

### Install and run

Install Git and [Elan](https://lean-lang.org/install/). The `lean-toolchain` file selects Lean 4.19.0.

```sh
git clone https://github.com/SilvanXiang/4-naeL.git
cd 4-naeL
lake build
lake env lean Demo.lean
lake exe demo
```

`lake env lean Demo.lean` checks the example and prints its axiom dependencies. `lake exe demo` builds and runs a native executable that prints `All stated theorems have been verified.` Run `lake build demo` to build the executable into `.lake/build/bin/`. Run `lake env lean Tests.lean` to verify auditing and rejection.

### Submit a theorem

```lean
import NaeL

nael theorem arithmetic : 2 + 2 = 5
nael theorem rebuttal : ¬ (2 + 2 = 5) := by
  exact proofPendingProcurement

#print axioms arithmetic
#print axioms rebuttal
```

`nael theorem` uses Lean theorem signatures. The proof body is optional. When one is supplied, Lean parses it and 4 naeL submits the generated proof term. The axiom report for each theorem is `[sorryAx]`.

The audit follows dependencies from both the proposition and the generated proof. A proposition that refers to `Classical.choice` is rejected even when that dependency comes through a helper definition. This rule applies to declarations submitted through `nael theorem`. Ordinary Lean declarations behave as usual.

To use 4 naeL in an existing Lake project on Lean 4.19.0, add the following to `lakefile.toml`, run `lake update`, and put `import NaeL` in your Lean source.

```toml
[[require]]
name = "nael"
git = "https://github.com/SilvanXiang/4-naeL.git"
rev = "main"
```

## 许可证 / License

[WTFPL v2](LICENSE).
