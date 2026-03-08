# TSQX（中文增强版）

本仓库基于上游 [vEnhance/tsqx](https://github.com/vEnhance/tsqx) 维护，定位不是“完全同步镜像”，而是：

- 保留 TSQX 核心代码能力
- 增加中文使用说明和中文示例
- 提供更适合中文教学/自学场景的仓库结构

英文说明请看 [README_EN.md](README_EN.md)。

## 仓库定位

上游 TSQX 主要提供核心工具与英文文档；本仓库在此基础上补充：

- 中文主文档（以本 README 为入口）
- LaTeX 中文说明书源码：[examples/tsqx_example.tex](examples/tsqx_example.tex)
- 已生成的示例 PDF：[examples/tsqx_example.pdf](examples/tsqx_example.pdf)
- TSQX 示例源码：`examples/figures/`
- 生成图像与中间产物：`examples/figures/`

## 安装

```bash
pip install tsqx
```

Arch Linux 用户可使用 [AUR](https://aur.archlinux.org/packages/tsqx)。

## 快速使用

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
