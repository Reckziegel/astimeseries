context('test as_timeseries_.matrix')

library(astimeseries)

test_matrix <- matrix(1:9, ncol = 3)
test_timeseries <- as_timeseries(test_matrix)

test_that("coercion from matrix to timeSeries works", {

  # pure matrix
  expect_equal(nrow(test_matrix), 3)
  expect_equal(ncol(test_matrix), 3)
  expect_equal(class(test_matrix), 'matrix')

  # after coercion
  expect_equal(nrow(test_timeseries), 3)
  expect_equal(ncol(test_timeseries), 3)
  expect_equal(class(test_timeseries)[[1]], 'timeSeries')

})

