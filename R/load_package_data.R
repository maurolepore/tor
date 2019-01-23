#' Enframe datasets from an attached package or load them into an environment.
#'
#' @param x A character string giving the name of one package.
#' @inheritParams load_any
#'
#' @return
#'   * `enframe_package_data()` returns a [tibble][tibble::tibble-package].
#'   * `load_package_data()` returns invisible `x`.
#'
#' @export
#'
#' @examples
#' # Must be attached
#' library("MASS")
#'
#' enframe_package_data("MASS")
#'
#' e <- new.env()
#' load_package_data("MASS", envir = e)
#' ls(e)
#' str(e$snails)
load_package_data <- function(x, envir = .GlobalEnv) {
  dts <- enframe_package_data(x)
  list2env(rlang::set_names(dts$data, dts$name), envir = envir)
  invisible(x)
}

#' @export
#' @rdname load_package_data
enframe_package_data <- function(x) {
  name_title <- entitle(x)
  lst_data <- mget(
    name_title[["name"]],
    envir = as.environment(paste0("package:", x))
  )
  name_data <- tibble::enframe(lst_data, name = "name", value = "data")
  tibble::add_column(name_title, data = name_data$data)
}

entitle <- function(x) {
  if (!is_attached(x)) {
    rlang::abort("{x} must be attached (use `library()`).")
  }
  # FIXME: Fails with the "datasets" package.
  rlang::set_names(
    tibble::as_tibble(utils::data(package = x)$results[, c("Item", "Title")]),
    c("name", "title")
  )
}

is_attached <- function(x) {
  any(grepl(paste0("package:", x), search()))
}
