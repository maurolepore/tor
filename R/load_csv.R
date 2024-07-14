#' Import multiple common files from a directory into an environment.
#'
#' These functions wrap common use-cases of [load_any()].
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
#' # Each file is now available in the global environment
#' csv1
#' csv2
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' # Loading the data in an environment other than the global environment
#' e <- new.env()
#' load_rdata(path_mixed, envir = e)
#' # Each dataframe is now available in the environment `e`
#' e$lower_rdata
#' e$upper_rdata
#' @family functions to import files into an environment
#' @family functions to import files of common formats
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
