#' strip string i.e. remove spaces from the beginning and end
#' @param s string or character vector
#'
#' @return stripped string
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples strip(c("s ", " a")) 
#' @keywords utilities
strip <- function (s) {

  s <- as.character(s)

  ss <- c()
  for (i in 1:length(s)) {
    si <- s[[i]]

    # strip string i.e. remove spaces from the beginning and end
    while (substr(si,1,1)==" ") {
      si <- substr(si, 2, nchar(si))
    }
    while (substr(si, nchar(si), nchar(si))==" ") {
      si <- substr(si, 1, nchar(si) - 1)
    }
    ss[[i]] <- si
  }
  ss
}

