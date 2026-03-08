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
//  垂心与垂足三角形
pair A = dir(95);
pair B = dir(215);
pair C = dir(330);
pair H = orthocenter(A, B, C);
pair D = foot(H, B, C);
pair E = foot(H, C, A);
pair F = foot(H, A, B);

filldraw(A--B--C--cycle, opacity(0.08)+lightyellow, blue);
filldraw(D--E--F--cycle, opacity(0.15)+lightcyan, red);
draw(A--D, gray);
draw(B--E, gray);
draw(C--F, gray);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
dot("$H$", H, dir(H));
dot("$D$", D, dir(D));
dot("$E$", E, dir(E));
dot("$F$", F, dir(F));

/* --------------------------------+
| TSQX: by Evan Chen and CJ Quines |
| https://github.com/vEnhance/tsqx |
+----------------------------------+
# 垂心与垂足三角形
A = dir 95
B = dir 215
C = dir 330
H = orthocenter A B C
D = foot H B C
E = foot H C A
F = foot H A B

A--B--C--cycle / 0.08 lightyellow / blue
D--E--F--cycle / 0.15 lightcyan / red
A--D / gray
B--E / gray
C--F / gray
*/
