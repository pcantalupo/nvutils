#' Peek inside an object
#'
#' Show the first few rows and columns of an object
#'
#' @param data    An object
#' @param row     Number of rows to show
#' @param col     Number of columns to show
#' @param glimpse Run dplyr::glimpse?
#'
#' @return Nothing
#' @export
#' @importFrom dplyr glimpse
#' @importFrom utils head
#'
#' @examples
#' peek(mtcars, glimpse = TRUE)
#' peek(letters)
peek = function(data, row = 5, col = 5, glimpse = FALSE) {
  if (glimpse) {
    message("\ndplyr glimpse:")
    glimpse(data)
  }

  cat("\n")
  if (is.null(nrow(data))) {
    print(head(data, row))
  } else {
    if (nrow(data) < row) { row = nrow(data) }
    if (ncol(data) < col) { col = ncol(data) }
    print(data[1:row,1:col])
  }
}

