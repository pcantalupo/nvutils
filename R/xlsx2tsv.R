#' @title Convert XLSX (Excel) file to TSV
#' @description Read XLSX file (with openxlsx::read.xlsx) and output it as a TSV
#' file (with data.table::fwrite)
#' @param file An Excel file name
#' @param outfile A tab-separated (.tsv) file name
#' @param sheet The name or index of the Excel sheet to read data from. See
#' openxlsx docs.
#' @param sep.names One character which substitutes blanks in column names.
#' See openxlsx docs.
#' @param detectDates Attempt to recognize dates. See openxlsx docs.
#' @param ... Pass additional params to fwrite
#'
#' @details
#' sep.names - read.xlsx by default will convert spaces in column
#' names to periods. To avoid this, the param 'sep.names' is defaulted to a
#' space character " ". However, this collapses 2 or more spaces in the column
#' name to one space. Set it to "." if you want the default read.xlsx behavior.
#'
#' NA handling: Excel is read with with na.strings = character(0), so no string
#' tokens are converted to missing on import. Literal "NA" in Excel is preserved as the
#' two-character string "NA". Blank Excel cells are written out as blank fields via
#' fwrite(na = ""). If you want "NA" strings to be treated as missing instead, call
#' read.xlsx with na.strings = "NA". If you want missing values written as the token NA
#' instead of a blank field, call fwrite with na = "NA".
#'
#' @return Invisible NULL
#' @export
#' @importFrom data.table fwrite
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

  xlsx = read.xlsx(file, sheet = sheet, sep.names = sep.names,
                   detectDates = detectDates, na.strings = character(0))
  fwrite(xlsx, outfile, sep = "\t", na = "",
         eol = "\n", quote = FALSE, ...)
  invisible(NULL)
}

