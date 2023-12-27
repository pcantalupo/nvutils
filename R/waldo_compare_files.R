#' @title Compare two files
#' @description
#' Compare two files using waldo::compare
#'
#' @param file1 Filename for the first file
#' @param file2 Filename for the second file
#' @param max_diffs Maximum no. differences that are reported
#' @param ... Additional params passed to compare()
#'
#' @return The result of waldo::compare()
#' @export
#' @importFrom readr read_tsv
#' @importFrom openxlsx read.xlsx
#' @importFrom tools file_ext
#' @importFrom waldo compare
#'
#' @examples
#' \dontrun{
#' waldo_compare_files("foo.txt", "foo.txt")
#' }
waldo_compare_files = function(file1, file2, max_diffs = Inf, ...) {
  if (missing(file1) || missing(file2)) {
    stop("file1 and file2 params are required")
  }

  objects = list()
  for (file in c(file1, file2)) {
    ext = file_ext(file)
    if (ext == "") {
      stop("No file extension found for file ", file)
    } else if (ext == "rds") {
      objects[[file]] = readRDS(file)
    } else if (ext == "txt") {
      objects[[file]] = readLines(file)
    } else if (ext == "tsv") {
      objects[[file]] = read_tsv(file, show_col_types = FALSE)
    } else if (ext == "xlsx") {
      objects[[file]] = read.xlsx(file)
    } else {
      stop("File extension, ", ext, ", not supported")
    }
  }

  cat("\nWaldo compare results:\n")
  waldo::compare(objects[[1]], objects[[2]], max_diffs = max_diffs, ...)
}

