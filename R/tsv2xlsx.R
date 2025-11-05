#' @title Convert TSV file to XLSX (Excel)
#' @description Read a tab-separated file with data.table::fread and write it to an XLSX with openxlsx::write.xlsx.
#' @param file Path to a tab-separated (.tsv) file with a header row.
#' @param outfile Output Excel file path.
#' @param colClasses Character vector or "character" to force all columns to character. Use NULL to allow type guessing. See data.table::fread.
#' @param na.strings Character vector of strings to interpret as missing; use NULL to disable NA conversion and keep empty fields as "" and the literal "NA" as "NA".
#' @param show_col_types Deprecated. No longer used.
#' @param guess_max Deprecated. Use colClasses instead.
#' @param ... Additional arguments passed to data.table::fread.
#'
#' @details
#' Default colClasses = "character" prevents type guessing and preserves the file contents as text, including leading zeros. With na.strings = NULL, empty fields remain "" and "NA" remains the 2-character string, which will appear as blank cells and "NA" text in Excel, respectively.
#'
#' If you want fread to infer types, set colClasses = NULL. If you want certain tokens treated as missing, set na.strings accordingly.
#'
#' @return Invisible NULL. Called for its side effect of writing an XLSX file.
#' @export
#' @importFrom data.table fread
#' @importFrom openxlsx write.xlsx
#'
#' @examples
#' \dontrun{
#' # Preserve empty strings and the literal "NA" as text
#' tsv2xlsx("foo.tsv", "foo.xlsx")
#'
#' # Allow type guessing
#' tsv2xlsx("foo.tsv", "foo.xlsx", colClasses = NULL)
#'
#' # Treat "NA" and "" as missing
#' tsv2xlsx("foo.tsv", "foo.xlsx", colClasses = NULL, na.strings = c("NA", ""))
#' }
tsv2xlsx <- function(file, outfile, colClasses = "character", na.strings = NULL,
                     show_col_types = NULL, guess_max = NULL, ...) {
  if (missing(file) || missing(outfile)) {
    stop("Usage: tsv2xlsx(file, outfile)")
  }
  if (!file.exists(file)) {
    stop(file, " not found")
  }

  # Deprecation warnings
  if (!is.null(show_col_types)) {
    warning("'show_col_types' is deprecated and ignored. Function now uses fread.")
  }
  if (!is.null(guess_max)) {
    warning("'guess_max' is deprecated. Use colClasses = NULL to enable type guessing or colClasses = \"character\" to read all as character.")
  }

  tsv <- data.table::fread(
    file = file,
    sep = "\t",
    colClasses = colClasses,
    na.strings = na.strings,
    data.table = FALSE,
    ...
  )
  write.xlsx(tsv, outfile)
  invisible(NULL)
}
