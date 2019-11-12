# helper ------------------------------------------------------------------
get_index_col_name <- function(data) {

  if (!is.data.frame(data)) {
    stop('`data` should be a data.frame', call. = FALSE)
  }

  classes <- purrr::map(data, class)
  date_classes <- purrr::map_lgl(classes, ~ any(. %in% c('POSIXt', 'Date', 'yearmon', 'yearqtr')))

  names(data[date_classes])

}

not_date <- function(data) {

  #if (!is.data.frame(data)) {
  #  stop('`data` should be a data.frame', call. = FALSE)
  #}

  classes <- purrr::map_chr(data, class)
  !(classes %in% c('POSIXt', 'Date', 'yearmon', 'yearqtr'))

}
