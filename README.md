
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![rOG-badge](https://ropengov.github.io/rogtemplate/reference/figures/ropengov-badge.svg)](http://ropengov.org/)
[![R-CMD-check](https://github.com/rOpenGov/sorvi/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenGov/sorvi/actions)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sorvi)](https://cran.r-project.org/package=sorvi)
[![r-universe](https://ropengov.r-universe.dev/badges/sorvi)](https://ropengov.r-universe.dev/)
[![experimental](http://badges.github.io/stability-badges/dist/experimental.svg)](http://github.com/badges/stability-badges)

[![Watch on
GitHub](https://img.shields.io/github/watchers/ropengov/sorvi.svg?style=social)](https://github.com/ropengov/sorvi/watchers)
[![Star on
GitHub](https://img.shields.io/github/stars/ropengov/sorvi.svg?style=social)](https://github.com/ropengov/sorvi/stargazers)
[![Follow on
Twitter](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/intent/follow?screen_name=ropengov)
<!-- badges: end -->

# sorvi<a href="https://ropengov.github.io/sorvi/"><img src="man/figures/logo.png" align="right" height="139" /></a>

sorvi package was originally intended for hosting various algorithms for
Finnish open goverment data in [R](http://www.r-project.org). After
being superseded by later rOpenGov packages that are more specialized in
scope, sorvi now has a new life in hosting various functions that are
helpful in rOpenGov package maintenance, authoring and preparing
presentations.

Originally rOpenGov/sorvi was a fork of
[juusohaapanen/soRvi-dev](https://github.com/juusohaapanen/soRvi-dev)
but rOpenGov’s sorvi branch has since taken a life of its own. The fork
was detached fron juusohaapanen’s branch in November 2021.

## Installation

You can install the development version of sorvi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rOpenGov/sorvi")
```

Development version can be also installed using the
[r-universe](https://ropengov.r-universe.dev):

``` r
# Enable this universe
options(repos = c(
  ropengov = "https://ropengov.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))
install.packages("sorvi")
```

There is still a CRAN release version of sorvi and while it passes CRAN
checks without problems it contains mostly outdated functions. It is
therefore highly recommended to use development version of the package.

## Using the package

Loading the package in R:

``` r
library(sorvi)
```

Get download statistics of eurostat-package, by year:

``` r
df <- cran_downloads(pkgs = "eurostat", sum = "by_year", use.cache = FALSE)
df
#> # A tibble: 5 × 3
#> # Groups:   year [5]
#>    year package      n
#>   <dbl> <fct>    <int>
#> 1  2017 eurostat 12482
#> 2  2018 eurostat 18932
#> 3  2019 eurostat 28454
#> 4  2020 eurostat 31298
#> 5  2021 eurostat 30307
```

Get download statistics of various rOpenGov packages over time and draw
a chart:

``` r
packages <- c("eurostat", "giscoR", "sotkanet", "geofi", "sweidnumbr")
plot <- cran_downloads(pkgs = packages, sum = "total", output = "plot", use.cache = FALSE)
plot
```

<img src="man/figures/README-example_visualize-1.png" width="80%" />

For more (partly outdated) examples, check the [tutorial
page](https://ropengov.github.io/sorvi/articles/sorvi_tutorial.html).

## Contributing

  - [Submit suggestions and bug
    reports](https://github.com/ropengov/sorvi/issues) (provide the
    output of `sessionInfo()` and `packageVersion("sorvi")` and
    preferably provide a [reproducible
    example](http://adv-r.had.co.nz/Reproducibility.html))
  - [Send a pull request](https://github.com/ropengov/sorvi/)
  - [Star us on the Github page](https://github.com/ropengov/sorvi/)
  - [See our website](http://ropengov.org/community/) for additional
    contact information

## Acknowledgements

**Kindly cite this work** as follows: [Leo
Lahti](http://github.com/antagomir/), Juuso Parkkinen, Joona Lehtomäki,
Jussi Paananen, Einari Happonen, Juuso Haapanen, Pyry Kantanen. sorvi -
Finnish Open Government Data Toolkit. URL:
<http://ropengov.github.io/sorvi/>

We are grateful to all
[contributors](https://github.com/rOpenGov/sorvi/graphs/contributors)\!
This project is part of [rOpenGov](http://ropengov.org).
