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

test_that("read_with is sensitive to `ignore.case`", {
  path <- readwith_example("mixed")

  expect_named(
    read_with(
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = FALSE
    )(path),
    c("lower_rdata")
  )

  expect_named(
    read_with(
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = TRUE
    )(path),
    c("lower_rdata", "upper_rdata")
  )

  expect_named(
    read_with(
      function(x) get(load(x)),
      regexp = "[.]csv$",
      ignore.case = TRUE,
      invert = TRUE
    )(path),
    c("lower_rdata", "rda", "upper_rdata")
  )
})

