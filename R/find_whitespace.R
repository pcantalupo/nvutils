#' Check for Leading or Trailing Whitespace in DataFrame Columns
#'
#' This function examines each column in a data frame to identify specific values that contain
#' leading or trailing whitespace. It returns a list with problematic values for each affected column.
#'
#' @param df A data frame to check for whitespace
#' @param sample_size Optional numeric value specifying number of rows to check.
#'        Default is NULL which checks all rows.
#'
#' @return A list where names are columns containing whitespace and values are the specific
#'         problematic values with their row numbers. Returns NULL if no whitespace is found.
#' @export
#'
#' @examples
#' # Create example data frame with whitespace issues
#' df <- data.frame(
#'   col1 = c("good", " bad", "good"),
#'   col2 = c("good", "good", "bad "),
#'   col3 = c("good", "good", "good"),
#'   stringsAsFactors = FALSE
#' )
#' find_whitespace(df)
find_whitespace <- function(df, sample_size = NULL) {
  # Input validation
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }

  # If sample_size is provided, take a random sample of rows
  if (!is.null(sample_size)) {
    if (sample_size > nrow(df)) {
      sample_size <- nrow(df)
    }
    rows_to_check <- sample(nrow(df), sample_size)
    df <- df[rows_to_check, , drop = FALSE]
  }

  # Function to find whitespace issues in a vector
  find_whitespace_values <- function(x, col_name) {
    if (!is.character(x) && !is.factor(x)) {
      return(NULL)
    }

    # Convert any factors to character
    x <- as.character(x)

    # Find indices of values with whitespace
    whitespace_indices <- grep("^\\s+|\\s+$", x)

    if (length(whitespace_indices) == 0) {
      return(NULL)
    }

    # Create named vector with problematic values
    values <- x[whitespace_indices]
    # Format row numbers consistently with leading zeros
    names(values) <- paste0("Row", whitespace_indices)
    return(values)
  }

  # Apply check to each column
  result <- lapply(names(df), function(col) {
    find_whitespace_values(df[[col]], col)
  })

  # Name the list elements with column names
  names(result) <- names(df)

  # Remove NULL elements
  result <- result[!sapply(result, is.null)]

  # Return NULL if no whitespace found, otherwise return the list
  if (length(result) == 0) {
    return(NULL)
  }

  return(result)
}
