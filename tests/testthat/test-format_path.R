context("format_path")

# format_path(c("file1", "file2"), "csv")

test_that("format_path formats a two lenght-2 `file`", {
  expect_equal(
    format_path(c("file1", "file2"), "csv"),
    c("./file1.csv", "./file2.csv")
  )
})

test_that("format_path is sensitive to `base`", {
  expect_equal(
    format_path(c("file1", "file2"), "csv", base = "home"),
    c("home/file1.csv", "home/file2.csv")
  )
})

test_that("format_path is sensitive to `prefix`", {
  expect_equal(
    format_path(c("file1", "file2"), "csv", prefix = "pre-"),
    c("./pre-file1.csv", "./pre-file2.csv")
  )
})

test_that("format_path errs with informative message", {
  expect_error(
    format_path(),
    "`files` can't be missing"
  )
  expect_error(
    format_path("file1"),
    "`ext` can't be missing"
  )
})
