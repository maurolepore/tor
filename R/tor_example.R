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
#' tor_example()
#' tor_example("csv")
#' dir(tor_example("csv"))
tor_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "tor"))
  } else {
    system.file("extdata", path, package = "tor", mustWork = TRUE)
  }
}
