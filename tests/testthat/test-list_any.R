test_that("list_any with read.csv lists (file)named dataframes", {
  res <- list_any(
    tor_example("csv"),
    utils::read.csv,
    regexp = "[.]csv$"
  )

  expect_type(res, "list")
  expect_named(res, c("csv1", "csv2"))
  expect_s3_class(res[[1]], "data.frame")
  expect_s3_class(res[[1]], "tbl")
})

test_that("list_any accepts lambda functions and formulas", {
  res <- list_any(
    tor_example("rdata"),
    ~ get(load(.x))
  )

  expect_type(res, "list")
  expect_named(res, c("rdata1", "rdata2"))
  expect_s3_class(res[[1]], "data.frame")
  expect_identical(
    list_any(
      tor_example("rdata"),
      function(x) get(load(x))
    ),
    res
  )
})

test_that("list_any reads specific files extention in a mixed directory", {
  expect_type(
    list_any(
      tor_example("mixed"),
      utils::read.csv,
      regexp = "[.]csv$"
    ),
    "list"
  )
})

test_that("list_any errs with informative message if `regexp` matches no file", {
  expect_error(
    list_any(
      tor_example("csv"),
      get(load(.)),
      regexp = "[.]rdata$"
    ),
    "Can't find.*rdata"
  )
})

test_that("list_any passes arguments to the reader function via `...`", {
  expect_s3_class(
    list_any(
      tor_example("csv"),
      ~ read.csv(., stringsAsFactors = TRUE)
    )[[2]]$y,
    "factor"
  )
  expect_type(
    list_any(
      tor_example("csv"),
      ~ read.csv(., stringsAsFactors = FALSE)
    )[[2]]$y,
    "character"
  )
})

test_that("list_any with emtpy path reads from working directory", {
  expect_s3_class(
    list_any(, read.csv, "[.]csv")[[1]],
    "data.frame"
  )
})

test_that("list_any is sensitive to `ignore.case`", {
  expect_named(
    list_any(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = FALSE
    ),
    c("lower_rdata")
  )

  expect_named(
    list_any(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]rdata$",
      ignore.case = TRUE
    ),
    c("lower_rdata", "upper_rdata")
  )

  expect_named(
    list_any(
      tor_example("mixed"),
      function(x) get(load(x)),
      regexp = "[.]csv$",
      ignore.case = TRUE,
      invert = TRUE
    ),
    c("lower_rdata", "rda", "upper_rdata")
  )
})
