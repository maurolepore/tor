#' Load multiple common files from a directory into an environment.
#'
#' @inheritParams load_any
#' @inheritParams readr::read_delim
#' @param ... Arguments passed to `readr::read_csv()` or `readr::read_tsv()`.
#'
#' @return `invisible(path)`.
#'
#' @examples
#' (path_csv <- tor_example("csv"))
#' dir(path_csv)
#'
#' load_csv(path_csv)
#' # Each dataframe is now available in the global environment
#' csv1
#' csv2
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' load_rdata(path_mixed)
#' # Each dataframe is now available in the global environment
#' lower_rdata
#' upper_rdata
#' @family general functions to import data
#' @export
load_csv <- function(path = ".",
                     regexp = "[.]csv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     envir = .GlobalEnv,
                     ...) {
  lst <- list_any(
    path,
    readr::read_csv,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_csv
#' @export
load_tsv <- function(path = ".",
                     regexp = "[.]tsv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     envir = .GlobalEnv,
                     ...) {
  lst <- list_any(
    path,
    readr::read_tsv,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_csv
#' @export
load_rds <- function(path = ".",
                     regexp = "[.]rds$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     envir = .GlobalEnv) {
  lst <- list_any(
    path,
    function(x) base::readRDS(x),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_csv
#' @export
load_rdata <- function(path = ".",
                       regexp = "[.]rdata$|[.]rda$",
                       ignore.case = TRUE,
                       invert = FALSE,
                       envir = .GlobalEnv) {
  lst <- list_any(
    path,
    function(x) get(load(x)),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )

  list2env(lst, envir = envir)
  invisible(path)
}

