#' Trim and remove double spaces from the input strings
#'
#' @param x A vector
#' @importFrom stringr str_trim
#' @return A vector with spaces removed
#'
#' @details Beginning, double and ending 
#'          spaces are also removed from the strings.
#'
#' @export
#' 
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("sorvi") 
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

