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
#' list_any(path, read.csv)
#'
#' list_any(path, ~read.csv(.x, stringsAsFactors = FALSE))
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' list_any(
#'   path_mixed, ~get(load(.x)),
#'   regexp = "[.]csv$",
#'   invert = TRUE
#' )
#'
#' list_any(
#'   path_mixed, ~get(load(.x)),
#'   "[.]Rdata$",
#'   ignore.case = TRUE
#' )
#' @importFrom rlang %||% abort set_names
write_with <- function(.x,
                       path = ".",
                       .f,
                       ext,
                       prefix = NULL,
                       ...) {
  .y <- fmt_paths(base = path, prefix, files = names(.x), ext = ext)
  Map(rlang::as_function(.f), .x, .y)
}
