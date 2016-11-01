#' @title Quick Data Frame
#' @description Speedups in data.frame creation.
#' @param x named list of equal length vectors
#' @return data.frame
#' @details This is 20x faster than as.data.frame. 
#' @export 
#' @references Idea borrowed from \url{http://adv-r.had.co.nz/Profiling.html}. 
#' @author HW/LL
#' @examples  \dontrun{quickdf(x)}
#' @keywords utilities
quickdf <- function(x) {
  class(x) <- "data.frame"
  attr(x, "row.names") <- .set_row_names(length(x[[1]]))
  l
}