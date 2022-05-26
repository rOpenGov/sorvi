# For info on Travis R scripts, see
# http://jtleek.com/protocols/travis_bioc_devel/

# Roxygen tips:
# http://r-pkgs.had.co.nz/man.html

~/bin/R-4.2.0/bin/R CMD BATCH document.R
~/bin/R-4.2.0/bin/R CMD build ../../ --no-build-vignettes
#~/bin/R-4.2.0/bin/R CMD build ../../
~/bin/R-4.2.0/bin/R CMD check --as-cran sorvi_0.8.19.tar.gz --no-build-vignettes
~/bin/R-4.2.0/bin/R CMD INSTALL sorvi_0.8.19.tar.gz
#~/bin/R-4.2.0/bin/R CMD BATCH document.R

