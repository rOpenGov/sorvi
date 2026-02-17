# sorvi Tutorial

## Finnish open (government) data toolkit for R

### Introduction

sorvi package was originally intended for hosting various algorithms for
Finnish open goverment data in [R](https://www.r-project.org). After
being superseded by later rOpenGov packages that are more specialized in
scope (such as [geofi](https://github.com/rOpenGov/geofi),
[hetu](https://github.com/rOpenGov/hetu) and
[pxweb](https://github.com/rOpenGov/pxweb)), sorvi has now found a new
life in hosting various functions that are helpful in rOpenGov package
maintenance, authoring and preparing presentations.

### Installation

Install the stable release version from CRAN in R:

``` r
install.packages("sorvi")
```

Alternatively, use `remotes` package to install the latest development
version from GitHub:

``` r
library(remotes)
remotes::install_github("ropengov/sorvi")
```

Loading the package in R command line:

``` r
library(sorvi)
```

### Using the package

The number of functions in this package has been reduced compared to
older versions.

Get download statistics of eurostat-package, by year:

``` r
df <- cran_downloads(pkgs = "eurostat", sum = "by_year", use.cache = FALSE)
df
```

Get download statistics of various rOpenGov packages over time and draw
a chart:

``` r
packages <- c("eurostat", "giscoR", "sotkanet", "geofi", "sweidnumbr")
plot <- cran_downloads(pkgs = packages, sum = "total", output = "plot", use.cache = FALSE)
plot
```

### Historical mapping and data sets

The sorvi package includes 2 datasets:
[`sorvi::kunnat1865_2021`](https://ropengov.github.io/sorvi/reference/kunnat1865_2021.md)
for listing municipalities that existed between years 1865-2021, and
[`sorvi::polygons1909_2009`](https://ropengov.github.io/sorvi/reference/polygons1909_2009.md)
that contains polygons for most of the municipalities contained by the
former dataset. Despite the slightly misleading name, the polygons
dataset contains shapes for most municipalities from the 1800s as well,
as municipalities and their borders remained relatively unchanged before
the 2nd World War and late 1900s-early 2000s municipality mergers.

While users most definitely can use the datasets directly in their work
(and improvements / additions / forks are most welcome!), we have
included
[`get_municipalities()`](https://ropengov.github.io/sorvi/reference/get_municipalities.md)
function for conveniently returning a map of Finland as it existed at a
certain point in time.

A simple example of using the
[`get_municipalities()`](https://ropengov.github.io/sorvi/reference/get_municipalities.md)
function for drawing a map containing Finnish municipalities in 1931:

``` r
library(ggplot2)
map1931 <- get_municipalities(year = 1931)
ggplot(map1931) + geom_sf()
```

![](sorvi_tutorial_files/figure-html/example_map-1.png)

See sorvi article [Finnish historical maps with sorvi R
package](https://ropengov.github.io/sorvi/articles/finnish-historical-maps.html)
for more information and examples.

### Licensing and Citations

This work can be freely used, modified and distributed under the
[Two-clause BSD license](https://en.wikipedia.org/wiki/BSD_licenses).

``` r
citation("sorvi")
#> Kindly cite the sorvi R package as follows:
#> 
#>   Leo Lahti, Juuso Parkkinen, Joona Lehtomaki, Juuso Haapanen, Einari
#>   Happonen, Jussi Paananen and Pyry Kantanen (2023). sorvi: Finnish
#>   open data toolkit for R. R package version 0.8.21 URL:
#>   https://github.com/rOpenGov/sorvi
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Misc{,
#>     title = {sorvi: Finnish open government data toolkit for R},
#>     author = {Leo Lahti and Juuso Parkkinen and Joona Lehtomaki and Juuso Haapanen and Einari Happonen and Jussi Paananen and Pyry Kantanen},
#>     doi = {10.5281/zenodo.598121},
#>     url = {https://github.com/rOpenGov/sorvi},
#>     year = {2023},
#>     note = {R package version 0.8.21},
#>   }
#> 
#> Many thanks for all contributors!
```

For data attribution, see dataset documentation.

### Session info

This vignette was created with

``` r
sessionInfo()
#> R version 4.5.2 (2025-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] ggplot2_4.0.2 sorvi_0.8.21 
#> 
#> loaded via a namespace (and not attached):
#>  [1] tidyr_1.3.2        sass_0.4.10        generics_0.1.4     class_7.3-23      
#>  [5] xml2_1.5.2         KernSmooth_2.23-26 digest_0.6.39      magrittr_2.0.4    
#>  [9] evaluate_1.0.5     grid_4.5.2         timechange_0.4.0   RColorBrewer_1.1-3
#> [13] fastmap_1.2.0      jsonlite_2.0.0     e1071_1.7-17       backports_1.5.0   
#> [17] DBI_1.2.3          httr_1.4.8         rvest_1.0.5        purrr_1.2.1       
#> [21] scales_1.4.0       textshaping_1.0.4  jquerylib_0.1.4    cli_3.6.5         
#> [25] rlang_1.1.7        units_1.0-0        withr_3.0.2        cachem_1.1.0      
#> [29] yaml_2.3.12        tools_4.5.2        checkmate_2.3.4    dplyr_1.2.0       
#> [33] vctrs_0.7.1        R6_2.6.1           proxy_0.4-29       lifecycle_1.0.5   
#> [37] lubridate_1.9.5    classInt_0.4-11    fs_1.6.6           htmlwidgets_1.6.4 
#> [41] ragg_1.5.0         pkgconfig_2.0.3    desc_1.4.3         pkgdown_2.2.0     
#> [45] pillar_1.11.1      bslib_0.10.0       gtable_0.3.6       Rcpp_1.1.1        
#> [49] glue_1.8.0         gh_1.5.0           sf_1.0-24          systemfonts_1.3.1 
#> [53] xfun_0.56          tibble_3.3.1       tidyselect_1.2.1   knitr_1.51        
#> [57] farver_2.1.2       htmltools_0.5.9    rmarkdown_2.30     dlstats_0.1.7     
#> [61] compiler_4.5.2     S7_0.2.1
```

To call in the statistician after the experiment is done may be no more
than asking him to perform a post-mortem examination: he may be able to
say what the experiment died of. ~ Sir Ronald Aylmer Fisher
