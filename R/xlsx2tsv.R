#' @title Convert XLSX (Excel) file to TSV
#' @description Read XLSX file (with openxlsx::read.xlsx) and output it as a TSV
#' file (with readr::write_tsv)
#' @param file An Excel file name
#' @param outfile A tab-separated (.tsv) file name
#' @param sheet The name or index of the Excel sheet to read data from. See
#' openxlsx docs.
#' @param sep.names One character which substitutes blanks in column names.
#' See openxlsx docs.
#' @param detectDates Attempt to recognize dates. See openxlsx docs.
#' @param ... Pass additional params to write_tsv
#'
#' @details
#' sep.names - read.xlsx by default will convert spaces in column
#' names to periods. To avoid this, the param 'sep.names' is defaulted to a
#' space character " ". However, this collapses 2 or more spaces in the column
#' name to one space. Set it to "." if you want the default read.xlsx behavior.
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
xlsx2tsv = function(file, outfile, sheet = 1, sep.names = " ",
                    detectDates = FALSE, ...) {
  if(missing(file) || missing(outfile)) {
    stop("Usage: xlsx2tsv(file, outfile)")
  }

  if(!file.exists(file)) {
    stop(file, " not found")
  }

  xlsx = read.xlsx(file, sheet = sheet, sep.names = " ",
                   detectDates = detectDates)
  write_tsv(xlsx, outfile, ...)  # blank fields are converted to "NA" by default
}

