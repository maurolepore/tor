#' @rdname load_csv
#' @export
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
