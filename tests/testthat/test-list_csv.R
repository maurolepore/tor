context("list_rds")

test_that("list_rds outputs tibbles", {
  expect_is(list_rds(tor_example("rds"))[[1]], "tbl")
})

test_that("list_rds lists .rds files", {
  expect_named(
    list_rds(tor_example("rds")),
    c("rds1", "rds2")
  )
})

test_that("list_rds defaults to read from working directory", {
  expect_named(list_rds(), "rds")
})

test_that("list_rds reads specific .rds files", {
  expect_named(
    list_rds(tor_example("rds"), regexp = "rds1"),
    c("rds1")
  )
})

test_that("list_rds allows inverting a `regexp` pattern", {
  expect_named(
    list_rds(tor_example("rds"), regexp = "rds1", invert = TRUE),
    c("rds2")
  )
})

context("list_rdata")

test_that("list_rdata outputs tibbles", {
  expect_is(list_rdata(tor_example("rdata"))[[1]], "tbl")
})

test_that("list_rdata lists .rdata, .Rdata, and .rda", {
  expect_named(
    list_rdata(tor_example("mixed")),
    c("lower_rdata", "rda", "upper_rdata")
  )
})

test_that("list_rdata reads specific .rdata files (sensitive to `regexp`)", {
  expect_named(
    list_rdata(tor_example("mixed"), regexp = "lower_rdata"),
    "lower_rdata"
  )
})

test_that("list_rdata is sensitive to `ignore.case`", {
  expect_named(
    list_rdata(
      tor_example("mixed"),
      regexp = "[.]RData$",
      ignore.case = FALSE,
    ),
    "upper_rdata"
  )
})

test_that("list_rdata defaults to read from working directory", {
  expect_named(list_rdata(), "rdata")
})

context("list_csv")

test_that("list_csv outputs tibbles", {
  expect_is(list_csv(tor_example("csv"))[[1]], "tbl")
})

test_that("list_csv can read .csv specifically in a mixed directory", {
  expect_named(
    list_csv(tor_example("mixed")),
    "csv"
  )
})

test_that("list_csv defaults to `stringsAsFactors = FALSE`", {
  expect_is(list_csv(tor_example("mixed"))[[1]]$y, "character")
})

test_that("list_csv defaults to read from working directory", {
  # WARNING: Not for interactive use.
  expect_true(all(c("csv1", "csv2") %in% names(list_csv())))
})

test_that("list_csv is sensitive to `regexp`, `invert, and `ignore.case`", {
  expect_named(
    list_csv(
      tor_example("csv"),
      regexp = "[.]CSV$",
      ignore.case = TRUE,
    ),
    c("csv1", "csv2")
  )

  expect_named(
    list_csv(
      tor_example("csv"),
      regexp = "[.]CSV$",
      ignore.case = FALSE,
      invert = TRUE
    ),
    c("csv1", "csv2")
  )

  expect_error(
    list_csv(
      tor_example("csv"),
      regexp = "[.]CSV$",
      ignore.case = FALSE,
    )
  )
})

context("list_tsv")

test_that("list_tsv outputs tibbles", {
  expect_is(list_tsv(tor_example("tsv"))[[1]], "tbl")
})

test_that("list_tsv defaults to read from working directory", {
  expect_named(list_tsv(), "tsv")
})

test_that("list_tsv is sensitive to `regexp`, `invert, and `ignore.case`", {
  expect_named(
    list_csv(
      tor_example("tsv"),
      regexp = "[.]TSV$",
      ignore.case = TRUE,
    ),
    c("tsv1", "tsv2")
  )

  expect_named(
    list_csv(
      tor_example("tsv"),
      regexp = "[.]TSV$",
      ignore.case = FALSE,
      invert = TRUE
    ),
    c("tsv1", "tsv2")
  )

  expect_error(
    list_csv(
      tor_example("tsv"),
      regexp = "[.]TSV$",
      ignore.case = FALSE,
    )
  )
})
