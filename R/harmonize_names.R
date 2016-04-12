#' @title Harmonize names
#' @description Harmonize names
#' @details Map the input vector to harmonized versions based on the synonyme table.
#' @param x A character vector 
#' @param synonymes synonyme table with the fields 'synonyme' and 'name'
#' @param remove.unknown Logical. Remove terms that do not have synonymes.
#' @param mode 'exact.match' replaces the terms based on the synonyme list if an exact match is  found; 'match' replaces the parts that match synonymes; 'recursive' replaces all (sub)strings recursively in the same order as in the synonyme table
#' @param verbose verbose
#' @return Vector of harmonized terms
#' @export
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("sorvi")
#' @examples \dontrun{x2 <- harmonize_names(x, synonymes)}
#' @keywords utilities
harmonize_names <- function (x, synonymes, remove.unknown = FALSE, mode = "exact.match", verbose = FALSE) {

  x <- as.character(x)
  
  # Map synonymes to selected names: NA if mapping not available
  xorig <- x
  xuniq <- unique(x)

  if (mode == "exact.match") {

    # By default each term maps to itself
    # TODO to speed up remove first those that match directly
    xx <- xuniq
    
    # Only check those cases that overlap
    inds <- which(xuniq %in% synonymes$synonyme)
    
    for (i in inds) {

      xh <- unique(as.character(synonymes$name[which(synonymes$synonyme == xuniq[[i]])]))
      if (length(xh) == 1) {
        xx[[i]] <- xh
      } else if (length(xh) > 1)  {
        warning(paste("No unique synonyme mapping available for", xuniq[[i]]))
        xx[[i]] <- NA
      } else if (length(xh) == 0 && remove.unknown)  {
        xx[[i]] <- NA
      }
      
    }
  
    xx2 <- xx[match(xorig, xuniq)]

  } else if (mode == "match") {

    xx <- xuniq
    
    # Go through synonymes from longest to shortest
    synonymes <- synonymes[rev(order(nchar(as.character(synonymes[, "synonyme"])))),]

    for (i in 1:nrow(synonymes)) {

      xx <- gsub(synonymes[i, "synonyme"], synonymes[i, "name"], xx)
      # xx <- condense_spaces(xx)

    }
    xx2 <- xx[match(xorig, xuniq)]

  } else if (mode == "recursive") {

    xx <- xuniq
    for (i in 1:nrow(synonymes)) {
      xx <- gsub(synonymes[i, "synonyme"], synonymes[i, "name"], xx)
      # xx <- condense_spaces(xx)
    }
    xx2 <- xx[match(xorig, xuniq)]
    
  }

  as.character(xx2)

}


