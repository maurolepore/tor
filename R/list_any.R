#' Import multiple files of any format from a directory into a list.
#'
#' @param path A character vector of one path. Defaults to the working
#'   directory.
#' @param .f A function able to read the desired file format.
#' @inheritParams fs::dir_ls
#' @inheritParams base::grep
#' @param ... Additional arguments passed to `.f`.
#'
#' @return A list.
#'
#' @examples
#' tor_example()
#'
#' (path <- tor_example("csv"))
#' dir(path)
#'
#' list_any(path, read.csv)
#'
#' list_any(path, ~ read.csv(.x, stringsAsFactors = FALSE))
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' list_any(
#'   path_mixed, ~ get(load(.x)),
#'   "[.]Rdata$",
#'   ignore.case = TRUE
#' )
#'
#' list_any(
#'   path_mixed, ~ get(load(.x)),
#'   regexp = "[.]csv$",
#'   invert = TRUE
#' )
#' @family functions to import files into a list
#' @family functions to import files of any format
#' @export
list_any <- function(path = ".",
                     .f,
                     regexp = NULL,
                     ignore.case = FALSE,
                     invert = FALSE,
                     ...) {
  files <- fs::dir_ls(
    path,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )

  if (length(files) == 0) {
    abort(sprintf("Can't find files matching '%s' in:\n '%s'", regexp, path))
  }

  file_names <- fs::path_ext_remove(fs::path_file(files))
  result <- set_names(lapply(files, rlang::as_function(.f), ...), file_names)
  dataframe_to_tibble(result)
}

dataframe_to_tibble <- function(x) {
  sel <- vapply(x, is.data.frame, logical(1))
  x[sel] <- lapply(x[sel], tibble::as_tibble)
  x
}
