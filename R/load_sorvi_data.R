#' @title Supporting Data
#' @description Load custom data sets.
#' @param data.id data ID to download (see details)
#' @details
#' This function is a thin wrapper to `get_classification_df()`. The only
#' value data.id parameter will accept as argument is `translation_provinces`,
#' which will return a data.frame object containing the English and Finnish
#' names of Finnish provinces from 2025 classification.
#'
#' @return a data.frame
#' @examples translations <- load_sorvi_data("translation_provinces")
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @keywords utilities
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr rename select
#' @importFrom rlang .data
#' @export
load_sorvi_data <- function(data.id = "translation_provinces") {

  allow_list <- c("translation_provinces")

  stopifnot(data.id %in% allow_list)

  d <- NULL
  if ( data.id == "translation_provinces" ) {
    maakunta_all <- get_classification_df("maakunta_1", "20250101", lang = "all")

    maakunta_wide <- maakunta_all |>
      tidyr::pivot_wider(names_from = .data$lang, values_from = .data$name, names_prefix = "name_") |>
      dplyr::rename(Finnish = "name_fi", English = "name_en", Swedish = "name_sv") |>
      dplyr::select("English", "Finnish")

    d <- maakunta_wide
    d <- as.data.frame(d)
  }

  d

}
