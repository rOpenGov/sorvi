#' @title Get CRAN download statistics
#'
#' @description Produces a tibble or a visualization of package download
#'    statistics.
#'
#' @param pkgs Package name(s)
#' @param output "tibble" or "plot"
#' @param sum "by_month", "by_year" or "total"
#' @param plot.scale integer, default is 10. Smaller numbers decrease the size of
#'    plot elements, larger numbers make them larger.
#' @param use.cache Cache downloaded statistics. Default is TRUE
#'
#' @return sf object
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom dlstats cran_stats
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
  
  # ropengov all
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
    plot <- ggplot(x, aes(x = .data$package, y = .data$total, fill= .data$package)) +
      geom_bar(stat="identity")
  }
  return(plot)
}
  
  # if (sum == "by_year"){
  #   # Downloads per year
  #   x2 <- x %>% group_by(year, Package) %>%
  #     summarise(n = sum(downloads)) %>%
  #     # Exclude current year (non-complete)
  #     filter(year < as.numeric(format(Sys.time(), "%Y"))) 
  #   
  #   if (output == "tibble"){
  #     return(x2)
  #   } else if (output == "plot"){
  #     p2 <- ggplot(x2, aes(year, n, group=Package, color=Package)) +
  #       geom_line(size = 3) +
  #       scale_y_log10() +
  #       geom_label(aes(label=n))
  #     
  #     return(p2)
  #   }
  # }
  # 
  # if (sum == "total"){
  #   df <- x %>% 
  #     group_by(Package) %>%
  #     summarise(total = sum(downloads)) %>% 
  #     arrange(desc(total))
  #   
  #   if (output == "tibble"){
  #     return(df)
  #   } else if (output == "plot"){
  #     p3 <- ggplot(df, aes(year, n, group=Package, color=Package)) +
  #       geom_line(size = 3) +
  #       scale_y_log10() +
  #       geom_label(aes(label=n))
  #     
  #     return(p3)
  #   }
  # }
# }

# These rOpenGov packages caused problems, probably not on CRAN
#digitransit
#dkstat
#europarl
#fmi2
#mpg
#ogdindiar
#openthl
#rqog
#rwfs
#usbroadband
#vipunen

# gridExtra::grid.arrange(p1, p2, nrow = 2)
# 
# 
# 
# df2020 <- x %>% filter(year == 2020) %>%
#   group_by(Package, month) %>%
#   summarise(total = sum(downloads),
#             monthly = sum(downloads)/n()) %>%
#   select(Package, total, monthly)  %>%
#   arrange(desc(total))
# 
# df2020total <- x %>% filter(year == 2020) %>%
#   group_by(Package) %>%
#   summarise(total = sum(downloads)) %>%
#   arrange(desc(total))
# 
# 
# df2020$Package <- factor(df2020$Package, levels = rev(unique(df2020$Package)))
# p <- ggplot(df2020, aes(x = Package, y = total)) +
#   geom_bar(stat = "identity") +
#   labs(x = "", y = "Downloads (2020)",
#        title = paste0("CRAN downloads (", sum(df2020$total), ")")) + 
#   coord_flip() 
# print(p)
# 
# p3 <- ggplot(x, aes(x = start, y = downloads, color = Package)) +
#   geom_point() +
#   geom_smooth()
# print(p3)

#png("ropengov2020dl.png")
#print(p)
#dev.off()
