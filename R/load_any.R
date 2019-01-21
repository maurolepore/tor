#' Import multiple files of any format from a directory into an environment.
#'
#' @inheritParams list_any
#' @param .f A function able to read the desired file format.
#' @inheritParams fs::dir_ls
#' @inheritParams base::grep
#' @inheritParams base::list2env
#' @param ... Additional arguments passed to `.f`.
#'
#' @return `invisible(path)`.
#' @export
#'
#' @examples
#' e <- new.env()
#' load_any(tor_example("rdata"), .f = ~ get(load(.x)), envir = e)
#' ls(e)
#'
#' # The data is now available in the environment `e`
#' e$rdata1
#' e$rdata2
#' @family functions to import files into an environment
#' @family functions to import files of any format
load_any <- function(path = ".",
                     .f,
                     regexp = NULL,
                     ignore.case = FALSE,
                     invert = FALSE,
                     envir = .GlobalEnv,
                     ...) {
  lst <- list_any(
    path = path,
    .f = .f,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )

  list2env(lst, envir = envir)
  invisible(path)
}
