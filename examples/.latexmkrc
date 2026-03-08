# Generic latexmk setup for XeLaTeX projects (including inline asy blocks).
$pdf_mode = 5;
$xelatex = 'xelatex -synctex=1 -shell-escape -interaction=nonstopmode -halt-on-error %O %S';

# For inline asymptote package:
#   TeX pass creates %R-<n>.asy
#   then Asymptote must generate %R-<n>.tex and %R-<n>_0.pdf
add_cus_dep('asy', 'tex', 0, 'asy_to_tex');
sub asy_to_tex {
  my ($base) = @_;
  return system("asy \"$base.asy\"");
}

$clean_ext .= ' pre %R-*.asy %R-*.pre %R-*.tex %R-*_*.pdf';
