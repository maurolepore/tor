context("read_with")

test_that("outputs expected object", {
  skip_if_not_installed("readr")

  csv_files <- readw_example("csv")
  expect_is(
    read_with(utils::read.csv, regexp = "[.]csv$")(csv_files),
    "list"
  )
})

test_that("outputs expected object", {
  csv_files <- readw_example("rds")
  expect_is(
    read_with(base::readRDS, regexp = "[.]rds$")(csv_files),
    "list"
  )

  read_rdata <- function(.x) get(load(.x))
  csv_files <- readw_example("rdata")
  expect_is(
    read_with(read_rdata, regexp = "[.]rdata$")(csv_files),
    "list"
  )
})

test_that("can read specific files in a mixed directory", {
  skip_if_not_installed("readr")

  csv_files <- readw_example("mixed")
  expect_is(
    read_with(utils::read.csv, regexp = "[.]csv$")(csv_files),
    "list"
  )
})

test_that("handles cero .rdata files", {
  read_rdata <- function(.x) get(load(.x))
  zero <- readw_example("csv")
  expect_error(
    read_with(read_rdata, regexp = "[.]rdata$")(zero),
    "Can't find.*rdata"
  )
})

test_that("handles cero .csv files", {
  skip_if_not_installed("readr")

  zero <- readw_example("rdata")
  expect_error(
    read_with(utils::read.csv, "[.]csv")(zero),
    "Can't find.*csv"
  )
})

test_that("passes arguments to the reader function via `...`", {
  csv_files <- readw_example("csv")
  csv_list <- read_with(read.csv)
  expect_is(csv_list(csv_files)[[2]]$y, "factor")
  expect_is(csv_list(csv_files, stringsAsFactors = FALSE)[[2]]$y, "character")
})
