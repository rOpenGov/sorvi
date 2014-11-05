# When one has weighed the sun in the balance, and measured the
# steps of the moon, and mapped out the seven heavens star by star,
# there still remains oneself. Who can calculate the orbit of his own
# soul? - Oscar Wilde 


#' Conversions between municipality codes and names
#'
#' @param ids NULL 
#' @param municipalities NULL 
#'
#' @return Depending on the input. Converted id or name vector, or full conversion table.
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples  \dontrun{conversion.table <- convert_municipality_codes()}
#' @keywords utilities

convert_municipality_codes <- function (ids = NULL, municipalities = NULL) {
 
  # Reading municipality information from the web
  df <- get_municipality_info_mml()	

  conversion.table <- df[, c("Kunta", "Kunta.FI")]
  names(conversion.table) <- c("id", "name")

  conversion.table$id <- as.character(conversion.table$id)
  conversion.table$name <- as.character(conversion.table$name)

  #write.csv(conversion.table, file = "../inst/extdata/conversiontable.tab", quote = FALSE, row.names =FALSE)
  #conversion.table <- read.csv(paste(system.file("extdata", package = "sorvi"), 
  # 		     	"/conversiontable.tab", sep = ""))

  conversion.table$id <- as.character(conversion.table$id)
  conversion.table$name <- as.character(conversion.table$name)

  res <- conversion.table

  if (!is.null(ids)) {
    res <- conversion.table$name[match(as.character(ids), conversion.table$id)]
    names(res) <- ids
  } else if (!is.null(municipalities)) {
    res <- conversion.table$id[match(as.character(municipalities), conversion.table$name)]
    names(res) <- municipalities
  } 

  res

}

#' fi.en.maakunnat data documentation 
#'
#' Mappings between Finnish and English province (maakunta) names
#'
#' @name fi.en.maakunnat
#' @docType data
#' @author Leo Lahti \email{louhos@@googlegroups.com} 
#' @usage #translations <- load_sorvi_data("translations")
#' @format list
#' @keywords data
NULL



#' Get information of Finnish provinces.
#'
#' @param ... Arguments to be passed
#' @return A data frame. With the following entries: Maakunta: province; Pinta-ala: area; Vakiluku: population; Vaestotiheys: population density
#' @export 
#' @importFrom XML readHTMLTable
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tab <- get_province_info_wikipedia()}
#' @keywords utilities

get_province_info_wikipedia <- function (...) {

  url <- "http://fi.wikipedia.org/wiki/V%C3%A4est%C3%B6tiheys"
  message(paste("Downloading data from", url))

  # Read tables from the website
  tables <- readHTMLTable(url)

  # Population density in regions (maakunnat)
  tab <- tables[[1]][, c(1, 4)]		

  names(tab) <- c("Province", "PopulationDensity")
  tab$PopulationDensity <- as.numeric(gsub(",", ".", tab$PopulationDensity))

  tab

}


#' Convert municipality names into standard versions harmonized within the package
#'
#' @param municipality.names municipality names to convert
#' @return standardized municipality names
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tmp <- convert_municipality_names(municipality.names)}
#' @keywords internal
convert_municipality_names <- function (municipality.names) {
			 
  # Mantta-Vilppula -> Mantta			 
  municipality.names <- gsub("M\xe4ntt\xe4", "M\xe4ntt\xe4-Vilppula", municipality.names)
  municipality.names <- gsub("Mantta", "M\xe4ntta-Vilppula", municipality.names)
  municipality.names <- gsub("-Vilppula-Vilppula", "-Vilppula", municipality.names)
  municipality.names <- gsub("-Vilppula", "", municipality.names)

  municipality.names[grep("-Turunmaa", municipality.names)] <- "Parainen"

  municipality.names <- gsub("-Tavastkyro", "", municipality.names)
  municipality.names <- gsub("n kunta", "", municipality.names)
  municipality.names <- gsub("Maarianhamina - Mariehamn", "Maarianhamina", municipality.names)

  municipality.names <- gsub("Koski.Tl", "Koski Tl", municipality.names)

  municipality.names

}


#' Get information of Finnish municipalities from Land Survey Finland.
#' (C) Maanmittauslaitos MML 2013. For details, see help(GetShapeMML).
#' 
#' @return A data frame with municipality data
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tab <- get_municipality_info_mml()}
#' @keywords utilities

get_municipality_info_mml <- function () {

  # Load information table from Maanmittauslaitos
  map.id  <- "Yleiskartta-1000"
  data.id <- "HallintoAlue_DataFrame"

  # DO NOT SET sp <- NULL HERE; this will return NULL for the function
  # IN CONTRAST TO INTENDED OUTPUT!!!
  sp <- NULL	

  url <- paste(ropengov_storage_path(), "mml/rdata/", sep = "")
  filepath <- paste(url, map.id, "/", data.id, ".RData", sep = "")

  message(paste("Loading ", filepath, ". (C) MML 2013. Converted to RData shape object by Louhos. For more information, see https://github.com/avoindata/mml/", sep = ""))

  # Direct downloads from Github:
  # library(RCurl)
  # dat <- read.csv(text=getURL("link.to.github.raw.csv"))

  #load(url(filepath), envir = .GlobalEnv) # Returns a shape file sp
  load(url(filepath)) # Returns a data frame df

  # Vaasa and Hammarland have duplicated entries where only the 
  # enclave column differs. Remove that column, remove duplicated rows
  # and return the rest.
  df <- df[, -grep("Enklaavi", colnames(df))]
  df <- df[!duplicated(df), ]

  # Use harmonized municipality names as row.names
  # harmonized to match other data sets where 
  # slightly different versions of these names may be in use
  rownames(df) <- convert_municipality_names(df$Kunta.FI)

  # Order municipalities alphabetically
  df <- df[sort(rownames(df)), ]

  df

}


#' List province for each municipality in Finland.
#' @aliases municipality2province
#' @param municipalities NULL 
#' @param municipality.info NULL 
#' @return Mapping vector listing the province for each municipality in Finland.
#' @export 
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples 
#' # Info table for municipalities:
#' # municipality.info <- get_municipality_info_mml()
#' # List all municipalities: 
#' # all.municipalities <- as.character(municipality.info$Kunta) 
#' # Pick province for given municipalities:
#' # mapping between municipalities (kunta) and provinces (maakunta)
#' # m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku")) 
#' # Speed up by providing predefined table of municipality info:
#' # m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku"), municipality.info)
#' @keywords utilities

municipality_to_province <- function (municipalities = NULL, municipality.info = NULL) {

  if (is.null(municipality.info)) { 
    municipality.info <- get_municipality_info_mml()
    #municipality.info <- rownames(get_municipality_info_statfi())
  }

  m2p <- as.character(municipality.info$Maakunta.FI)
  names(m2p) <- as.character(municipality.info$Kunta.FI)

  if (!is.null(municipalities)) {
    m2p <- m2p[as.character(municipalities)]
  }

  m2p

}


