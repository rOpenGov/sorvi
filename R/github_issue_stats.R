#' @title GitHub issues statistics
#'
#' @description Get statistics about GitHub issues from GitHub API.
#'
#' @param owner Repository owner / organization
#' @param repo Repository name
#'
#' @return tibble
#'
#' @import gh
#' @import tidyr
#' @importFrom purrr map_int map_chr
#' @import curl
#'
#' @author Jennifer Bryan, small modifications by Pyry Kantanen <pyry.kantanen@@gmail.com>
#'
#' @export
gh_issue_stats <- function(owner = "ropengov", repo = "geofi"){
  issue_list <-
    gh::gh("/repos/:owner/:repo/issues", owner = owner, repo = repo,
       state = "all", since = "2010-09-01T00:00:00Z", .limit = Inf)
  (n_iss <- length(issue_list))
  
  issue_df <- issue_list %>%
    {
      data_frame(number = purrr::map_int(., "number"),
                 id = purrr::map_int(., "id"),
                 title = purrr::map_chr(., "title"),
                 state = purrr::map_chr(., "state"),
                 n_comments = purrr::map_int(., "comments"),
                 opener = purrr::map_chr(., c("user", "login")),
                 created_at = purrr::map_chr(., "created_at") %>% as.Date(),
                 opener_type = purrr::map_chr(., "author_association"))
      
    }
  issue_df
}