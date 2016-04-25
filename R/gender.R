#' @title Finnish name-gender mappings
#' @description Finnish name-gender mappings from the Finnish
#' population register (VRK 3/2016).
#' @param download If TRUE, the data downloaded from the original
#' source. Otherwise, a readily preprocessed version from the sorvi R
#' package is used.
#' @return A data_frame with the field "name" (first name), followed
#' by the population frequencies and population counts for that name.
#' @author Leo Lahti \email{leo.lahti@iki.fi}
#' @examples gender_FI <- get_gender_table_fi()
#' @export
#' @details Information from the Finnish Population register. All
#' first names for living Finnish citizens that live in Finland and
#' abroad. Only names with frequency n>10 are included.
#'  Source: avoindata.fi service and Vaestorekisterikeskus (VRK).
#'  URL: https://www.avoindata.fi/data/fi/dataset/none
#'  Version: 3/2016
#'  Data license CC-BY 4.0
#' The data was downloaded with this function as sorvi::get_gender_table_fi()
#' and integrated in the sorvi package. The frequencies of male/female names
#' are added after the download as some names occur for both genders.
#' @references See cite("sorvi")
#' @keywords data
get_gender_table_fi <- function (download = FALSE) {

  if (download) {

    name <- gender <- NULL

    f <- "https://www.avoindata.fi/dataset/57282ad6-3ab1-48fb-983a-8aba5ff8d29a/resource/53667ad0-538c-4686-86e0-361c129dcd95/download/HNimidatan-avaaminen2016JulkaistavatMiehetkaikkietunimet2016.csv"
    male <- read.csv(f, sep = ";", fileEncoding = "latin1", stringsAsFactors = FALSE)
    names(male) <- c("name", "n")
    male$gender <- "male"
  
    f <- "https://www.avoindata.fi/dataset/57282ad6-3ab1-48fb-983a-8aba5ff8d29a/resource/cc4dc77d-a80f-423f-b4ef-07394943d7c3/download/HNimidatan-avaaminen2016JulkaistavatNaisetkaikkietunimet2016.csv"
    female <- read.csv(f, sep = ";", fileEncoding = "latin1", stringsAsFactors = FALSE)
    names(female) <- c("name", "n")
    female$gender <- "female"

    tab <- as_data_frame(rbind(male, female))

    tab$name <- factor(tab$name)
    tab$gender <- factor(tab$gender, levels = c("female", "male"))
    tab$n <- as.numeric(gsub(" ", "", tab$n))

    tab2 <- NULL
    for (nam in sort(unique(tab$name))) {
      # Frequencies
      nm <- subset(tab, name == nam & gender == "male")$n
      nf <- subset(tab, name == nam & gender == "female")$n
      if (length(nm)==0) {nm <- 0}
      if (length(nf)==0) {nf <- 0}    
      # Fractions (probabilities)
      fm <- nm/(nm + nf)
      ff <- nf/(nm + nf)
      x <- c(name = nam,
        male.freq = fm, female.freq = ff,
        male.count = nm, female.count = nf,
	total.count = nm + nf)

      tab2 <- rbind(tab2, x)
    }
    rownames(tab2) <- NULL  
    tab3 <- data.frame(tab2)
    tab3$name <- factor(tab3$name)
    for (k in 2:ncol(tab3)) {
      tab3[, k] <- as.numeric(as.character(tab3[,k]))
    }
    gender_FI <- tab3

    # write.csv(gender_FI, fileEncoding = "UTF-8", file = "../inst/extdata/gender_FI.csv", quote = FALSE, row.names = FALSE)

  } else {

    f <- system.file("extdata/gender_FI.csv", package = "sorvi")
    gender_FI <- read.csv(f, header = TRUE, fileEncoding = "UTF-8")
   
  }

  gender_FI

}



