#' Import multiple files into a list using any given reading function.
#'
#'
#' @param .f A function able to read the desired file format.
#' @inheritParams fs::dir_ls
#'
#' @return A modified version of the input function with the following
#'   arguments:
#'   * `path_dir: Optional string giving the path to the directory to read from.
#'     Defaults to reading from the working directory.
#'   * `...` Arguments passed to the reader function.
#'
#' @family general functions to import data
#' @export
#'
#' @examples
#' readw_example()
#'
#' (csv_files <- readw_example("csv"))
#' dir(csv_files)
#'
#' csv_list <- read_with(read.csv)
#' csv_list(csv_files)
#'
#' # Same
#' read_with(read.csv)(csv_files)
#'
#' # More robust
#' csv_list <- read_with(read.csv, regexp = "[.]csv")
#' csv_list(csv_files, stringsAsFactors = TRUE)
#'
#' # Compare
#' class(csv_list(csv_files)[[2]]$y)
#' class(csv_list(csv_files, stringsAsFactors = FALSE)[[2]]$y)
#'
#' (rdata_files <- readw_example("rdata"))
#' dir(rdata_files)
#'
#' # You may create your own reader function
#' read_rdata <- function(x) get(load(x))
#' rdata_list <- read_with(read_rdata)
#' rdata_list(rdata_files)
read_with <- function(.f, regexp = NULL) {
  function(path_dir = NULL, ...) {
    if (is.null(path_dir)) {
      path_dir <- "./"
    }
    files <- fs::dir_ls(path_dir, regexp = regexp, ignore.case = TRUE)

    if (length(files) == 0) {
      msg <- paste0(
        "Can't find any file with the desired extension:\n",
        "* Searching in: '", path_dir, "'.\n",
        "* Searching for: '", regexp, "'."
      )
      stop(msg, call. = FALSE)
    }

    file_names <- fs::path_ext_remove(fs::path_file(files))
    out <- lapply(files, .f, ...)
    stats::setNames(out, file_names)
  }
}
