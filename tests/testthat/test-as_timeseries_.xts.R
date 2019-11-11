context('test as_timeseries_.xts')

library(xts)
library(astimeseries)

rets <- xts(matrix(rnorm(9), ncol = 3), order.by = timeBasedSeq('2019-01-01/2019-01-03'))
colnames(rets) <- c("a", "b", "c")

names_rets <- colnames(rets)
dates_rets <- zoo::index(rets)
test_timeseries <- as_timeseries(rets)

test_that("coercion from matrix to timeSeries works", {

  # xts
  expect_equal(nrow(rets), 3)
  expect_equal(ncol(rets), 3)
  expect_s3_class(rets, 'xts')

  # after coercion
  expect_equal(nrow(test_timeseries), 3)
  expect_equal(ncol(test_timeseries), 3)
  expect_s4_class(test_timeseries, 'timeSeries')
  expect_named(test_timeseries, names_rets) # names are keeped
  expect_equal(rownames(test_timeseries), as.character(dates_rets)) # dates are keeped

})

