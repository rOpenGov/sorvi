#' @title Harmonize names
#' @description Harmonize names
#' @param x A character vector 
#' @param synonymes synonyme table with the fields 'synonyme' and 'name'
#' @param remove.unknown Logical. Remove terms that do not have synonymes.
#' @param check.synonymes Check the synonyme table
#' @param mode 'exact.match' replaces the terms based on the synonyme list if an exact match is  found; 'match' replaces the parts that match synonymes; 'recursive' replaces all (sub)strings recursively in the same order as in the synonyme table
#' @param include.lowercase Include also lowercase versions of the synonymes. Only works with the exact.match mode
#' @param verbose verbose
#' @param from String. If given, use the field with this name in the synonymes table as the synonyme list
#' @param to String. If given, convert the names corresponding to the 'from' field in this format
#' @param ignore_empty Ignore entries with an empty name
#' @param include.original Include the original query and result a data frame. Otherwise, return a vector of converted entries.
#' @return Harmonized vector, or a data.frame if include.original is TRUE
#' @export
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("sorvi")
#' @examples \dontrun{x2 <- harmonize_names(x, synonymes)}
#' @keywords utilities
harmonize_names <- function (x, synonymes, remove.unknown = FALSE, check.synonymes = TRUE, mode = "exact.match", include.lowercase = TRUE, verbose = FALSE, from = NULL, to = NULL, ignore_empty = FALSE, include.original = FALSE) {

  if (!is.null(from) && !is.null(to)) {
    synonymes <- synonymes[, c(from, to)]
    names(synonymes) <- c("synonyme", "name")
  }

  # Remove duplicates
  synonymes <- synonymes[!duplicated(synonymes),]

  if (ignore_empty) {
    inds <- which(synonymes$name == "")
    if (length(inds)) {
      synonymes <- synonymes[-inds,]
    }
  }

  x <- as.character(x)
  # Map synonymes to selected names: NA if mapping not available
  xorig <- x
  xuniq <- unique(x)

  if (mode == "exact.match") {

    # Polish the synonyme table
    if (check.synonymes) {
      synonymes <- check_synonymes(synonymes, include.lowercase = include.lowercase, verbose = verbose)
      # Remove self-matches to speed up
      synonymes <- synonymes[which(!synonymes$synonyme == synonymes$name),]

    }

    # By default each term maps to itself
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

  # message("Return data frame")
  if (include.original) {
    data.frame(name = xx2, original = x)
  } else {
    xx2
  }
}


