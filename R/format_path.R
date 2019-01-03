#' Format paths.
#'
#' This function is most useful to map the name of each element in a list to
#' an output path.
#'
#' @param base,prefix,files,ext Character vectors (all of length-1 except
#'   `files`, which can be of any length.
#'
#' @return A string of the same length as `files`. For example:
#'   `base/prefix-file1.csv` and `base/prefix-file2.csv`.
#' @export
#'
#' @examples
#' format_path(c("file1", "file2"), "csv")
#'
#' (dfs <- list_csv(tor_example("csv")))
#'
#' format_path(names(dfs), "csv")
#'
#' format_path(names(dfs), "csv", base = "home", prefix = "this-")
format_path <- function(files, ext, base = ".", prefix = NULL) {
  if (missing(files)) abort("`files` can't be missing")
  if (missing(ext)) abort("`ext` can't be missing")

  paste0(
    base, "/", if (!is.null(prefix)) fmt_prefix(prefix), files, fmt_ext(ext)
  )
}

fmt_prefix <- function(prefix) {
  sprintf("%s", prefix)
}

fmt_ext <- function(ext) {
  sprintf(".%s", ext)
}
