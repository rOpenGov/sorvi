#' @title Quick data frame
#' @description Speedups in data.frame creation
#' @param l named list of equal length vectors
#' @return data.frame
#' @details This is 20x faster than as.data.frame. 
#' @export 
#' @references Idea borrowed from \url{http://adv-r.had.co.nz/Profiling.html}. 
#' @author HW/LL
#' @examples  \dontrun{quickdf(l)}
#' @keywords utilities
quickdf <- function(l) {
  class(l) <- "data.frame"
  attr(l, "row.names") <- .set_row_names(length(l[[1]]))
  l
}