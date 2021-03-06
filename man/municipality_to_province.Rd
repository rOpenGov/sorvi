% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/municipality_to_province.R
\name{municipality_to_province}
\alias{municipality_to_province}
\alias{municipality2province}
\title{Municipality-Province Mappings}
\usage{
municipality_to_province(municipalities = NULL, municipality.info = NULL)
}
\arguments{
\item{municipalities}{NULL}

\item{municipality.info}{NULL}
}
\value{
Mapping vector listing the province for each municipality in Finland.
}
\description{
List province for each municipality in Finland.
}
\examples{
# Info table for municipalities:
# municipality.info <- get_municipality_info_mml()
# List all municipalities: 
# all.municipalities <- as.character(municipality.info$Kunta) 
# Pick province for given municipalities:
# mapping between municipalities (kunta) and provinces (maakunta)
# m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku")) 
# Speed up by providing predefined table of municipality info:
# m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku"), municipality.info)
}
\references{
See citation("sorvi")
}
\author{
Leo Lahti \email{louhos@googlegroups.com}
}
\keyword{utilities}
