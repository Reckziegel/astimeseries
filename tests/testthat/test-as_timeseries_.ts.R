context('test as_timeseries_.ts')

library(astimeseries)

test_timeseries <- as_timeseries(AirPassengers)

test_that("coercion from matrix to timeSeries works", {

  # ts
  expect_equal(length(AirPassengers), 144)
  expect_s3_class(AirPassengers, 'ts')

  # after coercion
  expect_equal(nrow(test_timeseries), 144)
  expect_equal(ncol(test_timeseries), 1)
  expect_s4_class(test_timeseries, 'timeSeries')
  # TODO add comparion between dates

})
