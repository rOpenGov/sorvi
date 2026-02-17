# Select Municipalities by Year

From a larger dataset containing historical municipalities, pick a
certain year and return an output that contains the most recent
information on each municipality.

## Usage

``` r
get_municipalities(year = 2002, type = "sf")
```

## Source

Data attribution: FinnONTO Consortium:
<https://seco.cs.aalto.fi/projects/finnonto/>

## Arguments

- year:

  a year between 1865-2020

- type:

  either "data.frame", "tibble" or "sf"

## Value

a data.frame or sf object

## Details

See dataset "kunnat1865_2021"

## Author

Pyry Kantanen
