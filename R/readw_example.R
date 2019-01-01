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
#' readw_example()
#' readw_example("csv")
#' dir(readw_example("csv"))
readw_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "readw"))
  }
  else {
    system.file("extdata", path, package = "readw", mustWork = TRUE)
  }
}
