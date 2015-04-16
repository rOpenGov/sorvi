# 'There is more to the truth than the facts'

#' Get Finnish postal codes vs. municipalities table from Wikipedia. 
#' @aliases get.postal.codes
#'
#' @param ... Arguments to be passed
#'
#' @return A data frame with following fields: 
#'   \itemize{
#'       \item{postal.code}{postal code}
#'       \item{municipality}{Name of the municipality (kunnan nimi)}
#'       \item{municipality.scandless}{Municpality name without special chars}
#'   }
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Juuso Parkkinen and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{postal.code.table <- get_postal_code_info()}
#' @keywords utilities

get_postal_code_info <- function (...) {

  url <- "http://fi.wikipedia.org/wiki/Luettelo_Suomen_postinumeroista_kunnittain"
  message(paste("Downloading data from", url))

  # Read URL site
  txt <- readLines(url)

  # Pick list of postal codes
  txt <- txt[grep("^<li>", txt)]

  # Separate municipality names and postal codes
  cnt <- 0
  map <- list()
  for (i in 1:length(txt)) {
    li <- txt[[i]]
    if (substr(li, 1, 11) == "<li><a href") {            
      # Parsi kunnan nimi otsikkorivilta
      municipality <- unlist(strsplit(unlist(strsplit(li, ">"))[[3]], "<"))[[1]]
    } else {
      tmp1 <- unlist(strsplit(li, ">"))[[2]]      
      tmp0 <- unlist(strsplit(tmp1, "/"))
      postinro <- unlist(strsplit(tmp0[[1]], " "))[[1]] 
      cnt <- cnt + 1
      map[[cnt]] <- c(postinro, municipality)
    }
  }

  #map <- ldply(map) # removed due to plyr problems
  map <- data.frame(t(sapply(map, identity)))

  colnames(map) <- c("postal.code", "municipality")
  map$municipality.ascii <- korvaa_skandit(map$municipality)

  # Remove the last row
  map <- map[-nrow(map),]

  map
}





