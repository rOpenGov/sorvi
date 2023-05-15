#' Municipality geometries
#'
#' A simple feature containing the URIs, municipality codes and geometries of 
#' municipalities in time. The starting point and end point of each municipality
#' can be determined by combining polygons1909_2009 with another dataset that
#' contains such information.
#'
#' @format A simple feature with 860 rows and 3 variables:
#' \describe{
#'   \item{x}{Universal Resource Identifier (URI) for each municipality instance in time. For example: http://www.yso.fi/onto/sapo/Maalahti(1908-1972)}
#'   \item{kunta_nro}{Municipality code, a unique 3-digit code (001-999) assigned for each municipality that stays the same as long as the municipality exists. For example: "475"}
#'   \item{geometry}{A single list column with geometries}
#' }
#' @source Original data downloaded from ONKI.fi website on 04 Aug 2022: \url{http://onki.fi/en/browser/overview/sapo}
#' Data attribution: FinnONTO Consortium: \url{https://seco.cs.aalto.fi/projects/finnonto/}
"polygons1909_2009"

#' Municipality dataset
#'
#' A dataset containing information about each instance of individual 
#' municipalities. 
#' 
#' Most of the Finnish municipalities were formed after 1865
#' decree on municipal governance in the country \href{https://fi.wikisource.org/wiki/Asetus_kunnallishallituksesta_maalla_1865}{Asetus kunnallishallituksesta maalla 1865}
#' but the dataset contains some municipalities that were allegedly formed even
#' before that. There are two instances of "illegal municipalities" (Mustio and 
#' Rutakko) that were not recognized as actual municipalities but functioned 
#' as such in late 1800s and early 1900s.
#'
#' @format A simple feature with 1337 rows and 10 variables:
#' \describe{
#'   \item{x}{Universal Resource Identifier (URI) for each municipality instance in time. For example: http://www.yso.fi/onto/sapo/Maalahti(1908-1972)}
#'   \item{kunta_nro}{Municipality code, a unique number assigned for each municipality that stays the same as long as the municipality exists. For example: "475"}
#'   \item{kunta_name_fi}{The official name of the municipality in Finnish. For example: Maalahti}
#'   \item{kunta_name_fi}{The official name of the municipality in Swedish. For example: Malax}
#'   \item{startyear}{Start year of the municipality instance, e.g. founding year. For example: 1865}
#'   \item{endyear}{End year of the municipality instance, can be NA if still valid. For example: 1972}
#'   \item{area}{Area of the municipality, in square kilometers. For example 185.00}
#'   \item{muutos_kuvaus}{A description of the change that occurred at the beginning of this specific instance. For example: "Ahlainen erotettiin Ulvilasta 1908"}
#'   \item{muutos_tyyppi}{Type of the change. For example: "Jakaantuminen"}
#'   \item{muutos_tunniste}{Identifiers for the changes that have happened, which can be used to link past and future instances of municipalities together. For example: "Jakaantuminen1534, Jakaantuminen2"}
#' }
#' @source 
#' Raw data downloaded from ONKI.fi website on 04 Aug 2022: \url{http://onki.fi/en/browser/overview/sapo}
#' Data attribution: FinnONTO Consortium: \url{https://seco.cs.aalto.fi/projects/finnonto/}
#' 
#' Information on abolished municipalities and municipality name changes from Statistics Finland website: \href{https://www2.stat.fi/en/luokitukset/tupa/}{Municipalities and regional divisions based on municipalities in files and classification publications}
"kunnat1865_2021"

