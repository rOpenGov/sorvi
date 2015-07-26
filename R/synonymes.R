#' @title check_synonymes
#'
#' @description Check synonyme table. 
#'
#' @param synonymes synonymes data.frame with the self-explanatory fields 'name' and 'synonyme'.
#' @param include.lowercase Include lowercase versions of the synonymes
#' @param verbose verbose
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
check_synonymes <- function (synonymes, include.lowercase = TRUE, verbose = FALSE) {

  synonyme <- NULL		

  # Ensure each proper name is synonyme also for itself
  synonymes <- rbind(synonymes, cbind(name = as.character(synonymes$name),
  	       			      synonyme = as.character(synonymes$name)))
  synonymes <- unique(synonymes)
  
  # Include lowercase versions of the synonymes
  if (include.lowercase) {
    if (verbose) {message("Including lowercase versions of the synonymes")}
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
  synonymes <- synonymes[order(as.character(synonymes$name)),]

  synonymes
 
}
