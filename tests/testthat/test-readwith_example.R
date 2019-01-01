context("readwith_example")

test_that("with no argument returns directories at inst/extdata (not a path)", {
  expect_false(
    any(grepl("readwith", readwith_example()))
  )
})

test_that("with a known directory returns a path (includes the package name)", {
  expect_true(
    any(grepl("readwith", readwith_example("csv")))
  )
})

test_that("includes known directory", {
  expect_true(
    any(grepl("rdata", readwith_example()))
  )
})
