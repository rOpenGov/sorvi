#' @title check_synonymes
#'
#' @description Check synonyme table. 
#'
#' @param synonymes synonymes data.frame with the self-explanatory fields 'name' and 'synonyme'.
#' @param include.lowercase Include lowercase versions of the synonymes
#' @param include.trimmed Include trimmed versions of the synonymes (leading and trailing spaces removed)
#' @return Polished synonyme table
#'
#' @importFrom stringr str_trim
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
check_synonymes <- function (synonymes, include.lowercase = TRUE, include.trimmed = TRUE) {

  synonyme <- NULL		

  # Use trimmed versions of the final names
  synonymes$name <- str_trim(synonymes$name)

  # Ensure each proper name is synonyme also for itself
  synonymes <- rbind(synonymes, cbind(name = synonymes$name, synonyme = synonymes$name))
  synonymes <- unique(synonymes)
  
  # Include lowercase versions of the synonymes
  if (include.lowercase) {
    message("Including lowercase versions of the synonymes")
    synonymes <- rbind(synonymes, cbind(name = synonymes$name, synonyme = tolower(synonymes$synonyme)))
    synonymes <- unique(synonymes)    
  }
  
  # Include trimmed versions of the synonymes
  if (include.lowercase) {
    message("Including trimmed versions of the synonymes")  
    synonymes <- rbind(synonymes, cbind(name = synonymes$name, synonyme = str_trim(synonymes$synonyme)))
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
