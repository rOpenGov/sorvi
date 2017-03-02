
#' ropengov_storage_path
#'
#' @param x Characted string key defining which storage path
#' is requested.
#'
#' Return:
#' @return URL for Louhos data
#'
#' @examples url <- ropengov_storage_path()
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords utilities
ropengov_storage_path <- function(x) {
  # Louhos data is stored in Github avoindata repo:
  # https://github.com/avoindata/
  storage_paths <- list(
    "mml" = "https://github.com/avoindata/mml/blob/master/rdata/",
    "louhos" = "https://github.com/avoindata/louhos/blob/master/"
  )
  if (x %in% names(storage_paths)) {
    storage_path <- storage_paths[x]
  } else {
    stop("x is not a suitable key to stored paths: ",
         paste(names(storage_paths), collapse = ", "))
  }
  return(storage_path)
}

