#' @title Convert XLSX (Excel) file to TSV
#' @description Read XLSX file and output it as a TSv file
#' @param file An Excel file name
#' @param outfile A tab-separated (.tsv) file name
#' @param sheet The name or index of the Excel sheet to read data from.
#' @param ... Pass additional params to write_tsv
#'
#' @return Nothing
#' @export
#' @importFrom readr write_tsv
#' @importFrom openxlsx read.xlsx
#'
#' @examples
#' \dontrun{
#' xlsx2tsv("foo.xlsx", "foo.tsv")
#' }
xlsx2tsv = function(file, outfile, sheet = 1, ...) {
  if(missing(file) || missing(outfile)) {
    stop("Usage: xlsx2tsv(file, outfile)")
  }

  if(!file.exists(file)) {
    stop(file, " not found")
  }

  xlsx = read.xlsx(file, sheet = sheet)
  write_tsv(xlsx, outfile, ...)  # blank fields are converted to "NA" by default
}

