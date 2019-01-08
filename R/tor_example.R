#' Easily access example data.
#'
#' @author Copied from `readr_example()` from the __readr__ package, by Jim
#'   Hester and colleagues.
#'
#' @param path Length-1 character vector. A path to an available directory.
#'
#' @return A list of available directories or a path to them.
#'
#' @examples
#' tor_example()
#' 
#' tor_example("csv")
#' 
#' dir(tor_example("csv"))
#' @family helpers
#' @export
tor_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "tor"))
  } else {
    system.file("extdata", path, package = "tor", mustWork = TRUE)
  }
}
