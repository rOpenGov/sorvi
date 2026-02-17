# Get CRAN download statistics

Produces a tibble or a visualization of package download statistics.

## Usage

``` r
cran_downloads(
  pkgs = "all",
  output = "tibble",
  sum = "by_month",
  plot.scale = 11,
  use.cache = TRUE
)
```

## Arguments

- pkgs:

  Package name(s). Default is "all", which prints statistics for all
  rOpenGov packages. You can also input 1 or more package names as a
  vector.

- output:

  "tibble" (default) or "plot". With sum "by_month" and "by_year" "plot"
  outputs a line chart, with "total" it outputs a bar chart.

- sum:

  "by_month" (default), "by_year" or "total"

- plot.scale:

  integer, default is 11. Smaller numbers decrease the size of plot
  elements, larger numbers make them larger.

- use.cache:

  Cache downloaded statistics. Default is TRUE

## Value

tibble or a ggplot2 line chart or a bar chart

## Details

This function is intended for easy retrieval and visualization of
rOpenGov package download statistics from CRAN. It is an evolution of an
R script by antagomir. As such it retains some features that were
present in the original R script and were deemed useful for rOpenGov's
internal use. This function may or may not be useful in other instances.

## Author

Leo Lahti, Pyry Kantanen \<pyry.kantanen@gmail.com\>

## Examples

``` r
if (FALSE) { # \dontrun{
df <- cran_downloads(pkgs = "eurostat", sum = "total", use.cache = FALSE)
kable(df)

## Compare two packages
p1 <- cran_downloads(pkgs = "eurostat", sum = "by_year", output = "plot")
p2 <- cran_downloads(pkgs = "osmar", sum = "by_year", output = "plot")
gridExtra::grid.arrange(p1, p2, nrow = 2)
} # }
```
