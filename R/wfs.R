#' @title Generic WFS client
#' @description
#' An R6 class for interacting with OGC Web Feature Service (WFS) endpoints.
#' Provides methods to list available feature layers (from GetCapabilities)
#' and to fetch individual layers as \code{sf} objects.
#'
#' @field base_url Base URL of the WFS API, default is NULL
#' @field version Version of the WFS API, default is "1.1.0"
#'
#' @examples
#' \dontrun{
#'   client <- WFSClient$new("https://turku.asiointi.fi/teklaogcweb/wfs.ashx")
#'   client$list_features()
#'   sf_obj <- client$get_feature("GIS:Aanestysalueet", crs = "EPSG:3067")
#' }
#' @importFrom utils URLencode
#' @importFrom sf st_read
#' @importFrom xml2 read_xml xml_find_all xml_text xml_ns
#' @importFrom tibble tibble
#'
#' @export
WFSClient <- R6::R6Class("WFSClient",
                         public = list(
                           base_url = NULL,
                           version = "1.1.0",

                           #' @description Create a new WFS client
                           #' @param base_url Character. The base URL of the WFS service.
                           #' @param version Character. WFS version (default: \code{"1.0.0"}).
                           initialize = function(base_url, version = "1.1.0") {
                             self$base_url <- base_url
                             self$version <- version
                           },

                           #' @description List available feature layers with names, titles, and abstracts.
                           #' @return A tibble with columns \code{name}, \code{title}, \code{abstract}.
                           list_features = function() {
                             url <- sprintf(
                               "%s?service=WFS&version=%s&request=GetCapabilities",
                               self$base_url, self$version
                             )
                             caps <- xml2::read_xml(url)
                             ns <- xml2::xml_ns(caps)

                             names <- xml2::xml_find_all(caps, ".//d1:FeatureType/d1:Name", ns) |> xml2::xml_text()
                             titles <- xml2::xml_find_all(caps, ".//d1:FeatureType/d1:Title", ns) |> xml2::xml_text()
                             abstracts <- xml2::xml_find_all(caps, ".//d1:FeatureType/d1:Abstract", ns) |> xml2::xml_text()

                             tibble::tibble(
                               name = names,
                               title = titles,
                               abstract = ifelse(abstracts == "", NA, abstracts)
                             )
                           },

                           #' @description Fetch a feature collection as an \code{sf} object.
                           #' @param layer Character. The layer (feature type) name.
                           #' @param crs Character. Target coordinate reference system (e.g., \code{"EPSG:3067"}).
                           #' @return An \code{sf} object.
                           get_feature = function(layer, crs = "EPSG:4326") {
                             url <- sprintf(
                               "%s?SERVICE=WFS&VERSION=%s&REQUEST=GetFeature&typeName=%s&srsName=%s",
                               self$base_url, self$version,
                               utils::URLencode(layer, reserved = TRUE),
                               crs
                             )
                             sf::st_read(url, quiet = TRUE)
                           }
                         )
)

#' @title Turku-specific WFS client
#' @description
#' A specialized subclass of \code{WFSClient} that defaults to the City of Turku’s
#' geoservice WFS endpoint.
#'
#' @examples
#' \dontrun{
#'   turku <- TurkuWFS$new()
#'   layers <- turku$list_features()
#'   sf_obj <- turku$get_feature("GIS:Aanestysalueet", crs = "EPSG:3067")
#' }
#'
#' @export
TurkuWFS <- R6::R6Class("TurkuWFS",
                        inherit = WFSClient,
                        public = list(
                          #' @description Create a new Turku WFS client
                          initialize = function() {
                            super$initialize("https://turku.asiointi.fi/teklaogcweb/wfs.ashx")
                          }
                        )
)

#' List available WFS feature layers from Turku's geoservice
#'
#' Queries the WFS `GetCapabilities` endpoint of the City of Turku
#' and returns a tibble of available layers, including the machine-readable
#' name, human-readable title, and optional abstract.
#'
#' @return A tibble with columns: \code{name}, \code{title}, \code{abstract}.
#' @examples
#' \dontrun{
#'   turku_features()
#' }
#' @export
list_features_turku <- function() {
  client <- TurkuWFS$new()
  client$list_features()
}

#' Download a WFS feature layer from Turku's geoservice
#'
#' Retrieves a feature collection as an \code{sf} object from the City of Turku
#' WFS server, using the specified layer name and coordinate reference system.
#'
#' @param layer Character. The feature type (layer name), e.g. \code{"GIS:Aanestysalueet"}.
#'   A full list of layers can be obtained with \code{turku_features()}.
#' @param crs Character. The target coordinate reference system (default: \code{"EPSG:3067"}).
#'
#' @return An \code{sf} object with the requested geometries and attributes.
#' @examples
#' \dontrun{
#'   # List layers
#'   turku_features()
#'
#'   # Download voting districts in EPSG:3067
#'   aanestysalueet <- turku_get("GIS:Aanestysalueet", crs = "EPSG:3067")
#'   plot(sf::st_geometry(aanestysalueet))
#' }
#' @export
get_feature_turku <- function(layer, crs = "EPSG:3067") {
  client <- TurkuWFS$new()
  client$get_feature(layer, crs)
}
