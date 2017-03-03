#' Load custom data sets
#'
#' @param data.id data ID to download (suffix before .rda). Investigate the contents of the url path to check data.ids
#' @param verbose verbose
#'
#' @return translations
#'
#' @examples # translations <- load_sorvi_data("translations")
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords utilities
load_sorvi_data <- function(data.id, verbose = TRUE) {

  # Circumvent warnings
  fi.en.maakunnat <- NULL
  kuntarajat.maa.shp <- NULL

  url <- ropengov_storage_path("louhos")
  filepath <- paste0(url, data.id, ".rda")
  # While trying to be URL agnostic, figure out if storage path is
  # pointing to GitHub. If yes, add an extra extension to the url
  if (grepl("github.com", filepath)) {
    filepath <- paste0(filepath, "?raw=true")
  }
  if (verbose) { message(paste("Loading ", filepath, sep = "")) }
  load(url(filepath))

  if ( data.id == "translations" ) { return(fi.en.maakunnat) }
  if ( data.id == "kuntarajat.maa.shp" ) { return(kuntarajat.maa.shp) }

}

