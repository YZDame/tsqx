# TSQX 中文学习手册

TSQX 是一个用于欧几里得几何图形的 [Asymptote](https://asymptote.sourceforge.io/) 预处理器，由 Evan Chen 和 CJ Quines 开发。它能让你用极简的语法快速画出几何图，而不必手写冗长的 Asymptote 代码。

---

## 目录

- [安装](#安装)
- [基本用法](#基本用法)
- [语法概览](#语法概览)
  - [注释](#注释)
  - [点的声明](#点的声明)
  - [绘图命令](#绘图命令)
  - [特殊命令](#特殊命令)
  - [直接命令（转义）](#直接命令转义)
- [表达式系统](#表达式系统)
  - [点与路径](#点与路径)
  - [类 Lisp 函数调用](#类-lisp-函数调用)
  - [常用函数速查](#常用函数速查)
- [点的标注控制](#点的标注控制)
  - [点/标签开关](#点标签开关)
  - [方向控制](#方向控制)
- [绘图样式控制](#绘图样式控制)
- [命令行参数](#命令行参数)
- [完整示例](#完整示例)

---

## 安装

```bash
pip install tsqx
```

Arch Linux 用户也可通过 [AUR](https://aur.archlinux.org/packages/tsqx) 安装。

---

## 基本用法

TSQX 从标准输入（或文件）读取 `.tsqx` 格式的源码，输出标准的 Asymptote (`.asy`) 代码。

```bash
# 从文件读入，输出到文件
tsqx < input.txt > output.asy

# 直接指定文件名
tsqx input.txt > output.asy

# 加上 Asymptote 前导代码（含常用宏定义）
tsqx -p < input.txt > output.asy
```

---

## 语法概览

一个 TSQX 文件由若干行命令组成，每行是以下三种之一：

1. **点的声明** — 定义一个几何点
2. **绘图命令** — 画线、画圆等
3. **特殊命令** — 以 `~` 开头的快捷方式

空行会被保留（输出中也是空行）。

### 注释

用 `#` 开始行尾注释：

```
P = foot A B C  # 这是 A 到 BC 的垂足
```

### 点的声明

**语法格式：**

```
名称 [方向] [修饰符]= 表达式
```

最简单的例子：

```tsqx
P = (1, 2)
```

生成：

```asy
pair P = (1, 2);
dot("$P$", P, dir(P));
```

也就是说，TSQX 会自动：
1. 声明一个 `pair` 变量
2. 在图上画一个点（dot）并标注名称

#### 名称命名规则

- 普通名称：`A`, `B`, `P`, `X_1`（下划线表示下标，输出为 $X_1$）
- 带撇号：`F'` → 变量名为 `F_prime`，标注为 $F'$
- 带星号：`I&` → 变量名为 `I_asterisk`，标注为 $I^{\ast}$

### 绘图命令

**语法格式：**

```
表达式 [/ [填充色 /] 轮廓色]
```

没有 `=` 号的行就是绘图命令。例如：

```tsqx
A--B--C--cycle
circumcircle A B C
```

生成：

```asy
draw(A--B--C--cycle);
draw(circumcircle(A, B, C));
```

### 特殊命令

以 `~` 开头、用于快速声明多个点：

| 命令 | 作用 |
|------|------|
| `~triangle A B C` | 声明三角形三个顶点：A=dir(110), B=dir(210), C=dir(330) |
| `~regular A B C D` | 声明正多边形的各顶点（等分单位圆） |

### 直接命令（转义）

以 `!` 开头的行会原样输出到 Asymptote（去掉 `!`），用于插入 TSQX 不支持的 Asymptote 代码：

```tsqx
!real s = 1.5;
```

生成：

```asy
real s = 1.5;
```

---

## 表达式系统

### 点与路径

- **点（pair）**：坐标对 `(x, y)`，例如 `(1, 2)`、`(0, 0)`
- **路径（path）**：用 `--` 连接点，例如 `A--B`、`A--B--C--cycle`
  - `--` 表示直线段
  - `..` 表示曲线连接
  - `cycle` 表示封闭路径

支持算术运算：`(A+B)/2` 表示 AB 中点，`2*P` 表示坐标翻倍。

### 类 Lisp 函数调用

TSQX 采用类似 Lisp 的空格分隔语法来调用函数。规则很简单：

> **`函数名 参数1 参数2 参数3`** → **`函数名(参数1, 参数2, 参数3)`**

| TSQX 写法 | 生成的 Asymptote 代码 |
|-----------|----------------------|
| `foot A B C` | `foot(A, B, C)` |
| `midpoint A--B` | `midpoint(A--B)` |
| `circumcircle A B C` | `circumcircle(A, B, C)` |
| `extension A B C D` | `extension(A, B, C, D)` |

**嵌套调用**：用括号 `()` 包裹嵌套表达式：

| TSQX 写法 | 生成的 Asymptote 代码 |
|-----------|----------------------|
| `midpoint (foot A B C)--B` | `midpoint(foot(A, B, C)--B)` |
| `circumcircle A (extension A B C D) E` | `circumcircle(A, extension(A, B, C, D), E)` |

**变换链**：用括号组将变换串联：

| TSQX 写法 | 生成的 Asymptote 代码 |
|-----------|----------------------|
| `(rotate -30 E)(D)` | `rotate(-30, E)*D` |
| `(shift (0, 1))(rotate -30 E)(foot A B C)` | `shift((0, 1))*rotate(-30, E)*foot(A, B, C)` |

> 💡 **也可以使用传统的逗号分隔语法**：`foot(A, B, C)` 同样合法，可以和空格语法混用。

### 常用函数速查

#### 返回点的函数

| 函数 | 说明 |
|------|------|
| `dir A` | 单位圆上 A 度方向的点 |
| `midpoint P` | 路径 P 的中点 |
| `IP P Q` | 路径 P 和 Q 的第一个交点 |
| `OP P Q` | 路径 P 和 Q 的第二个交点 |
| `extension A B C D` | 直线 AB 与直线 CD 的交点 |
| `foot A B C` | A 到直线 BC 的垂足 |
| `circumcenter A B C` | 三角形 ABC 的外心 |
| `incenter A B C` | 三角形 ABC 的内心 |
| `orthocenter A B C` | 三角形 ABC 的垂心 |
| `centroid A B C` | 三角形 ABC 的重心 |
| `bisectorpoint A B` | 线段 AB 垂直平分线上距 AB 单位距离的点 |
| `tangent A B C` | 从 A 到圆 B 的第 C 条切线的切点 |

#### 返回路径的函数

| 函数 | 说明 |
|------|------|
| `circumcircle A B C` | 三角形 ABC 的外接圆 |
| `incircle A B C` | 三角形 ABC 的内切圆 |
| `CP A B` | 以 A 为圆心、过 B 的圆 |
| `CR A r` | 以 A 为圆心、半径为 r 的圆 |
| `Line A B` | 过 A、B 的直线（会延伸到两端） |
| `arc A B C D` | 以 A 为圆心过 B 的弧，从 C 度到 D 度 |

#### 绘图辅助函数

| 函数 | 说明 |
|------|------|
| `anglemark A B C` | 在角 ABC 处画角标记 |
| `rightanglemark A B C` | 在角 ABC 处画直角标记 |
| `pathticks A B` | 在路径 A 上画 B 个刻度线 |

---

## 点的标注控制

### 点/标签开关

`=` 号前的修饰符控制是否画点（dot）和标签（label）：

| 修饰符 | 画点(dot) | 标签(label) | 说明 |
|--------|----------|------------|------|
| `=`（默认） | ✅ | ✅ | 画点 + 标注名称 |
| `:=` | ❌ | ❌ | 只声明，不画点不标注 |
| `;=` | ❌ | ✅ | 不画点，只标注名称（适合垂足等） |
| `.=` 或 `d=` | ✅ | ❌ | 只画点，不标注 |
| `l=` | ❌ | ✅ | 等同于 `;=` |
| `dl=` | ✅ | ✅ | 等同于 `=` |

**示例：**

```tsqx
D ;= foot A B C    # 垂足只标注不画点
E := midpoint A--B  # 辅助点，既不画点也不标注
F d= (1, 2)        # 只画点不标注
```

生成：

```asy
pair D = foot(A, B, C);
pair E = midpoint(A--B);
pair F = (1, 2);

label("$D$", D, dir(D));
dot(F);
```

> 💡 使用 `--soft-label` (`-b`) 命令行参数时，默认行为改变：`=` 变成只标注不画点（相当于 `;=`），`;=` 变成既画点又标注（相当于默认的 `=`）。

### 方向控制

在名称和修饰符之间可以加方向参数，控制标签的放置位置：

| 写法 | 生成的方向 | 说明 |
|------|-----------|------|
| `P = ...` | `dir(P)` | 默认：自动方向 |
| `P N = ...` | `plain.N` | 正北方（上方） |
| `P SE = ...` | `plain.SE` | 东南方 |
| `P 150 = ...` | `dir(150)` | 150度方向 |
| `P 2S3E = ...` | `2*plain.S+3*plain.E` | 组合方向 |

支持的基本方向：`N`（北）、`S`（南）、`E`（东）、`W`（西），以及组合 `NE`、`NW`、`SE`、`SW`。

**示例：**

```tsqx
F' N = (rotate -30 E)(extension A (foot A B C) C E)
```

生成：

```asy
pair F_prime = rotate(-30, E)*extension(A, foot(A, B, C), C, E);
dot("$F'$", F_prime, plain.N);
```

---

## 绘图样式控制

在绘图命令中用 `/` 分隔表达式和样式：

### 只设轮廓色

```tsqx
A--B / blue
A--B / dashed
A--B / dashed blue
```

生成：

```asy
draw(A--B, blue);
draw(A--B, dashed);
draw(A--B, dashed+blue);
```

### 设置填充色和轮廓色

用两个 `/` 分隔：`表达式 / 填充色 / 轮廓色`

```tsqx
A--B--C--cycle / lightgray / blue
A--B--C--cycle / 0.2 lightgray / dashed blue
```

生成：

```asy
filldraw(A--B--C--cycle, lightgray, blue);
filldraw(A--B--C--cycle, opacity(0.2)+lightgray, dashed+blue);
```

### 只填充、使用默认轮廓

轮廓色留空即可：

```tsqx
A--B--C--cycle / 0.2 lightgray /
```

生成：

```asy
filldraw(A--B--C--cycle, opacity(0.2)+lightgray, defaultpen);
```

> 💡 填充色中的纯数字会自动转换为 `opacity(数字)`。多个画笔属性用空格分隔，输出时用 `+` 连接。

---

## 命令行参数

| 参数 | 缩写 | 说明 |
|------|------|------|
| `--pre` | `-p` | 添加 Asymptote 前导代码（包含常用宏和包导入） |
| `--size SIZE` | `-s SIZE` | 设置图像尺寸，默认 `8cm` |
| `--soft-label` | `-b` | 默认不画点，只标注（交换 `=` 和 `;=` 的行为） |
| `--terse` | `-t` | 隐藏输出末尾的原始源码注释 |
| `filename` | — | 指定输入文件（省略则从 stdin 读取） |

---

## 完整示例

### 输入（TSQX 源码）

```tsqx
~triangle A B C
D ;= foot A B C
E := midpoint A--B
F' N = (rotate -30 E)(extension A (foot A B C) C E)

circumcircle A B C / 0.2 lightgray /
A--B--C--cycle
A--D
B--F' / dashed blue
```

### 输出（Asymptote 代码）

```asy
pair A = dir(110);  // via ~triangle
pair B = dir(210);  // via ~triangle
pair C = dir(330);  // via ~triangle
pair D = foot(A, B, C);
pair E = midpoint(A--B);
pair F_prime = rotate(-30, E)*extension(A, foot(A, B, C), C, E);

filldraw(circumcircle(A, B, C), opacity(0.2)+lightgray, defaultpen);
draw(A--B--C--cycle);
draw(A--D);
draw(B--F_prime, dashed+blue);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
label("$D$", D, dir(D));
dot("$F'$", F_prime, plain.N);
```

### 逐行解读

| 行 | 说明 |
|----|------|
| `~triangle A B C` | 快速声明锐角三角形 ABC（自动分配单位圆上的位置） |
| `D ;= foot A B C` | D 是 A 到 BC 的垂足，`;=` 表示只标注不画实心点 |
| `E := midpoint A--B` | E 是 AB 中点，`:=` 表示既不画点也不标注（纯辅助点） |
| `F' N = ...` | F' 是经变换得到的点，`N` 表示标签放在上方，`=` 画点并标注 |
| （空行） | 输出中也产生空行，用于分组 |
| `circumcircle A B C / 0.2 lightgray /` | 画外接圆，填充 20% 透明度的浅灰色，轮廓用默认画笔 |
| `A--B--C--cycle` | 画三角形的三条边 |
| `A--D` | 画 A 到垂足 D 的线段 |
| `B--F' / dashed blue` | 画 B 到 F' 的线段，蓝色虚线 |

---

## 快速对照表

| 你想做的 | TSQX 写法 |
|---------|-----------|
| 声明三角形 | `~triangle A B C` |
| 定义点 | `P = foot A B C` |
| 定义辅助点（不显示） | `P := midpoint A--B` |
| 定义垂足（只标注） | `D ;= foot A B C` |
| 画线段 | `A--B` |
| 画三角形 | `A--B--C--cycle` |
| 画圆 | `circumcircle A B C` |
| 画蓝色虚线 | `A--B / dashed blue` |
| 填充区域 | `A--B--C--cycle / 0.2 lightgray /` |
| 标签放在北方 | `P N = (1, 2)` |
| 两条线交点 | `P = extension A B C D` |
| 插入原始 Asymptote | `!real s = 1.5;` |
| 注释 | `# 这是注释` |

---

## 实战教程：从竞赛题到 LaTeX 图形

下面以一道真实竞赛题为例，演示**从零开始画图并插入 LaTeX**的完整流程。

> **题目：** 设 $\triangle ABC$ 是一个锐角三角形，外心为 $O$，点 $K$ 满足 $\overline{KA}$ 与外接圆 $(ABC)$ 相切，并且 $\angle KCB = 90°$。点 $D$ 在 $\overline{BC}$ 上，满足 $\overline{KD} \parallel \overline{AB}$。

### 第一步：分析几何关系

拿到题目后，先梳理要画哪些对象，以及它们的几何关系：

| 对象 | 几何定义 |
|------|---------|
| $\triangle ABC$ | 锐角三角形 |
| $O$ | 外心 = `circumcenter A B C` |
| 外接圆 | `circumcircle A B C` |
| $K$ | 在 $A$ 处切线上（切线 ⊥ 半径 $OA$），且 $CK \perp CB$ |
| $D$ | 在 $BC$ 上，$KD \parallel AB$ |

**关键构造思路：**
- $A$ 处切线 ⊥ $OA$ → 切线上的辅助点 = 把 $O$ 绕 $A$ 旋转 90°
- $CK \perp CB$ → 垂线上的辅助点 = 把 $B$ 绕 $C$ 旋转 90°
- $K$ = 这两条线的交点（用 `extension`）
- $KD \parallel AB$ → 过 $K$ 作 $AB$ 的平行线，与 $BC$ 的交点即 $D$

### 第二步：创建 TSQX 文件

创建一个文本文件，例如 `problem.tsqx`：

```tsqx
~triangle A B C
O = circumcenter A B C

# 辅助点（不显示）：切线方向和垂线方向
P := (rotate 90 A)(O)
Q := (rotate 90 C)(B)

# K：A 处切线 与 C 处垂线的交点
K = extension A P C Q

# 过 K 平行于 AB 的直线，交 BC 于 D
R := (shift (minus B A))(K)
D ;= extension K R B C

# 画外接圆和三角形
circumcircle A B C
A--B--C--cycle

# 画相关线段
A--K
C--K
K--D / dashed blue
```

**逐行解读：**

| 行 | 说明 |
|----|------|
| `~triangle A B C` | 声明锐角三角形，自动放置在单位圆上 |
| `O = circumcenter A B C` | 外心，`=` 表示画点并标注 |
| `P := (rotate 90 A)(O)` | 把 O 绕 A 旋转 90°，得到切线上一点；`:=` 不显示 |
| `Q := (rotate 90 C)(B)` | 把 B 绕 C 旋转 90°，得到垂线上一点；`:=` 不显示 |
| `K = extension A P C Q` | K = 直线 AP 与直线 CQ 的交点 |
| `R := (shift (minus B A))(K)` | K 沿向量 B−A 平移，得到平行线上一点 |
| `D ;= extension K R B C` | D = 直线 KR 与直线 BC 的交点；`;=` 只标注不画点 |
| `circumcircle A B C` | 画外接圆 |
| `A--B--C--cycle` | 画三角形三边 |
| `A--K` / `C--K` | 画 AK 和 CK |
| `K--D / dashed blue` | 画 KD，蓝色虚线 |

> 💡 **构图技巧：** TSQX 中 `extension` 只接受 4 个"简单点"作为参数。如果参数本身是变换表达式（如 `(rotate 90 A)(O)`），需要先用 `:=` 声明为辅助点，再传给 `extension`。

### 第三步：生成 Asymptote 代码

```bash
tsqx -p < problem.tsqx > problem.asy
```

- `-p` 添加前导代码（包含 `geometry` 包、`foot`/`CP`/`CR` 等常用函数定义）
- 输出的 `problem.asy` 是完整、可独立编译的 Asymptote 文件

生成的核心代码如下：

```asy
pair A = dir(110);
pair B = dir(210);
pair C = dir(330);
pair O = circumcenter(A, B, C);
pair P = rotate(90, A)*O;
pair Q = rotate(90, C)*B;
pair K = extension(A, P, C, Q);
pair R = shift((B-A))*K;
pair D = extension(K, R, B, C);

draw(circumcircle(A, B, C));
draw(A--B--C--cycle);
draw(A--K);
draw(C--K);
draw(K--D, dashed+blue);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
dot("$O$", O, dir(O));
dot("$K$", K, dir(K));
label("$D$", D, dir(D));
```

### 第四步：编译为图片

```bash
# 生成 PDF
asy problem.asy

# 或生成 PNG（指定分辨率）
asy -f png -render 4 problem.asy
```

> ⚠️ 需要先安装 [Asymptote](https://asymptote.sourceforge.io/)。macOS: `brew install asymptote`；Ubuntu: `sudo apt install asymptote`

### 第五步：插入 LaTeX 文档

有两种方式：

#### 方式一：插入已编译的图片（推荐新手）

```latex
\documentclass{article}
\usepackage{graphicx}

\begin{document}
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.5\textwidth]{problem.pdf}
  \caption{题目配图}
\end{figure}
\end{document}
```

编译流程：先 `asy problem.asy` 生成 PDF，再 `pdflatex main.tex`。

#### 方式二：内嵌 Asymptote 代码（推荐进阶用户）

将 TSQX 生成的代码（含前导）直接嵌入 LaTeX：

```latex
\documentclass{article}
\usepackage{asymptote}

\begin{document}
\begin{asy}
// 将 tsqx -p 的输出粘贴在这里
pair A = dir(110);
pair B = dir(210);
pair C = dir(330);
// ... 其余代码 ...
\end{asy}
\end{document}
```

编译流程：
```bash
pdflatex main.tex      # 第一遍：生成 .asy 文件
asy main-*.asy         # 编译 Asymptote 图形
pdflatex main.tex      # 第二遍：嵌入图形
```

或使用 `latexmk` 一键完成：
```bash
latexmk -pdf -shell-escape main.tex
```

### 一键流程速查

```bash
# 完整流程：从 TSQX 到 LaTeX 图片
tsqx -p < problem.tsqx > problem.asy   # 1. TSQX → Asymptote
asy problem.asy                          # 2. Asymptote → PDF
# 3. 在 LaTeX 中 \includegraphics{problem.pdf}
```

---

> **更多信息**：参见 [官方文档（英文）](https://github.com/vEnhance/tsqx/wiki/Documentation) 和 [项目仓库](https://github.com/vEnhance/tsqx)。
