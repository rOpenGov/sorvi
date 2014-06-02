# To call in the statistician after the experiment is done may be no more
# than asking him to perform a post-mortem examination: he may be able to
# say what the experiment died of. ~ Sir Ronald Aylmer Fisher

#' ropengov_storage_path
#'
#' Arguments:
#'   ... Arguments to pass
#'
#' Return:
#' @return URL for Louhos data
#'
#' @examples url <- ropengov_storage_path()
#'
#' @export
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords utilities
ropengov_storage_path <- function () {
  # Louhos data is stored in Github avoindata repo: 
  # https://github.com/avoindata/ which is 
  # mirrored on Datavaalit server
  #"http://www.datavaalit.fi/storage/avoindata/"

  # OKF Finland Server is now running daily cron jobs to
  # update the avoindata Github repository
  "http://data.okf.fi/ropengov/avoindata/"
}

#' load_sorvi_data
#'
#' Arguments:
#' @param data.id data ID to download (suffix before .rda). Investigate the contents of the url path to check data.ids
#' @param verbose verbose 
#'
#' Return:
#' @return translations 
#'
#' @examples # translations <- load_sorvi_data("translations")
#'
#' @export
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords utilities

load_sorvi_data <- function(data.id, verbose = TRUE) {

  # Circumvent warnings
  fi.en.maakunnat <- NULL
  kuntarajat.maa.shp <- NULL

  url <- ropengov_storage_path()
  filepath <- paste(url, "/louhos/", data.id, ".rda", sep = "")
  if (verbose) {message(paste("Loading ", filepath, sep = ""))}
  #load(url(filepath), envir = .GlobalEnv)  
  load(url(filepath))  
  #print(kuntarajat.maa.shp)
  if (data.id == "translations") {return(fi.en.maakunnat)}
  if (data.id == "kuntarajat.maa.shp") {return(kuntarajat.maa.shp)}

}


#' Replace special characters with standard ones.
#'
#' @param s string from which the special chars should be removed
#' @return string with special chars replaced by standard ones
#' @export
#' @note iconv function provides better tools for these purposes and is now the main tool
#' This function is kept for compatibility with the older versions.
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples korvaa_skandit("my.string.here") # if no, special chars, the same string is returned
#' @keywords utilities

korvaa_skandit <- function (s) {
 
  sclass <- class(s)

  s <- gsub("\\xe4", "a", s)
  s <- gsub("\\xC4", "A", s)
  s <- gsub("\\xD6", "O", s)
  s <- gsub("\\xf6", "o", s)
  s <- gsub("\\xE5", "a", s)
  s <- gsub("\\U3e34633c", "A", s)

  # Return a factor if the original input vector was a factor
  if (sclass == "factor") {
    s <- factor(s)
  } 

  s

}

#' Check if the given object is an url string
#'
#' Arguments:
#'  @param s input object to check
#'
#' Returns:
#'  @return TRUE/FALSE indicating whether the input string is a valid URL.
#'
#' @export
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples is_url("http://aa.px")
#' @keywords utilities
is_url <- function (s) {
  (class(s) == "character" && substr(s,1,7) == "http://")
}




#' Remove spaces from a string (single string or vector/list of strings).
#'
#' @param s string or vector/list of strings
#' @return string without spaces
#' @export
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples strstrip("a b") # returns "ab"
#' @keywords utilities


strstrip <- function (s) {

  if (length(s) == 1) {
    stripped <- strstrip_single(s)
  } else {
    stripped <- sapply(s, strstrip_single)
  }

  stripped
}


#' Remove spaces from a single string
#'
#' @param s string
#' @return string without spaces
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords internal

strstrip_single <- function (s) {

  # Remove spaces from a string

  # strip string i.e. remove spaces from the beginning and end
  while (substr(s,1,1)==" ") {
    s <- substr(s,2,nchar(s))
  }
  while (substr(s,nchar(s),nchar(s))==" ") {
    s <- substr(s,1,nchar(s)-1)
  }
  s
}

#' strip string i.e. remove spaces from the beginning and end
#' @param s string or character vector
#'
#' @return stripped string
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples strip(c("s ", " a")) 
#' @keywords utilities
strip <- function (s) {

  ss <- c()
  for (i in 1:length(s)) {
    si <- s[[i]]

    # strip string i.e. remove spaces from the beginning and end
    while (substr(si,1,1)==" ") {
      si <- substr(si, 2, nchar(si))
    }
    while (substr(si, nchar(si), nchar(si))==" ") {
      si <- substr(si, 1, nchar(si) - 1)
    }
    ss[[i]] <- si
  }
  ss
}

