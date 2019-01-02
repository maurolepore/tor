#' Read multiple files into a list using any given reading function.
#'
#' @param .f A function able to read the desired file format.
#' @inheritParams fs::dir_ls
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
read_with <- function(.f, regexp = NULL) {
  function(path_dir = NULL, ...) {
    if (is.null(path_dir)) path_dir <- "."

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

#' Read multiple (.csv, .tsv, .rdata, .rds) files from a directory into a list.
#'
#' These functions read from a specific directory where every file has its own extension
#' as indicated by each function's name. Notice that function names have the format
#' input_output, i.e. file-extension_list. If none of these functions do what
#' you want, create your own with [read_with()].
#'
#' @param path_dir String; the path to a directory containing the files to read
#'   (all must be of appropriate format; see examples).
#' @param ... Arguments passed to the reader function:
#'   * `rdata_list()` and `rda_list()` read with `get(load(x))` (`...` not unused).
#'   * `rds_list()` reads with [readr::read_rds()].
#'   * `csv_list()` reads with [readr::read_csv()].
#'   * `delim_list()` reads with [readr::read_delim()].
#'   * `tsv_list()` reads with [readr::read_tsv()].
#'
#' @return A list of dataframes.
#'
#' @examples
#' library(fgeo.x)
#'
#' example_path()
#'
#' dir(example_path("rdata"))
#' rdata_list(example_path("rdata"))
#'
#' dir(example_path("rds"))
#' rds_list(example_path("rds"))
#'
#' dir(example_path("csv"))
#' csv_list(example_path("csv"))
#'
#' dir(example_path("tsv"))
#' tsv_list(example_path("tsv"))
#'
#' # Weird: Tab separated columns in a file with .csv extension
#' dir(example_path("weird"))
#'
#' # Extension is .csv, but this is not what you want
#' csv_list(example_path("weird"))
#'
#' # Use this instead
#' delim_list(example_path("weird"), delim = "\t")
#'
#' @family general functions to import data
#' @name dir_list
NULL

#' @rdname dir_list
#' @export
rdata_list <- read_with(function(.x) get(load(.x)), regexp = "[.]rdata$")

#' @rdname dir_list
#' @export
rda_list <- read_with(function(.x) get(load(.x)), regexp = "[.]rda$")

#' @rdname dir_list
#' @export
rds_list <- read_with(readr::read_rds, regexp = "[.]rds$")

#' @rdname dir_list
#' @export
csv_list <- read_with(readr::read_csv, regexp = "[.]csv$")

#' @rdname dir_list
#' @export
delim_list <- read_with(readr::read_delim, regexp = NULL)

#' @rdname dir_list
#' @export
tsv_list <- read_with(readr::read_tsv, regexp = "[.]tsv$")
