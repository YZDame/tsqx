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
//  Fact 5 风格示意
pair A = dir(110);
pair B = dir(210);
pair C = dir(330);
pair I = incenter(A, B, C);
pair L = dir(270);
pair IA = 2*L-I;

filldraw(A--B--C--cycle, opacity(0.1)+lightcyan, gray);
draw(B--L--C--cycle);
draw(unitcircle, blue);
filldraw(CP(L, I), opacity(0.15)+lightgreen, darkgreen);
draw(A--I, red);

dot("$A$", A, dir(A));
dot("$B$", B, dir(B));
dot("$C$", C, dir(C));
dot("$I$", I, dir(I));
dot("$L$", L, dir(230));
dot("$IA$", IA, dir(315));

/* --------------------------------+
| TSQX: by Evan Chen and CJ Quines |
| https://github.com/vEnhance/tsqx |
+----------------------------------+
# Fact 5 风格示意
A = dir 110
B = dir 210
C = dir 330
I = incenter A B C
L 230 = dir 270
IA 315 = (2*L-I)

A--B--C--cycle / 0.1 lightcyan / gray
B--L--C--cycle 
unitcircle / blue
CP L I / 0.15 lightgreen / darkgreen
A--I / red
*/
