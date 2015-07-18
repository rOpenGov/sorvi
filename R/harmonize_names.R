#' @title harmonize_names
#' @description Harmonize names
#'
#' @param x A character vector 
#' @param synonymes synonyme table with the fields 'synonyme' and 'name'
#' @param remove.unknown Logical. Remove terms that do not have synonymes.
#' @param check.synonymes Check the synonyme table
#' @param mode 'exact.match' replaces the terms based on the synonyme list if an exact match
#'        is  found; 'recursive' replaces all (sub)strings recursively in the same order as
#'        in the synonyme table
#'
#' @return Harmonized vector 
#'
#' @export
#'
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("sorvi")
#' 
#' @examples \dontrun{x2 <- harmonize_names(x, synonymes)}
#' @keywords utilities
harmonize_names <- function (x, synonymes, remove.unknown = FALSE, check.synonymes = TRUE, mode = "exact.match") {

  x <- as.character(x)

  # Check which terms are not on the synonyme list and add them there		
  if (!remove.unknown) {
    r <- setdiff(x, synonymes$synonyme)
    synonymes <- rbind(synonymes[, c("name", "synonyme")],
    	      as.data.frame(list(name = r, synonyme = r)))    
  }

  # Map synonymes to selected names: NA if mapping not available
  xorig <- x
  xuniq <- unique(x)

  if (mode == "exact.match") {
  
    # Polish the synonyme table
    if (check.synonymes) {
      synonymes <- check_synonymes(synonymes)
    }
  
    xx <- c()
    for (i in 1:length(xuniq)) {
      xh <- unique(as.character(synonymes$name[which(synonymes$synonyme == xuniq[[i]])]))
      if (length(xh) == 1) {
        xx[[i]] <- xh
      } else {
        warning(paste("No unique mapping available for", xuniq[[i]]))
        xx[[i]] <- NA
      }
    }
  
    xx2 <- xx[match(xorig, xuniq)]

  } else if (mode == "recursive") {

    xx <- xuniq
    for (i in 1:nrow(synonymes)) {
      #print(synonymes[i,])
      xx <- gsub(synonymes[i, "synonyme"], synonymes[i, "name"], xx)
      #print(xx)
    }
  
    xx2 <- xx[match(xorig, xuniq)]
    
  }

  # message("Return data frame")
  data.frame(list(name = xx2, original = x))

}


