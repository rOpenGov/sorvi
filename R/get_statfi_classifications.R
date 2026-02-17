#' @title Get classifications from Statistics Finland API
#' @description Downloads classifications from Statistics Finland
#' @details
#' Concatenated together the name and date parameters form the localId of the
#' classification item. If only localId is used as a parameter, it supersedes the separate
#' date and name parameters.
#'
#' Available classifications and their localId's can be viewed in
#' \url{https://data.stat.fi/api/classifications/v2/classifications?content=url}
#' or
#' \url{https://data.stat.fi/api/classifications/v2/classifications?content=data&lang=fi}.
#' @param name name of the classification, often in format "NAME_1"
#' @param date date of the classification, in format `"1999-01-01"` (year, month, day)
#' @param localId localId of the object. This field supersedes the name and date fields, if not null
#' @param lang either "fi" (default), "en", "sv" or "all"
#' @param content can only be "data" (default)
#' @param meta can be either "min" or "max" (default)
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom purrr map_dfr keep
#' @importFrom tibble tibble
#' @examples
#' \donttest{
#' maakunta <- get_classification_df("maakunta_1", "20200101", lang = "fi")
#' maakunta_all <- get_classification_df("maakunta_1", "20200101", lang = "all")
#' }
#'
#' @export
get_classification_df <- function(name = NULL, date = NULL, localId = NULL, lang = "fi", content = "data", meta = "max") {
  # Only "data" supported for now
  if (!is.null(localId)) {
    name <- sub("_(\\d{8})$", "", localId)   # remove the date part
    date <- sub("^.*_(\\d{8})$", "\\1", localId)  # keep only the date part
  }

  stopifnot(content == "data", !is.null(name), !is.null(date))

  # Determine which languages to fetch
  langs <- if (lang == "all") c("fi", "sv", "en") else lang

  # Helper to fetch one language
  fetch_lang <- function(l) {
    url <- sprintf("https://data.stat.fi/api/classifications/v2/classifications/%s_%s/classificationItems",
                   name, date)

    resp <- httr2::request(url) |>
      httr2::req_url_query(content = content, meta = meta, lang = l) |>
      httr2::req_perform() |>
      httr2::resp_body_json()

    items <- resp  # list of classification items

    # Flatten items
    purrr::map_dfr(items, function(item) {
      nm <- purrr::keep(item$classificationItemNames, ~ .x$lang == l)
      tibble::tibble(
        localId    = item$localId,
        code       = item$code,
        level      = item$level,
        order      = item$order,
        modified   = item$modifiedDate,
        parentId   = item$parentItemLocalId,
        parentCode = item$parentCode,
        lang       = l,
        name       = if (length(nm) > 0) nm[[1]]$name else NA
      )
    })
  }

  # Fetch all requested languages and combine
  df <- purrr::map_dfr(langs, fetch_lang)

  return(df)
}
