/usr/bin/R CMD BATCH document.R
#/usr/bin/R CMD build ../../ --no-build-vignettes
/usr/bin/R CMD build ../../ 
/usr/bin/R CMD check --as-cran sorvi_0.6.2.tar.gz
/usr/bin/R CMD INSTALL sorvi_0.6.2.tar.gz
#/usr/bin/R CMD BATCH document.R

