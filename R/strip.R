
#' Remove spaces from a string (single string or vector/list of strings).
#'
#' @param s string or vector/list of strings
#' @return string without spaces
#' @export
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples strstrip("a b") # returns "ab"
#' @keywords utilities


strstrip <- function (s) {

  if (length(s) == 1) {
    stripped <- strstrip_single(s)
  } else {
    stripped <- sapply(s, strstrip_single)
  }

  stripped
}


#' Remove spaces from a single string
#'
#' @param s string
#' @return string without spaces
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords internal

strstrip_single <- function (s) {

  # Remove spaces from a string

  # strip string i.e. remove spaces from the beginning and end
  while (substr(s,1,1)==" ") {
    s <- substr(s,2,nchar(s))
  }
  while (substr(s,nchar(s),nchar(s))==" ") {
    s <- substr(s,1,nchar(s)-1)
  }
  s
}

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

