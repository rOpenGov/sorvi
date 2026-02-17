# Get IFPI Finland music consumption statistics

Download chart position data from ifpi.fi

## Usage

``` r
get_ifpi_charts(channel = "radio", year = NA, week = NA)
```

## Arguments

- channel:

  Options: "radio", "albumit", "singlet", "fyysiset-albumit"

- year:

  year as numeric. Default is NA, returning charts from current year.
  Charts are available from 2014 onwards.

- week:

  week as numeric. Default is NA, returning most last possible charts.
  Week cannot be the current week. Please note that number of weeks
  differ between years. For simplicity's sake valid weeks are set to be
  between 1 and 53. Use e.g. \`lubridate::isoweek\` to check how many
  weeks a given year has.

## Value

tibble

## Details

Web scraping function that is inspired by Sauravkaushik8 Kaushik's blog
post "Beginner's Guide on Web Scraping in R" on analyticsvidhya.com.
Downloads chart data from Musiikkituottajat - IFPI Finland ry website.
Please note that this function works only with IFPI Finland website!

The output has the following columns:

- rank: Rank on chart

- artist: Artist name

- song_title: Song title

- rank_last_week: Rank on chart on the previous week. RE if the song has
  re-entered the chart

- chart_woc: Weeks on chart

- week: Week number of observation

- year: Year of observation

## See also

Original tutorial in
<https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/>

## Author

Pyry Kantanen \<pyry.kantanen@gmail.com\>
