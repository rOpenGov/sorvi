#' @title Get IFPI Finland music consumption statistics
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
#' The output has the following columns:
#' \itemize{
#'   \item{rank: Rank on chart}
#'   \item{artist: Artist name}
#'   \item{song_title: Song title}
#'   \item{rank_last_week: Rank on chart on the previous week. RE if the song has
#' re-entered the chart}
#'   \item{chart_woc: Weeks on chart}
#'   \item{week: Week number of observation}
#'   \item{year: Year of observation}
#' }
#'
#' @param channel Options: "radio", "albumit", "singlet", "fyysiset-albumit"
#' @param year year as numeric. Default is NA, returning charts from current 
#' year. Charts are available from 2014 onwards.
#' @param week week as numeric. Default is NA, returning most last possible 
#' charts. Week cannot be the current week.
#' Please note that number of weeks differ between years. 
#' For simplicity's sake valid weeks are set to be between 1 and 53. 
#' Use e.g. `lubridate::isoweek` to check how many weeks a given year has.
#' 
#' @return tibble
#'
#' @importFrom dplyr tibble
#' @importFrom rvest html_elements html_text
#' @importFrom xml2 read_html as_list
#' @importFrom checkmate assert_number assert_string assert_choice
#' @importFrom lubridate isoyear
#' 
#' @author Pyry Kantanen <pyry.kantanen@@gmail.com>
#' 
#' @seealso Original tutorial in \url{https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/}
#'
#' @export
get_ifpi_charts <- function(channel = "radio", year = NA, week = NA){
  
  assert_number(year, na.ok = TRUE, lower = 2014, upper = lubridate::isoyear(Sys.time()))
  assert_number(week, na.ok = TRUE, lower = 1, upper = 53)
  
  assert_string(channel, na.ok = FALSE)
  
  assert_choice(channel,
                choices = c("radio", "albumit", "singlet", "fyysiset-albumit"),
                null.ok = FALSE)
  
  if (is.na(year) && !is.na(week)){
    # Set year as the current year
    message("Year set to NA. Downloading charts for current year")
    year <- lubridate::isoyear(Sys.time())
  }

  if (!is.na(year) && is.na(week)){
    stop("Cannot return charts for whole year, please select a valid week")
  }

  base_url <- "https://www.ifpi.fi/lista"

  if (!is.na(year) && !is.na(week)){
    url <- paste(base_url, channel, year, week, sep = "/") 
  } else {
    # most recent charts
    url <- paste(base_url, channel, sep = "/")
  }
  
  # General example
  # Read the HTML code from the website
  webpage <- xml2::read_html(url)
  
  # Use CSS selectors to scrape chart positions for chosen week
  rank_data_html <- rvest::html_elements(webpage,'.chart-position')
  
  # Convert raw html to text
  rank_data <- rvest::html_text(rank_data_html)
  
  # Convert rank_data strings to numerical
  rank <- as.numeric(rank_data)
  
  # Artist name
  artist_data_html <- rvest::html_elements(webpage,'.chart-artist')
  artist <- rvest::html_text(artist_data_html)
  
  # Song title
  song_title_data_html <- rvest::html_elements(webpage,'.chart-title')
  song_title <- rvest::html_text(song_title_data_html)
  
  # Position on chart last week
  chart_change_data_html <- rvest::html_elements(webpage,'.chart-change')
  chart_change_list <- xml2::as_list(chart_change_data_html)
  
  # Chart change node is a mess so this custom for-loop is needed
  rank_last_week <- rep(NA, length(chart_change_list))
  for (i in 1:length(chart_change_list)){
    if (length(chart_change_list[[i]]) == 3){
      if (attributes(chart_change_list[[i]]$div)$title == "Samalla sijalla"){
        last_position <- rank[i]
      } else if (attributes(chart_change_list[[i]]$div)$title == "Paluu listalle"){
        last_position <- "RE"
      } else if (attributes(chart_change_list[[i]]$div)$title == "Uusi"){
        last_position <- "UUSI"
      }
    } else if (length(chart_change_list[[i]]) == 5){
      if (attributes(chart_change_list[[i]]$div)$title == "Nousussa"){
        last_position <- as.numeric(chart_change_list[[i]][4]$div[[1]])
      } else if (attributes(chart_change_list[[i]]$div)$title == "Viime viikolla"){
        last_position <- as.numeric(chart_change_list[[i]][2]$div[[1]])
      } else {
        last_position <- NA
      }
    } else {
      last_position <- NA
    }
    rank_last_week[i] <- last_position    
  }
  
  # Weeks on chart
  chart_woc_data_html <- rvest::html_elements(webpage,'.chart-woc')
  chart_woc <- as.numeric(rvest::html_text(chart_woc_data_html))
  
  if (is.na(year) || is.na(week)){
    week_year_html <- rvest::html_elements(webpage,'.selector-toggle')
    week_year <- rvest::html_text(week_year_html)
    week <- regmatches(week_year, regexpr("[0-9]+(?=\\/)", week_year, perl = TRUE))
    year <- regmatches(week_year, regexpr("(?<=\\/)[0-9]+", week_year, perl = TRUE))
  }
  
  final_output <- dplyr::tibble(rank, artist, song_title, rank_last_week, chart_woc, week, year)
  final_output
}