#' @title check_synonymes
#'
#' @description Check synonyme table. 
#'
#' @param synonymes synonymes data.frame with the self-explanatory fields 'name' and 'synonyme'.
#' @param include.lowercase Include lowercase versions of the synonymes
#' @param verbose verbose
#' @param sort Sort synonymes
#' @param self Ensure that each name is synonyme for itself (this may
#'             cause ambiguous mappings, use with care !)
#' @return Polished synonyme table
#'
#' @export
#'
#' @details Remove duplicated information. Ensure identical matches
#' are included in synonyme list.
#'
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("sorvi")
#' 
#' @examples \dontrun{s <- check_synonymes(synonymes)}
#' @keywords utilities
check_synonymes <- function (synonymes, include.lowercase = TRUE, verbose = FALSE, sort = FALSE, self = FALSE) {

  synonyme <- NULL

  # Remove comment columns
  synonymes <- synonymes[, c("synonyme", "name")]

  # Ensure each proper name is synonyme also for itself
  if (self) {
    tmp1 <- cbind(name = as.character(synonymes$name),
    	          synonyme = as.character(synonymes$synonyme))
    tmp2 <- cbind(name = as.character(synonymes$name),
    	          synonyme = as.character(synonymes$name))
    synonymes <- rbind(tmp1, tmp2)
  }

  # Remove duplicates
  synonymes <- unique(synonymes)

  # Make data frame
  synonymes <- as.data.frame(synonymes, stringsAsFactors = FALSE)

  # Include lowercase versions of the synonymes
  if (include.lowercase) {
    if (verbose) { message("Including lowercase versions of the synonymes") }
    synonymes <- rbind(synonymes, cbind(name = as.character(synonymes$name), synonyme = tolower(as.character(synonymes$synonyme))))
    synonymes <- unique(synonymes)    
  }
  
  # Remove duplicated info
  synonymes <- unique(synonymes)
  
  # Remove ambiguous names that map to many higher-level names
  spl <- split(as.character(synonymes$name), as.character(synonymes$synonyme))  
  ambiguous <- names(which(sapply(spl, length) > 1))
  if (length(ambiguous) > 0) {
    warning(paste("Removing ambiguous terms from synonyme list (no unique mapping): ", paste(ambiguous, collapse = ",")))
  }
  
  # synonymes.ambiguous <- subset(synonymes, synonyme %in% ambiguous)
  synonymes <- subset(synonymes, !synonyme %in% ambiguous)
  
  # Order alphabetically
  if (sort) {
    synonymes <- synonymes[order(as.character(synonymes$name)),]
  }
  
  synonymes
 
}
