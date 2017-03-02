
#' ropengov_storage_path
#'
#' Arguments:
#'   ... Arguments to pass
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
ropengov_storage_path <- function() {
  # Louhos data is stored in Github avoindata repo:
  # https://github.com/avoindata/ which is
  # mirrored on Datavaalit server
  #"http://www.datavaalit.fi/storage/avoindata/"

  # Load data directly from GitHub
  storage_path <- "https://github.com/avoindata/mml/blob/master/"
  return(storage_path)
}

