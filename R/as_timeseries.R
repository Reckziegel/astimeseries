#' Coerce any data structure to timeSeries class
#'
#' @param .data The data to be coerced
#' @param .select Select the columns to be included in the timeSeries object. Valid only for data.frames and tibbles. If \code{NULL} (the default) all the numeric columns will be used.
#' @param .date_var Inform the date column. Valid for data.frames and tibbles only. If \code{NULL} the function will do it's best to find the date column.
#' @param .silent Should warnings messages be omitted? The default is \code{TRUE}.
#' @param ... Addicional parameters to be passed into a \code{timeSeries} class.
#'
#' @importFrom magrittr "%>%"
#'
#' @return A timeSeries object.
#' @export
#'
#' @examples
#'
#' library(astimeseries)
#' class(EuStockMarkets)
#'
#' head(as_timeseries(EuStockMarkets))
#' class(as_timeseries(EuStockMarkets))
#'
as_timeseries <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .select   <- lazyeval::expr_text(.select)
  .date_var <- lazyeval::expr_text(.date_var)

  out <- as_timeseries_(.data, .select = .select, .date_var = .date_var, .silent = .silent, ...)

  return(out)

}


# create a method -----------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_ <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {
  UseMethod("as_timeseries_", .data)
}



# default -----------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.default <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  stop("as_timeseries it's only appliable to the following classes:" , "/n",
       "tbl, xts, ts, zoo and zooreg", call. = FALSE)

}


#' @rdname as_timeseries
#' @export
as_timeseries_.data.frame <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  if (inherits(.data, 'tbl_ts')) .data <- tibble::as_tibble(.data)

  # Implement select
  if (!(.select == "NULL" || is.null(.select))) {
    ret <- dplyr::select(.data, .select)
  } else {
    ret <- .data
  }

  # Names to check if got dropped
  names_to_check <- colnames(ret)

  # Numeric columns only
  ret <- dplyr::select_if(ret, is.numeric)
  ret <- ret[not_date(ret)]

  # Provide warning if columns are dropped
  names_dropped <- names_to_check[!(names_to_check %in% colnames(ret))]

  if (length(names_dropped) > 0) {
    if (!.silent) {
      warning(
        paste0("Non-numeric columns being dropped: ", stringr::str_c(names_dropped, collapse = ", "))
        )
    }
  }

  # Collect timeseries args
  timeseries_args <- list(x = ret)
  timeseries_args <- append(timeseries_args, list(...))


  # Interpret the "charvec" if not specified
  if (!("charvec" %in% names(timeseries_args))) {

    # Get date column
    if (!(is.null(.date_var) || .date_var == "NULL")) {

      # User specifies date_var
      date_col <- dplyr::select(.data, dplyr::matches(.date_var))
      timeseries_args$charvec <- date_col[[1]]

    } else {

      # Auto detect date if date_var not specified
      date_var <- get_index_col_name(.data)
      date_found <- !purrr::is_empty(date_var)

      if (date_found) {
        date_col <- dplyr::select(.data, dplyr::matches(date_var))
        timeseries_args$charvec <- date_col[[1]]

        if (!.silent)
          message(paste0("Using column `", date_var, "` for date_var."))

      } else {

        if (!is.null(rownames(.data))) {
          timeseries_args$charvec <- rownames(.data)
        } else {
          message("No date or date-time column found. Object will be coerced without a date reference.")
          timeseries_args$charvec <- NULL
        }

      }
    }
  }


  timeSeries::timeSeries(data = timeseries_args$x, charvec = timeseries_args$charvec, ...)

}


# tsibble -----------------------------------------------------------------

# #' @rdname as_timeseries
# #' @export
# as_time_series_.tbl_ts <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {
#
#   .data <- tibble::as_tibble(.data)
#
#   as_timeseries_.data.frame(.data     = .data,
#                             .select   = .select,
#                             .date_var = .date_var,
#                             .silent   = .silent,
#                             ...)
#
# }


# matrix ------------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.matrix <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .data %>%
    timeSeries::as.timeSeries(...)

}

# xts ---------------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.xts <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .data %>%
    timeSeries::as.timeSeries(...)

}



# ts ----------------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.ts <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .data %>%
    timeSeries::as.timeSeries(...)

}



# zooreg ------------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.zooreg <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .data %>%
    timeSeries::as.timeSeries(...)

}


# zoo ---------------------------------------------------------------------

#' @rdname as_timeseries
#' @export
as_timeseries_.zoo <- function(.data, .select = NULL, .date_var = NULL, .silent = TRUE, ...) {

  .data %>%
    timeSeries::as.timeSeries(...)

}

# TODO add coercion for a tsible


