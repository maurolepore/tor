context("read_with")

test_that("read_with with read.csv lists (file)named dataframes", {
  res <- read_with(
    tor_example("csv"),
    utils::read.csv, regexp = "[.]csv$"
  )

  expect_is(res, "list")
  expect_named(res, c("file1", "file2"))
  expect_is(res[[1]], "data.frame")
})

test_that("read_with accepts lambda functions and formulas", {
  res <- read_with(
    tor_example("rdata"),
    ~get(load(.x))
  )

  expect_is(res, "list")
  expect_named(res, c("file1", "file2"))
  expect_is(res[[1]], "data.frame")
  expect_identical(
    read_with(
      tor_example("rdata"),
      function(x) get(load(x))
    ),
    res
  )
})

test_that("read_with reads specific files extention in a mixed directory", {
  expect_is(
    read_with(
      tor_example("mixed"),
      utils::read.csv, regexp = "[.]csv$"
    ),
    "list"
  )
})

test_that("read_with errs with informative message if `regexp` matches no file", {
  expect_error(
    read_with(
      tor_example("csv"),
      get(load(.)),
      regexp = "[.]rdata$"
    ),
    "Can't find.*rdata"
  )
})

test_that("read_with passes arguments to the reader function via `...`", {
  expect_is(
    read_with(
      tor_example("csv"),
      read.csv
    )[[2]]$y,
    "factor"
  )
  expect_is(
    read_with(
      tor_example("csv"),
      ~read.csv(., stringsAsFactors = FALSE)
    )[[2]]$y,
    "character"
  )
})

test_that("read_with with emtpy path reads from working directory", {
  expect_is(
    read_with( , read.csv, "[.]csv")[[1]],
    "data.frame"
  )
})

test_that("read_with is sensitive to `ignore.case`", {
  expect_named(
    read_with(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = FALSE
    ),
    c("lower_rdata")
  )

  expect_named(
    read_with(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = TRUE
    ),
    c("lower_rdata", "upper_rdata")
  )

  expect_named(
    read_with(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]csv$",
      ignore.case = TRUE,
      invert = TRUE
    ),
    c("lower_rdata", "rda", "upper_rdata")
  )
})
