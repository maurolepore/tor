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
write_with <- function(.x,
                       path = ".",
                       .f,
                       ext,
                       prefix = NULL,
                       ...) {
  .y <- fmt_paths(base = path, prefix, files = names(.x), ext = ext)
  Map(rlang::as_function(.f), .x, .y)
}


# base <- "home"
# prefix <- "pre"
# files <- c("f1", "f2")
# ext <- "csv"
# fmt_paths(base = base, prefix, files = files, ext = ext)
fmt_paths <- function(base, prefix, files, ext) {
  paste0(
    base, "/",
    if (!is.null(prefix)) fmt_prefix(prefix),
    files,
    fmt_ext(ext)
  )
}

fmt_prefix <- function(prefix) sprintf("%s-", prefix)

fmt_ext <- function(ext) sprintf(".%s", ext)
