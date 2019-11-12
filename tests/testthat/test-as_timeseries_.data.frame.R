context('test as_timeseries_.data.frame')

library(tibble)
library(astimeseries)

ret_tbl <- tibble(date = as.Date(c('2019-01-01', '2019-01-02', '2019-01-03')),
               a    = rnorm(3),
               b    = rnorm(3),
               c    = rnorm(3))

ret_df <- data.frame(rnorm(3), rnorm(3), rnorm(3))
colnames(ret_df) <- c('a', 'b', 'c')
rownames(ret_df) <- as.Date(c('2019-01-01', '2019-01-02', '2019-01-03'))

ret_tbl_ts <- as_timeseries(ret_tbl)
ret_df_ts <- as_timeseries(ret_df)

test_that("coercion from data.frame to timeSeries works", {

  # tbl
  expect_equal(nrow(ret_tbl), 3)
  expect_equal(ncol(ret_tbl), 4)
  expect_s3_class(ret_tbl, 'tbl')

  # data.frame
  expect_equal(nrow(ret_df), 3)
  expect_equal(ncol(ret_df), 3)
  expect_s3_class(ret_df, 'data.frame')

  # tbl_ts
  expect_equal(nrow(ret_tbl_ts), 3)
  expect_equal(ncol(ret_tbl_ts), 3)
  expect_s4_class(ret_tbl_ts, 'timeSeries')
  expect_equal(names(ret_tbl_ts), names(ret_tbl[ , -1])) # names are keeped
  expect_equal(as.Date(rownames(ret_tbl_ts)), ret_tbl$date) # dates are keeped

  # data.frame_ts
  expect_equal(nrow(ret_df_ts), 3)
  expect_equal(ncol(ret_df_ts), 3)
  expect_s4_class(ret_df_ts, 'timeSeries')
  expect_equal(names(ret_df_ts), names(ret_tbl[ , -1])) # names are keeped
  expect_equal(as.Date(rownames(ret_df_ts)), as.Date(rownames(ret_df))) # dates are keeped

})
