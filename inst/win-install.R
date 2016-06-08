# This file is a part of the soRvi program (http://louhos.github.com/sorvi/)

# Copyright (C) 2010-2012 Louhos <louhos.github.com>. All rights reserved.

# This program is open source software; you can redistribute it and/or modify
# it under the terms of the FreeBSD License (keep this notice):
# http://en.wikipedia.org/wiki/BSD_licenses

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Installation script is almost completely based on code from devtools package
# developed by Hadley Wickham <h.wickham@gmail.com> available at
# https://github.com/hadley/devtools and realeased under the MIT license

install.prequisites <- function(package, ...) {
  if (suppressWarnings(!require(package, character.only=TRUE, quietly=TRUE))){
    install.packages(package, ...) # Install the packages
    require(package, character.only=TRUE) # Remember to load the library after installation
  }
  invisible(NULL)
}

decompress <- function(src, target = tempdir()) {
  filename <- basename(src)

  if (grepl("\\.zip$", filename)) {
    expand <- unzip
    outdir <- function() {
      basename(as.character(expand(src, list = TRUE)$Name[1]))
    }
  } else if (grepl("\\.(tar\\.gz|tgz)$", filename)) {
    expand <- function(...) untar(..., compressed = "gzip")
    outdir <- function() expand(src, list = TRUE)[1]
  } else if (grepl("\\.(tar\\.bz2|tbz)$", filename)) {
    expand <- function(...) untar(..., compressed = "bzip2")
    outdir <- function() expand(src, list = TRUE)[1]
  } else {
    ext <- gsub("^[^.]*\\.", "", filename)
    stop("Don't know how to decompress files with extension ", ext,
         call. = FALSE)
  }
  expand(src, exdir = target)

  file.path(target, outdir())
}

#' Parse dependencies.
#' @return character vector of package names
#' @keywords internal
parse_deps <- function(string) {
  if (is.null(string)) return()

  # Remove version specifications
  string <- gsub("\\s*\\(.*?\\)", "", string)

  # Split into pieces and remove R dependency
  pieces <- strsplit(string, ",")[[1]]
  pieces <- gsub("^\\s+|\\s+$", "", pieces)
  pieces[pieces != "R"]
}

R <- function(options, path = tempdir(), ...) {
  r_path <- file.path(R.home("bin"), "R")

  env <- c(
    "R_ENVIRON_USER" = tempfile(),
    "LC_ALL" = "C",
    "R_LIBS" = paste(.libPaths(), collapse = .Platform$path.sep),
    "CYGWIN" = "nodosfilewarning")

  in_dir(path, system_check(r_path, options, env, ...))
}

# @param arg a vector of command arguments.
# @param env a named character vector.  Will be quoted
system_check <- function(cmd, args = character(), env = character(), ...) {
  with_env(env, {
    res <- system2(cmd, args = args, ...)
  })
  if (res != 0) {
    stop("Command failed (", res, ")", call. = FALSE)
  }

  invisible(TRUE)
}


# TODO: right credits to devtools (source: devtools/R/install.R)

#' Install a package from a url
#'
#' This function is vectorised so you can install multiple packages in
#' a single command.
#'
#' @param url location of package on internet. The url should point to a
#'   zip file, a tar file or a bzipped/gzipped tar file.
#' @param name optional package name, used to provide more informative
#'   messages
#' @param subdir subdirectory within url bundle that contains the R package.
#' @param ... Other arguments passed on to \code{\link{install}}.
#' @export
#' @family package installation
install_url <- function(url, name = NULL, subdir = NULL, binary=FALSE, ...) {
  if (is.null(name)) {
    name <- rep(list(NULL), length(url))
  }

  invisible(mapply(install_url_single, url, name,
                   MoreArgs = list(subdir = subdir, binary = binary, ...)))
}

#' @importFrom httr GET config stop_for_status content
install_url_single <- function(url, name = NULL, binary=FALSE, subdir = NULL, ...) {
  if (is.null(name)) {
    name <- basename(url)
  }

  message("Installing ", name, " from ", url)
  bundle <- file.path(tempdir(), name)

  # Download package file
  request <- httr::GET(url, httr::config(ssl.verifypeer = FALSE))
  httr::stop_for_status(request)
  writeBin(content(request), bundle)
  on.exit(unlink(bundle), add = TRUE)

  unbundle <- decompress(bundle)
  on.exit(unlink(unbundle), add = TRUE)

  pkg_path <- if (is.null(subdir)) unbundle else file.path(unbundle, subdir)

  # Check it's an R package
  if (!file.exists(file.path(pkg_path, "DESCRIPTION"))) {
    stop("Does not appear to be an R package", call. = FALSE)
  }

  config_path <- file.path(pkg_path, "configure")
  if (file.exists(config_path)) {
    Sys.chmod(config_path, "777")
  }

  # Install
  if (binary) {
    install_binary(unbundle, bundle, ...)
  } else {
    install(pkg_path, ...)
  }
}

#' Install a binary zip package.
#'
#' Uses \code{R CMD INSTALL} to install the package. Will also try to install
#' dependencies of the package from CRAN, if they're not already installed.
#'
#' Installation takes place on a copy of the package produced by
#' \code{R CMD build} to avoid modifying the local directory in any way.
#'
#' @param pkg package description, can be path or package name.  See
#'   \code{\link{as.package}} for more information
#' @param reload if \code{TRUE} (the default), will automatically reload the
#'   package after installing.
#' @param quick if \code{TRUE} skips docs, multiple-architectures,
#'   and demos to make installation as fast as possible.
#' @param args An optional character vector of additional command line
#'   arguments to be passed to \code{R CMD install}.
#' @export
#' @family package installation
#' @seealso \code{\link{with_debug}} to install packages with debugging flags
#'   set.
#' @importFrom utils install.packages

install_binary <- function(pkg_bundle = NULL, pkg_zip=NULL, reload = TRUE, quick = FALSE,
                           args = NULL) {
  if (is.null(pkg_bundle)) {
    pkg_bundle <- decompress(pkg_zip)
    on.exit(unlink(pkg_bundle), add = TRUE)
  }

  pkg <- as.package(pkg_bundle)
  message("Installing ", pkg$package)
  install_deps(pkg)

  opts <- c(
    paste("--library=", shQuote(.libPaths()[1]), sep = ""),
    "--with-keep.source")
  if (quick) {
    opts <- c(opts, "--no-docs", "--no-multiarch", "--no-demo")
  }
  opts <- paste(paste(opts, collapse = " "), paste(args, collapse = " "))

  R(paste("CMD INSTALL ", shQuote(pkg_zip), " ", opts, sep = ""))

  if (reload) reload(pkg)
  invisible(TRUE)
}

install_deps <- function(pkg = NULL) {
  pkg <- as.package(pkg)
  deps <- c(parse_deps(pkg$depends), parse_deps(pkg$imports),
            parse_deps(pkg$linkingto))

  # Remove packages that are already installed
  not.installed <- function(x) length(find.package(x, quiet = TRUE)) == 0
  deps <- Filter(not.installed, deps)

  if (length(deps) == 0) return(invisible())

  message("Installing dependencies for ", pkg$package, ":\n",
          paste(deps, collapse = ", "))
  install.packages(deps)
  invisible(deps)
}
prequisities <- c("devtools", "httr")
for (pkg in prequisities) {
  install.prequisites(pkg)
}


install_url("https://github.com/downloads/louhos/sorvi/sorvi_0.1.86.zip",
            binary=T)

