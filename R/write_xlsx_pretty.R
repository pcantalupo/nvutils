#' @title Write a data frame to a nicely-formatted XLSX (Excel)
#' @description Write a single data frame to an XLSX with openxlsx, applying formatting that fixes the default output: left/top cell alignment, auto column widths, text columns forced to text format (preserving leading zeros), dates shown as YYYY-MM-DD, an initial worksheet zoom, and a large default window size.
#' @param df A data frame to write.
#' @param path Output XLSX file path.
#' @param sheet Worksheet name. Default "Sheet 1".
#' @param zoom Initial worksheet zoom percentage. Default 170.
#' @param rownames_col If non-NULL, the data frame's row names are moved into a new first column with this name (via tibble::rownames_to_column). Default NULL.
#' @param window_width Excel workbook window width. Default 45000.
#' @param window_height Excel workbook window height. Default 30000.
#' @param pct_cols Character vector of column names holding mixed values where purely-numeric entries should be written as numbers with the "0\%" number format (so Excel shows e.g. "90\%") while non-numeric text entries (e.g. "<90\%", "No preop chemo") are written with general format. Default character(0).
#'
#' @details
#' Character columns are given Excel's text number format ("@") so values like
#' "001" are not silently converted to numbers. Columns inheriting from Date or
#' POSIXct are formatted as YYYY-MM-DD.
#'
#' The `pct_cols` argument handles columns that mix decimal values (e.g. 0.9,
#' which Excel with the "0\%" format displays as "90\%") with free text (e.g.
#' "<90\%"). For each such column, entries matching `^[0-9.]+$` are written as
#' numeric with the "0\%" format and all other entries keep the general format.
#'
#' @return Invisible NULL. Called for its side effect of writing an XLSX file.
#' @export
#' @importFrom openxlsx createWorkbook addWorksheet writeData createStyle addStyle setColWidths saveWorkbook
#' @importFrom tibble rownames_to_column
#' @importFrom stringr str_detect
#'
#' @examples
#' \dontrun{
#' write_xlsx_pretty(mtcars, "mtcars.xlsx", rownames_col = "model")
#'
#' # A column mixing numeric percentages with text
#' df <- data.frame(id = 1:2, Chemo_Response = c("0.9", "<90%"))
#' write_xlsx_pretty(df, "response.xlsx", pct_cols = "Chemo_Response")
#' }
write_xlsx_pretty <- function(df, path, sheet = "Sheet 1", zoom = 170, rownames_col = NULL,
                              window_width = 45000, window_height = 30000,
                              pct_cols = character(0)) {
  if (!is.null(rownames_col)) {
    df <- tibble::rownames_to_column(df, var = rownames_col)
  }
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, sheet, zoom = zoom)
  openxlsx::writeData(wb, sheet, df)
  cell_style <- openxlsx::createStyle(halign = "left", valign = "top")
  openxlsx::addStyle(wb, sheet, cell_style,
                     rows = seq_len(nrow(df)) + 1,
                     cols = seq_len(ncol(df)), gridExpand = TRUE)
  openxlsx::setColWidths(wb, sheet, cols = seq_len(ncol(df)), widths = "auto")
  char_cols <- which(sapply(df, is.character))
  if (length(char_cols) > 0) {
    text_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "@")
    openxlsx::addStyle(wb, sheet, text_style,
                       rows = seq_len(nrow(df)) + 1,
                       cols = char_cols, gridExpand = TRUE)
  }
  date_cols <- which(sapply(df, inherits, what = c("POSIXct", "Date")))
  if (length(date_cols) > 0) {
    date_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "YYYY-MM-DD")
    openxlsx::addStyle(wb, sheet, date_style,
                       rows = seq_len(nrow(df)) + 1,
                       cols = date_cols, gridExpand = TRUE)
  }
  for (col_name in intersect(pct_cols, colnames(df))) {
    col_idx  <- which(colnames(df) == col_name)
    col_vals <- df[[col_name]]
    pct_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "0%")
    gen_style <- openxlsx::createStyle(halign = "left", valign = "top")
    for (r in seq_along(col_vals)) {
      v <- col_vals[r]
      if (!is.na(v) && stringr::str_detect(v, "^[0-9.]+$")) {
        openxlsx::writeData(wb, sheet, as.numeric(v), startRow = r + 1, startCol = col_idx)
        openxlsx::addStyle(wb, sheet, pct_style, rows = r + 1, cols = col_idx)
      } else {
        openxlsx::addStyle(wb, sheet, gen_style, rows = r + 1, cols = col_idx)
      }
    }
  }
  wb$workbook$bookViews <- sprintf(
    '<bookViews><workbookView xWindow="0" yWindow="0" windowWidth="%d" windowHeight="%d"/></bookViews>',
    window_width, window_height)
  openxlsx::saveWorkbook(wb, path, overwrite = TRUE)
  invisible(NULL)
}
