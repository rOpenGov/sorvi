#' @title GitHub issues statistics
#'
#' @description
#' Get statistics about GitHub issues from GitHub API.
#'
#' @param owner Repository owner / organization. Default is "ropengov"
#' @param repo Repository name. Default is "geofi"
#'
#' @return tibble
#'
#' @author Original scripts by Jennifer Bryan (jennybc), function by 
#' Pyry Kantanen <pyry.kantanen@@gmail.com>
#' 
#' @seealso
#' GitHub Issues API documentation: 
#' \url{https://docs.github.com/en/rest/reference/issues}
#' 
#' Original "analyze GitHub stuff with R" repository:
#' \url{https://github.com/jennybc/analyze-github-stuff-with-r}
#'
#' @importFrom gh gh
#' @importFrom purrr map_int map_chr
#' @importFrom tidyr tibble
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#'
#' @export
github_issue_stats <- function(owner = "ropengov", repo = "geofi"){
  issue_list <-
    gh::gh("/repos/:owner/:repo/issues", owner = owner, repo = repo,
           state = "all", since = "2010-09-01T00:00:00Z", .limit = Inf)
  (n_iss <- length(issue_list))
  
  issue_df <- issue_list %>%
    {
      tibble(number = purrr::map_int(.data, "number"),
             id = purrr::map_int(.data, "id"),
             title = purrr::map_chr(.data, "title"),
             state = purrr::map_chr(.data, "state"),
             n_comments = purrr::map_int(.data, "comments"),
             opener = purrr::map_chr(.data, c("user", "login")),
             created_at = purrr::map_chr(.data, "created_at") %>% as.Date(),
             opener_type = purrr::map_chr(.data, "author_association"))
      
    }
  issue_df
}
