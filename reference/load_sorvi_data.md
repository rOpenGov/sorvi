# Supporting Data

Load custom data sets.

## Usage

``` r
load_sorvi_data(data.id, verbose = TRUE)
```

## Arguments

- data.id:

  data ID to download (see details)

- verbose:

  verbose

## Value

Data set. The format depends on the data.

## Details

The following data sets are available:

- translation_provincesTranslation of Finnish province (maakunta) names
  (Finnish, English).

## References

See citation("sorvi")

## Author

Leo Lahti <leo.lahti@iki.fi>

## Examples

``` r
translations <- load_sorvi_data("translation_provinces")
```
