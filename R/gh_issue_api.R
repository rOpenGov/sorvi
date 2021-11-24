#' @title GitHub issues statistics
#'
#' @description Get statistics about GitHub issues from GitHub API.
#' 
#' @details 
#' This function is intended for easy information retrieval about rOpenGov 
#' package issues and pull requests. More specifically, this function returns
#' a tibble containing information on issue id, title, status (open or closed),
#' number of comments, who opened it, when it was created, what was the openers
#' status (rOpenGov organization member, package contributor or a regular user 
#' who opened e.g. a bug issue) and what is the type of the issue. 
#' 
#' GitHub Issues API handles Pull Requests and Issues similarly and therefore 
#' this function returns both types by default. Different types of issues 
#' can be filtered by using the issue.type parameter.
#' 
#' Kudos for this function go to Jennifer Bryan. The changes made here are
#' mostly related to adding additional fields (opener_type, issue_type) to
#' the output tibble and writing a function around these original contributions.
#' The scope of this function is to mainly help rOpenGov team analyze the type
#' of user feedback we get via GitHub issues and therefore the scope of this
#' function is very limited.
#' 
#' @param owner Repository owner / organization. Default is "ropengov"
#' @param repo Repository name. Default is "geofi"
#' @param issue.type Type of issues printed: "issue", "PR" or NA printing all 
#' (default).
#' @param time.from Start date in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
#' Default is "2010-09-01T00:00:00Z".
#' @param time.to End date in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Default
#' is \code{Sys.time()}.
#'
#' @return tibble
#'
#' @author Original scripts by Jennifer Bryan (jennybc), function by Pyry Kantanen <pyry.kantanen@@gmail.com>
#' 
#' @seealso
#' GitHub Issues API documentation: 
#' \url{https://docs.github.com/en/rest/reference/issues}
#' 
#' Original "analyze GitHub stuff with R" repository:
#' \url{https://github.com/jennybc/analyze-github-stuff-with-r}
#'
#' @importFrom gh gh
#' @importFrom purrr map_int map_chr map
#' @importFrom tidyr tibble
#' @importFrom dplyr select %>%
#' @importFrom rlang .data
#'
#' @export
gh_issue_stats <- function(owner = "ropengov", 
                           repo = "geofi", 
                           issue.type = NA,
                           time.from = NA,
                           time.to = NA){
  if (is.na(time.from)){
    time.from <- as.Date("2010-09-01T00:00:00Z")
  }
  if (is.na(time.to)){
    time.to <- Sys.time()
  }
  if (time.from > time.to){
    message("time.from cannot be a future date!")
    return(NULL)
  }
  
  issue_list <-
    gh::gh("/repos/:owner/:repo/issues", owner = owner, repo = repo,
           state = "all", since = time.from, .limit = Inf)
  . <- issue_list
  issue_df <- issue_list %>%
    {
      tibble(number = purrr::map_int(., "number"),
             id = purrr::map_int(., "id"),
             title = purrr::map_chr(., "title"),
             state = purrr::map_chr(., "state"),
             n_comments = purrr::map_int(., "comments"),
             opener = purrr::map_chr(., c("user", "login")),
             created_at = purrr::map_chr(., "created_at") %>% as.Date(),
             opener_type = purrr::map_chr(., "author_association"),
             issue_type = purrr::map(., "pull_request") %>% 
               sapply(., is.list) %>% 
               ifelse(., "PR", "issue"))
    }
  
  if (is.na(issue.type) || issue.type == "all"){
    output_type_msg <- "issues or pull requests"
  } else if (tolower(issue.type) == "issue"){
    issue_df <- issue_df %>% 
      filter(.data$issue_type == "issue")
    output_type_msg <- "issues"
  } else if (toupper(issue.type) == "PR"){
    issue_df <- issue_df %>% 
      filter(.data$issue_type == "PR")
    output_type_msg <- "pull requests"
  } else {
    message("Use valid issue.type input: 'issue', 'PR' or NA")
    return(NULL)
  }
  
  if (nrow(issue_df) == 0){
    message(paste("No", output_type_msg, "in this repository!"))
    return(NULL)
  }
  
  issue_df
}
