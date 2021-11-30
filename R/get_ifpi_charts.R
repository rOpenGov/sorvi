#' @title Get CRAN download statistics
#'
#' @description 
#' Download chart position data from ifpi.fi
#'
#' @details 
#' Web scraping function that is inspired by Sauravkaushik8 Kaushik's
#' blog post "Beginner's Guide on Web Scraping in R" on analyticsvidhya.com. 
#' Downloads chart data from Musiikkituottajat - IFPI Finland ry website.
#' Please note that this function works only with IFPI Finland website!
#'
#' @param channel Options: "radio", "albumit", "singlet", "fyysiset-albumit"
#' @param year year as numeric, default is 2020
#' @param week week as numeric, default is 50. Please note that number of weeks 
#' differ between years. For simplicity's sake valid weeks are set to be 
#' between 1 and 53. Use e.g. `lubridate::isoweek` to check how many weeks a
#' given year has.
#' 
#' @return tibble
#'
#' @importFrom dplyr tibble
#' @importFrom rvest html_elements html_text
#' @importFrom xml2 read_html as_list
#' @importFrom assertthat assert_that is.number is.string
#' 
#' @author Pyry Kantanen <pyry.kantanen@@gmail.com>
#' 
#' @seealso Original tutorial in \url{https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/}
#'
#' @export
get_ifpi_charts <- function(channel = "radio", year = 2020, week = 50){
  
  assert_that(assertthat::is.number(year))
  assert_that(year >= 2014)
  assert_that(assertthat::is.number(week))
  assert_that(week >= 1 && week <= 53)
  assert_that(assertthat::is.string(channel))
  assert_that(channel %in% c("radio", "albumit", "singlet", "fyysiset-albumit"))
  
  base_url <- "https://www.ifpi.fi/lista"
  
  if (is.numeric(year) && is.numeric(week)){
    url <- paste(base_url, channel, year, week, sep = "/") 
  } else {
    url <- paste(base_url, channel, sep = "/")
  }
  
  #Reading the HTML code from the website
  webpage  <-  xml2::read_html(url)
  
  # sTEP 2: Using CSS selectors to scrap the rankings section
  rank_data_html  <-  rvest::html_elements(webpage,'.chart-position')
  
  # Step 3; Converting the ranking data to text
  rank_data  <-  rvest::html_text(rank_data_html)
  
  # Step 4: Data-Preprocessing: Converting rankings to numerical
  rank_data <- as.numeric(rank_data)
  
  # Artist name
  artist_data_html <- rvest::html_elements(webpage,'.chart-artist')
  artist_data  <-  rvest::html_text(artist_data_html)
  
  # Song title
  song_title_data_html  <-  rvest::html_elements(webpage,'.chart-title')
  song_title_data  <-  rvest::html_text(song_title_data_html)
  
  # Position on chart last week
  chart_change_data_html <- rvest::html_elements(webpage,'.chart-change')
  chart_change_list <- xml2::as_list(chart_change_data_html)
  
  rank_last_week <- rep(NA, length(chart_change_list))
  for (i in 1:length(chart_change_list)){
    if (length(chart_change_list[[i]]) == 3){
      if (attributes(chart_change_list[[i]]$div)$title == "Samalla sijalla"){
        last_position <- rank_data[i]
      } else if (attributes(chart_change_list[[i]]$div)$title == "Paluu listalle"){
        last_position <- NA
      }
    } else if (length(chart_change_list[[i]]) == 5){
      if (attributes(chart_change_list[[i]]$div)$title == "Nousussa"){
        last_position <- as.numeric(chart_change_list[[i]][4]$div[[1]])
      } else if (attributes(chart_change_list[[i]]$div)$title == "Viime viikolla"){
        last_position <- as.numeric(chart_change_list[[i]][2]$div[[1]])
      }
    } else {
      last_position <- NA
    }
    rank_last_week[i] <- last_position    
  }
  
  # Weeks on chart
  chart_woc_data_html <- rvest::html_elements(webpage,'.chart-woc')
  chart_woc_data  <-  as.numeric(rvest::html_text(chart_woc_data_html))
  
  final_output <- dplyr::tibble(rank_data, artist_data, song_title_data, rank_last_week, chart_woc_data, week, year)
  final_output
}