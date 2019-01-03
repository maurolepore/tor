#' Easily access example data.
#'
#' @author Copied from `readr::readr_example()`, by Jim Hester and colleagues.
#'
#' @param path Length-1 character vector. A path to an available directory.
#'
#' @return A list of available directories or a path to them.
#' @export
#'
#' @examples
#' readwith_example()
#' readwith_example("csv")
#' dir(readwith_example("csv"))
readwith_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "readwith"))
  } else {
    system.file("extdata", path, package = "readwith", mustWork = TRUE)
  }
}
