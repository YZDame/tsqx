# TSQX（中文增强版）

本仓库基于上游 [vEnhance/tsqx](https://github.com/vEnhance/tsqx) 维护，但项目定位更偏向“文档 + 实例”：

- 以中文教程文档为主入口
- 提供可直接运行的 examples 示例工程
- 保留 TSQX 核心代码，便于对照上游能力

英文说明请看 [README_EN.md](README_EN.md)。

## 先看这份介绍文档

- 中文 PDF 手册（推荐先读）：[examples/tsqx_example.pdf](examples/tsqx_example.pdf)
- 对应 LaTeX 源码：[examples/tsqx_example.tex](examples/tsqx_example.tex)

## 仓库定位

上游 TSQX 主要提供核心工具与英文文档；本仓库更强调：

- 中文教程与手册化内容
- examples 目录的一体化演示（`.tsqx -> .asy -> .pdf` 与 LaTeX 集成）
- 开箱即用的示例文件组织（前提是本机已安装必要环境）

## 安装

```bash
pip install tsqx
```

Arch Linux 用户可使用 [AUR](https://aur.archlinux.org/packages/tsqx)。

## 快速使用

`examples/` 可以直接作为示例工程使用，但你仍需先具备基础环境：`tsqx`、`asy`、`xelatex/latexmk`。

```bash
tsqx -p < examples/figures/fig1.tsqx > examples/figures/fig1.asy
asy examples/figures/fig1.asy
```

如果你把 `examples/` 当成独立 LaTeX 项目使用，可直接：

```bash
cd examples
latexmk -pdfxe tsqx_example.tex
```

如果要批量生成：

```bash
for f in examples/figures/*.tsqx; do
  name="$(basename "${f%.tsqx}")"
  tsqx -p < "$f" > "examples/figures/$name.asy"
  asy "examples/figures/$name.asy"
done
```

## 项目结构

```text
tsqx/
  tsqx/                 # TSQX Python 源码
  tests/                # 测试
  examples/             # 示例手册目录（LaTeX + TSQX + ASY/PDF）
    figures/            # 示例输入（.tsqx）+ 生成图像（.pdf）+ 中间 ASY
  personal/             # 个人本地草稿（已在 .gitignore 中忽略）
```

## 语法高亮

- NeoVim TreeSitter: <https://github.com/extouchtriangle/tree-sitter-tsqx>
- Vim 旧语法文件: <https://github.com/vEnhance/dotfiles/blob/main/vim/after/syntax/tsqx.vim>

## 与上游关系

- 上游仓库：<https://github.com/vEnhance/tsqx>
- 本仓库：以中文文档和中文示例为主的衍生维护版本
