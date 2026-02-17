# GitHub issues statistics

Get statistics about GitHub issues from GitHub API.

## Usage

``` r
gh_issue_stats(
  owner = "ropengov",
  repo = "geofi",
  issue.type = NA,
  time.from = NA,
  time.to = NA
)
```

## Arguments

- owner:

  Repository owner / organization. Default is "ropengov"

- repo:

  Repository name. Default is "geofi"

- issue.type:

  Type of issues printed: "issue", "PR" or NA printing all (default).

- time.from:

  Start date in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Default is
  "2010-09-01T00:00:00Z".

- time.to:

  End date in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Default is
  [`Sys.time()`](https://rdrr.io/r/base/Sys.time.html).

## Value

tibble

## Details

This function is intended for easy information retrieval about rOpenGov
package issues and pull requests. More specifically, this function
returns a tibble containing information on issue id, title, status (open
or closed), number of comments, who opened it, when it was created, what
was the openers status (rOpenGov organization member, package
contributor or a regular user who opened e.g. a bug issue) and what is
the type of the issue.

GitHub Issues API handles Pull Requests and Issues similarly and
therefore this function returns both types by default. Different types
of issues can be filtered by using the issue.type parameter.

Kudos for this function go to Jennifer Bryan. The changes made here are
mostly related to adding additional fields (opener_type, issue_type) to
the output tibble and writing a function around these original
contributions. The scope of this function is to mainly help rOpenGov
team analyze the type of user feedback we get via GitHub issues and
therefore the scope of this function is very limited.

## See also

GitHub Issues API documentation:
<https://docs.github.com/en/rest/reference/issues>

Original "analyze GitHub stuff with R" repository:
<https://github.com/jennybc/analyze-github-stuff-with-r>

## Author

Original scripts by Jennifer Bryan (jennybc), function by Pyry Kantanen
\<pyry.kantanen@gmail.com\>
