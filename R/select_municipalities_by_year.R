#' @title Select Municipalities by Year
#' @description From a larger dataset containing historical municipalities, 
#' pick a certain year and return an output that contains the most recent 
#' information on each municipality.
#' @param year a year between 1865-2020
#' @param type either "data.frame" or "sf"
#' @return a data.frame or sf object
#' @details See dataset "kunnat1865_2021"
#' @importFrom dplyr group_by arrange filter left_join
#' @importFrom magrittr %>%
#' @importFrom checkmate assert_integer assert_choice
#' @importFrom sf st_is_empty st_as_sf
#' @source Data attribution: FinnONTO Consortium: \url{https://seco.cs.aalto.fi/projects/finnonto/}
#' @export
#' @author Pyry Kantanen
get_municipalities <- function(year = 2002, type = "data.frame") {
  checkmate::assert_double(year, lower = 1865, upper = 2020)
  checkmate::assert_choice(type, choices = c("data.frame", "sf"))

  kunnat1865_2021 <- sorvi::kunnat1865_2021
  polygons1909_2009 <- sorvi::polygons1909_2009
  full_dataset_with_sf <- dplyr::left_join(kunnat1865_2021, polygons1909_2009, by = c("x", "kunta_nro"))
  full_dataset_with_sf <- full_dataset_with_sf[,c("x", "kunta_nro", "kunta_name_fi", "kunta_name_sv", "startyear", "endyear", "area", "muutos_tyyppi", "geometry")]
  full_dataset_with_sf <- sf::st_as_sf(full_dataset_with_sf)
  # This dataset will have only cases that are valid for given year
  # Since there should be no overlapping years in the dataset, so that a specific
  # municipality would have valid multiple valid instances for a given year,
  # this should return a data frame that contains a single instance of each municipality
  filtered_dataset <- full_dataset_with_sf %>%
    group_by(.data$kunta_nro) %>%
    arrange(.data$kunta_nro, desc(.data$startyear)) %>%
    filter(.data$startyear <= year & .data$endyear >= year | .data$startyear < year & is.na(.data$endyear))

  for (i in 1:nrow(filtered_dataset)){
    if (st_is_empty(filtered_dataset[i,])){
      starting_year <- as.numeric(filtered_dataset[i,]$startyear)
      single_municipality_timeworm <- full_dataset_with_sf[which(full_dataset_with_sf$kunta_nro == filtered_dataset$kunta_nro[i]),]
      single_municipality_timeworm <- single_municipality_timeworm[which(single_municipality_timeworm$endyear < starting_year),]
      # This loop will take the first available geometry from a single municipality timeworm
      if (nrow(single_municipality_timeworm) > 0){
        for (j in 1:nrow(single_municipality_timeworm)){
          if (!st_is_empty(single_municipality_timeworm[j,])){
            filtered_dataset$geometry[i] <- single_municipality_timeworm$geometry[j]
            break
          }
        }
      }
    }
  }
  
  
  return(filtered_dataset)
}
