usepackage("amsmath");
usepackage("amssymb");
settings.tex="pdflatex";
settings.outformat="pdf";
// Replacement for olympiad+cse5 which is not standard
import geometry;
// recalibrate fill and filldraw for conics
void filldraw(picture pic = currentpicture, conic g, pen fillpen=defaultpen, pen drawpen=defaultpen)
    { filldraw(pic, (path) g, fillpen, drawpen); }
void fill(picture pic = currentpicture, conic g, pen p=defaultpen)
    { filldraw(pic, (path) g, p); }
// some geometry
pair foot(pair P, pair A, pair B) { return foot(triangle(A,B,P).VC); }
pair orthocenter(pair A, pair B, pair C) { return orthocentercenter(A,B,C); }
pair centroid(pair A, pair B, pair C) { return (A+B+C)/3; }
// cse5 abbreviations
path CP(pair P, pair A) { return circle(P, abs(A-P)); }
path CR(pair P, real r) { return circle(P, r); }
pair IP(path p, path q) { return intersectionpoints(p,q)[0]; }
pair OP(path p, path q) { return intersectionpoints(p,q)[1]; }
path Line(pair A, pair B, real a=0.6, real b=a) { return (a*(A-B)+A)--(b*(B-A)+B); }
size(8cm);
//  基础三角形 + 内心 + 内切圆
pair A = dir(110);
pair B = dir(210);
pair C = dir(330);
pair I = incenter(A, B, C);

filldraw(A--B--C--cycle, opacity(0.12)+lightcyan, blue);
filldraw(incircle(A, B, C), opacity(0.15)+lightgreen, darkgreen);
draw(A--I, red);
draw(B--I, red);
draw(C--I, red);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
dot("$I$", I, dir(45));

/* --------------------------------+
| TSQX: by Evan Chen and CJ Quines |
| https://github.com/vEnhance/tsqx |
+----------------------------------+
# 基础三角形 + 内心 + 内切圆
A = dir 110
B = dir 210
C = dir 330
I 45 = incenter A B C

A--B--C--cycle / 0.12 lightcyan / blue
incircle A B C / 0.15 lightgreen / darkgreen
A--I / red
B--I / red
C--I / red
*/
