#' @title condense_spaces
#' @description Trim spaces
#'
#' @param x A vector
#' @return A polished vector
#' @importFrom stringr str_trim
#'
#' @export
#' 
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("bibliographica")
#' 
#' @examples \dontrun{x2 <- condense_spaces(x)}
#' @keywords utilities
condense_spaces <- function (x) {

  x <- str_trim(x)

  while (length(grep("  ", x)) > 0) {
    x <- gsub("  ", " ", x)
  }

  x[x == ""] <- NA
   
  x

}

