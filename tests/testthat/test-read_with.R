context("test-read_with")

test_that("read_with with read.csv lists (file)named dataframes", {
  res <- read_with(utils::read.csv, regexp = "[.]csv$")(readwith_example("csv"))

  expect_is(res, "list")
  expect_named(res, c("file1", "file2"))
  expect_is(res[[1]], "data.frame")
})

test_that("read_with with read_rdata lists (file)named dataframes", {
  read_rdata <- function(x) get(load(x))
  res <- read_with(read_rdata, regexp = "[.]rdata$")(readwith_example("rdata"))

  expect_is(res, "list")
  expect_named(res, c("file1", "file2"))
  expect_is(res[[1]], "data.frame")
})

test_that("read_with reads specific files extention in a mixed directory", {
  expect_is(
    read_with(utils::read.csv, regexp = "[.]csv$")(readwith_example("mixed")),
    "list"
  )
})

test_that("read_with with zero .rdata file throws informative error", {
  read_rdata <- function(.x) get(load(.x))

  expect_error(
    read_with(read_rdata, regexp = "[.]rdata$")(readwith_example("csv")),
    "Can't find.*rdata"
  )
})

test_that("read_with with zero .csv file throws informative error", {
  expect_error(
    read_with(utils::read.csv, "[.]csv")(readwith_example("rdata")),
    "Can't find.*csv"
  )
})

test_that("read_with passes arguments to the reader function via `...`", {
  csv_files <- readwith_example("csv")
  csv_list <- read_with(read.csv)

  expect_is(csv_list(csv_files)[[2]]$y, "factor")
  expect_is(csv_list(csv_files, stringsAsFactors = FALSE)[[2]]$y, "character")
})

test_that("read_with with no path reads from working directory", {
  expect_is(
    read_with(read.csv, "[.]csv")(NULL)[[1]],
    "data.frame"
  )
})

context("input_list")

test_that("<input>_list reads <input> and outputs a named list of dataframes", {
  dir <- fgeo.x::example_path("csv")
  expect_is(csv_list(dir), "list")

  dir <- fgeo.x::example_path("rds")
  expect_is(rds_list(dir), "list")

  dir <- fgeo.x::example_path("rdata")
  expect_is(rdata_list(dir), "list")
})

test_that("can read specific files in a mixed directory", {
  dir <- fgeo.x::example_path("mixed_files")
  expect_is(csv_list(dir), "list")
})
