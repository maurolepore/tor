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
#' readwith_example()
#'
#' path <- readwith_example("csv")
#' dir(path)
#'
#' read_with(path, read.csv)
#'
#' read_with(path, ~read.csv(.x, stringsAsFactors = FALSE))
#'
#' (path_mixed <- readwith_example("mixed"))
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
write_with <- function(.x,
                       .f,
                       ext,
                       path = ".",
                       prefix = NULL,
                       ...) {
  purrr::walk2(.x, fmt_paths(prefix, names(.x), ext), .f, ...)
}

fmt_prefix <- function(prefix) sprintf("%s-", prefix)

fmt_ext <- function(ext) sprintf(".%s", ext)

fmt_paths <- function(prefix, paths, ext) {
  paste0(if (!is.null(prefix)) fmt_prefix(prefix), paths, fmt_ext(ext))
}
