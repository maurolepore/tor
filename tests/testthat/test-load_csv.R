test_that("load_rds loads multiple .rds files in a new environment", {
  e <- new.env()
  load_rds(tor_example("rds"), envir = e)

  expect_equal(
    ls(e),
    c("rds1", "rds2")
  )
  rm(list = ls())
})

test_that("load_rdata loads multiple .rdata files in a new environment", {
  e <- new.env()
  load_rdata(tor_example("rdata"), envir = e)

  expect_equal(
    ls(e),
    c("rdata1", "rdata2")
  )
  rm(list = ls())
})

test_that("load_csv loads multiple .csv files in a new environment", {
  e <- new.env()
  load_csv(tor_example("csv"), envir = e)

  expect_equal(
    ls(e),
    c("csv1", "csv2")
  )
  rm(list = ls())
})

test_that("load_tsv loads multiple .tsv files in a new environment", {
  e <- new.env()
  load_tsv(tor_example("tsv"), envir = e)

  expect_equal(
    ls(e),
    c("tsv1", "tsv2")
  )
  rm(list = ls())
})
