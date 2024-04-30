#' @title Convert TSV file to XLSX (Excel)
#' @description Read TSV file and output it as an XLSX file
#' @param file A tab-separated (.tsv) file (with header row)
#' @param outfile Excel file name
#' @param show_col_types See ?readr::read_tsv
#' @param guess_max See ?readr::read_tsv. Set to 'Inf' to use all rows to
#' determine column type.
#'
#' @return Nothing
#' @export
#' @importFrom readr read_tsv
#' @importFrom openxlsx write.xlsx
#'
#' @examples
#' \dontrun{
#' tsv2xlsx("foo.tsv", "foo.xlsx")
#' }
tsv2xlsx = function(file, outfile, show_col_types = NULL, guess_max = 1000) {
  if(missing(file) || missing(outfile)) {
    stop("Usage: tsv2xlsx(file, outfile)")
  }

  if(!file.exists(file)) {
    stop(file, " not found")
  }

  tsv = read_tsv(file, show_col_types = show_col_types, guess_max = guess_max)
  write.xlsx(tsv, outfile)
}

