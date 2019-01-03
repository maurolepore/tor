#' Read multiple files into a list using any given reading function.
#'
#' @inheritParams fs::dir_ls
#' @inheritParams base::grep
#' @param .f A function able to read the desired file format.
#'
#' @return A list.
#'
#' @family general functions to import data
#' @export
#'
#' @examples
#' tor_example()
#'
#' path <- tor_example("csv")
#' dir(path)
#'
#' read_with(path, read.csv)
#'
#' read_with(path, ~read.csv(.x, stringsAsFactors = FALSE))
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' read_with(
#'   path_mixed, ~get(load(.x)),
#'   regexp = "[.]csv$",
#'   invert = TRUE
#' )
#'
#' read_with(
#'   path_mixed, ~get(load(.x)),
#'   "[.]Rdata$",
#'   ignore.case = TRUE
#' )
#' @importFrom rlang %||% abort set_names
read_with <- function(path = ".",
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
    abort(
      sprintf("Can't find files matching '%s' in:\n '%s'", regexp, path)
    )
  }

  file_names <- fs::path_ext_remove(fs::path_file(files))
  set_names(lapply(files, rlang::as_function(.f), ...), file_names)
}
