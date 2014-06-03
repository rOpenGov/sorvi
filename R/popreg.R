#' Retrieve population register data
#'
#' Retrieves municipality data from population register. 
#' The url should be changed when there are updates.
#'
#' @param url String specifying the URL containing the population register data.
#' @return data.frame with municipality information.
#' @export
#' @importFrom XML readHTMLTable
#' @references
#' See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{df <- get_population_register()}
#' @keywords utilities

get_population_register <- function (url = "http://vrk.fi/default.aspx?docid=5127&site=3&id=0") {

  message(paste("Downloading VRK 2011 data from", url, " - for more up-to-date information, see http://vrk.fi"))

  # Read tables from the website
  tables <- readHTMLTable(url)

  # Population is in table 4
  pop <- tables[[4]]

  # Preprocess the data
  # Remove Swedish header and summary row
  pop <- pop[-c(1, (nrow(pop):(nrow(pop)-1))),] 

  # Pick informative columns 
  pop <- pop[, c(1, 4, 5, 6)]
  colnames(pop) <- c("Municipality", "Male", "Female", "Total")

  # Separate municipality (kunta) code and Finnish/Swedish names
  parser <- function (x) { 
    x <- as.character(x)
    x <- unlist(strsplit(unlist(strsplit(x, "\r\n")), " - "))
    x <- unname(strstrip(x))  
  }
  nimet <- t(sapply(pop[[1]], function (x) {parser(x)}))

  # Convert counts to numeric
  pop <- data.frame(apply(data.frame(pop[, -1]), 2, function (x){as.numeric(as.character(x))}))

  # Store all in data.frame
  df <- data.frame(list(nimet, pop))
  colnames(df)[1:3] <- c("Koodi", "Kunta", "Kommun")

  # Harmonize municipality names 
  df$Kunta <- convert_municipality_names(df$Kunta)

  # Convert municipality names to UTF-8
  #rownames(df) <- iconv(as.character(df$Kunta), from = "latin1", to = "UTF-8")
  rownames(df) <- df$Kunta

  # Order municipalities alphabetically
  df <- df[sort(rownames(df)), ]

  df

}

