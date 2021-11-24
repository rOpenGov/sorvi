#' @title Get CRAN download statistics
#'
#' @description 
#' Produces a tibble or a visualization of package download statistics.
#'
#' @details 
#' This function is intended for easy retrieval and visualization of rOpenGov 
#' package download statistics from CRAN. It is an evolution of an R script
#' by antagomir. As such it retains some features that were present in
#' the original R script and were deemed useful for our use case and it is not
#' intended for generalized use.
#'
#' @param pkgs Package name(s). Default is "all", which prints statistics for
#' all rOpenGov packages. You can also input 1 or more package names as a 
#' vector.
#' @param output "tibble" (default) or "plot". With sum "by_month" and
#' "by_year" "plot" outputs a line chart, with "total" it outputs a
#' bar chart.
#' @param sum "by_month" (default), "by_year" or "total"
#' @param plot.scale integer, default is 11. Smaller numbers decrease the size of
#' plot elements, larger numbers make them larger.
#' @param use.cache Cache downloaded statistics. Default is TRUE
#'
#' @return sf object
#'
#' @importFrom dplyr group_by summarise filter arrange %>% desc
#' @importFrom ggplot2 ggplot geom_line geom_label geom_bar 
#' @importFrom ggplot2 aes theme theme_set element_text
#' @importFrom dlstats cran_stats
#' @importFrom rlang .data
#' 
#' @examples
#' \dontrun{
#' df <- cran_downloads(pkgs = "eurostat", sum = "total", use.cache = FALSE)
#' kable(df)
#' 
#' ## Compare two packages
#' p1 <- cran_downloads(pkgs = "eurostat", sum = "by_year", output = "plot")
#' p2 <- cran_downloads(pkgs = "osmar", sum = "by_year", output = "plot")
#' gridExtra::grid.arrange(p1, p2, nrow = 2)
#' }
#'
#' @author Leo Lahti, Pyry Kantanen <pyry.kantanen@@gmail.com>
#'
#' @export
cran_downloads <- function(pkgs = "all", 
                           output = "tibble", 
                           sum = "by_month",
                           plot.scale = 11,
                           use.cache = TRUE){
  
  # All rOpenGov packages: Edit this list if you want to add or remove packages
  if (identical(pkgs, "all")){
    pkgs <- sort(unique(c(
      "enigma",  
      "eurostat",
      "federalregister",  
      "geofi",  
      "hansard",
      "helsinki",
      "hetu",
      "iotables",      
      "osmar",  
      "pollstR",
      "psData",  
      "pxweb",  
      "recalls",
      "regions",  
      "RPublica",  
      "rsunlight",  
      "rtimes",
      "sorvi",
      "sotkanet"
    )))
  } else if (is.character(pkgs)){
    pkgs <- pkgs
  } else {
    message("Give valid package input")
    return(NULL)
  }
  
  x <- dlstats::cran_stats(pkgs, use_cache = use.cache)
  if (is.null(x)){
    message("Input valid packages")
    return(NULL)
  }
  
  if (!is.numeric(plot.scale)){
    message("Input valid plot_scale value (integer)")
    return(NA)
  } else {
    ggplot2::theme_set(
      ggplot2::theme_bw(base_size = plot.scale)
    ) 
  }
  
  x$year <- as.numeric(format(as.Date(x$start), format="%Y"))
  x$month <- as.numeric(gsub("^0+", "", format(as.Date(x$start), format="%m")))
  # x <- dplyr::rename(x, Package = package)
  
  if (sum == "by_month"){
    x <- x 
  } else if (sum == "by_year"){
    x <- x %>% 
      group_by(.data$year, .data$package) %>%
      summarise(n = sum(.data$downloads)) %>%
      # Exclude current year (non-complete)
      filter(.data$year < as.numeric(format(Sys.time(), "%Y"))) 
  } else if (sum == "total"){
    x <- x %>% 
      group_by(.data$package) %>%
      summarise(total = sum(.data$downloads)) %>% 
      arrange(desc(.data$total))
    } else {
    message("Input valid sum parameter: 'by_month', 'by_year' or 'total'")
    return(NULL)
  }
  
  if (output == "tibble"){
    return(x)
  } else if (output == "plot" && sum == "by_month"){
    plot <- ggplot(x, aes(x = .data$end, 
                          y = .data$downloads, 
                          group=.data$package, 
                          color=.data$package)) +
                  geom_line(size = 3) + 
                  geom_label(aes(label=.data$downloads)) 
  } else if (output == "plot" && sum == "by_year") {
    plot <- ggplot(x, aes(x = .data$year, 
                          y = .data$n, 
                          group=.data$package, 
                          color=.data$package)) +
                  geom_line(size = 3) + 
                  geom_label(aes(label=.data$n)) 
  } else if (output == "plot" && sum == "total"){
    # Make x axis text angle 90 for increased legibility
    plot_angle <- ifelse(length(pkgs) > 5, 90, 0)
    
    plot <- ggplot(x, aes(x = .data$package, y = .data$total, fill= .data$package)) +
      geom_bar(stat="identity") +
      theme(axis.text.x = element_text(angle = plot_angle))
  }
  return(plot)
}
