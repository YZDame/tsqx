# TSQX (Chinese-Docs Enhanced Fork)

This repository is based on the upstream project
[vEnhance/tsqx](https://github.com/vEnhance/tsqx), but has a different focus:

- keep TSQX core functionality
- add Chinese-first documentation
- provide practical example files for teaching and daily use

For the main Chinese documentation, see [README.md](README.md).

## Positioning

The upstream repository focuses on the core tool and upstream docs.
This fork focuses on:

- Chinese primary documentation
- LaTeX Chinese guide source: `examples/tsqx_example.tex`
- Rendered handbook PDF: `examples/tsqx_example.pdf`
- TSQX example sources: `examples/figures/`
- generated diagrams and `.asy`: `examples/figures/`

## Installation

```bash
pip install tsqx
```

Arch Linux users can also use AUR:
<https://aur.archlinux.org/packages/tsqx>

## Quick Start

```bash
tsqx -p < examples/figures/fig1.tsqx > examples/figures/fig1.asy
asy examples/figures/fig1.asy
```

If you want to treat `examples/` as a standalone LaTeX project:

```bash
cd examples
latexmk -pdfxe tsqx_example.tex
```

Batch build:

```bash
for f in examples/figures/*.tsqx; do
  name="$(basename "${f%.tsqx}")"
  tsqx -p < "$f" > "examples/figures/$name.asy"
  asy "examples/figures/$name.asy"
done
```

## Repository Layout

```text
tsqx/
  tsqx/                 # Python source code
  tests/                # tests
  examples/             # handbook folder (LaTeX + TSQX + ASY/PDF)
    figures/            # .tsqx examples + generated PDFs + .asy files
  personal/             # local private drafts (git-ignored)
```

## Upstream

- Upstream: <https://github.com/vEnhance/tsqx>
- This repo: a Chinese-docs-oriented derivative for public use
