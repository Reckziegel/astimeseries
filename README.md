
<!-- README.md is generated from README.Rmd. Please edit that file -->

# astimeseries

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/Reckziegel/astimeseries.svg?branch=master)](https://travis-ci.org/Reckziegel/astimeseries)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/Reckziegel/astimeseries?branch=master&svg=true)](https://ci.appveyor.com/project/Reckziegel/astimeseries)
[![Codecov test
coverage](https://codecov.io/gh/Reckziegel/astimeseries/branch/master/graph/badge.svg)](https://codecov.io/gh/Reckziegel/astimeseries?branch=master)
<!-- badges: end -->

The objective of `astimeseries` is to simplify and assure the correct
coercion among data structures used in the `tidyverse` to R-Mertrics
(`timeSeries` class).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("Reckziegel/astimeseries")
```

## Example

Suppose you have the following `tibble`:

``` r

library(tibble)

tbl <- tibble(date = as.Date(c('2019-01-01', '2019-01-02', '2019-01-03')),
               a    = rnorm(3),
               b    = rnorm(3),
               c    = rnorm(3))

tbl
#> # A tibble: 3 x 4
#>   date            a      b      c
#>   <date>      <dbl>  <dbl>  <dbl>
#> 1 2019-01-01 -0.848  0.371 -0.476
#> 2 2019-01-02  0.226  0.435 -1.25 
#> 3 2019-01-03  1.37  -1.29  -1.18
```

If you try to coerce the `tbl` object to a `timeSeries` (the data
structure R-Metrics likes to work with), the timestamps attributes are
lost:

``` r

library(timeSeries)
#> Loading required package: timeDate

as.timeSeries(tbl)
#> 
#>               a          b          c
#> [1,] -0.8484120  0.3709798 -0.4759263
#> [2,]  0.2262966  0.4348504 -1.2538615
#> [3,]  1.3694029 -1.2940927 -1.1763620
```

Instead, it’s safer to use `as_timeseries` to ensure all information is
keeped approprietly.

``` r
# library(astimeseries)
as_timeseries(tbl)
#> GMT
#>                     a          b          c
#> 2019-01-01 -0.8484120  0.3709798 -0.4759263
#> 2019-01-02  0.2262966  0.4348504 -1.2538615
#> 2019-01-03  1.3694029 -1.2940927 -1.1763620
```
