#' Read multiple files into a list using any given reading function.
#'
#' @param .f A function able to read the desired file format.
#' @inheritParams fs::dir_ls
#' @inheritParams base::grep
#'
#' @return A modified version of the input function with the following
#'   arguments:
#'   * `path_dir`: Optional string giving the path to the directory to read from.
#'     Defaults to reading from the working directory.
#'   * `...` Arguments passed to the reader function.
#'
#' @family general functions to import data
#' @export
#'
#' @examples
#' readwith_example()
#'
#' (csv_files <- readwith_example("csv"))
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
#' (rdata_files <- readwith_example("rdata"))
#' dir(rdata_files)
#'
#' # You may create your own reader function
#' read_rdata <- function(x) get(load(x))
#' rdata_list <- read_with(read_rdata)
#' rdata_list(rdata_files)
#'
#' (mixed_files <- readwith_example("mixed"))
#' dir(mixed_files)
#'
#' # You may `invert`
#' read_with(read_rdata, "[.]csv$", invert = TRUE)(mixed_files)
#'
#' # You may `ignore.case`
#' read_with(read_rdata, "[.]Rdata$", ignore.case = TRUE)(mixed_files)
read_with <- function(.f, regexp = NULL, ignore.case = FALSE, invert = FALSE) {
  function(path_dir = NULL, ...) {
    if (is.null(path_dir)) path_dir <- "."

    files <- fs::dir_ls(
      path_dir,
      regexp = regexp,
      ignore.case = ignore.case,
      invert = invert
    )

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

#' Read multiple (common) files from a directory into a list.
#'
#' These functions wrap [read_with()]. Notice the name-format `<input>_list()`.
#'
#' @param path_dir String; the path to a directory containing the files to read
#'   (all must be of appropriate format; see examples).
#' @param ... Arguments passed to the reader function:
#'   * `rdata_list()` and `rda_list()` read with `get(load(x))` (`...` not unused).
#'
#' @seealso [read_with()].
#'
#' @return A list of dataframes.
#'
#' @examples
#' (mixed_files <- readwith_example("mixed"))
#' dir(mixed_files)
#'
#' rdata_list(mixed_files)
#' @family general functions to import data
#' @name dir_list
NULL

#' @rdname dir_list
#' @export
rdata_list <- read_with(
  function(.x) get(load(.x)),
  regexp = "[.]rdata$|[.]rda$",
  ignore.case = TRUE
)

# #' @rdname dir_list
# #' @export
# rds_list <- read_with(readr::read_rds, regexp = "[.]rds$")
#
# #' @rdname dir_list
# #' @export
# csv_list <- read_with(readr::read_csv, regexp = "[.]csv$")

# #' @rdname dir_list
# #' @export
# tsv_list <- read_with(readr::read_tsv, regexp = "[.]tsv$")
