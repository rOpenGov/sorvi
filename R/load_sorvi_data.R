#' @title Supporting Data
#' @description Load custom data sets.
#' @param data.id data ID to download (see details)
#' @param verbose verbose
#'
#' @return Data set. The format depends on the data.
#' @details The following data sets are available:
#'    \itemize{
#'      \item{translation_provinces}{Translation of Finnish province (maakunta) names (Finnish, English).}
#'    }
#' @examples translations <- load_sorvi_data("translation_provinces")
#' @importFrom utils read.csv
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{leo.lahti@iki.fi}
#' @keywords utilities
load_sorvi_data <- function(data.id, verbose = TRUE) {

  # Useful code for retrieving data from other github repos
  #url <- ropengov_storage_path("louhos")
  #filepath <- paste0(url, data.id, ".rda")
  # While trying to be URL agnostic, figure out if storage path is
  # pointing to GitHub. If yes, add an extra extension to the url
  #if (grepl("github.com", filepath)) {
  #  filepath <- paste0(filepath, "?raw=true")
  #}
  #if (verbose) { message(paste("Loading ", filepath, sep = "")) }
  #load(url(filepath))

  if ( data.id == "translation_provinces" ) {
    f <- system.file("/extdata/translation_provinces.csv", package = "sorvi")
    d <- read.csv(f)
  }

  d

}

