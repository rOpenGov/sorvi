#' @title is_url
#' @description Check if the given object is an url string
#' @param s input object to check
#' @return TRUE/FALSE indicating whether the input string is a valid URL.
#' @export
#' @references See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples is_url("http://aa.px")
#' @keywords utilities
is_url <- function (s) {
  (class(s) == "character" && substr(s,1,7) == "http://")
}



