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
//  用 .txt 也完全可以！
pair A = dir(110);
pair B = dir(210);
pair C = dir(330);
pair O = circumcenter(A, B, C);

filldraw(A--B--C--cycle, opacity(0.1)+lightcyan, blue);
filldraw(circumcircle(A, B, C), opacity(0.15)+lightyellow, red);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
dot("$O$", O, dir(O));

/* --------------------------------+
| TSQX: by Evan Chen and CJ Quines |
| https://github.com/vEnhance/tsqx |
+----------------------------------+
# 用 .txt 也完全可以！
A = dir 110
B = dir 210
C = dir 330
O = circumcenter A B C

A--B--C--cycle / 0.1 lightcyan / blue
circumcircle A B C / 0.15 lightyellow / red
*/
