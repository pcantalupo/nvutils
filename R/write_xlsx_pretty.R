#' @title Write a data frame to a nicely-formatted XLSX (Excel)
#' @description Write a single data frame to an XLSX with openxlsx, applying formatting that fixes the default output: left/top cell alignment on the header row and the data, auto column widths capped at a readable maximum, text columns forced to text format (preserving leading zeros), dates shown as YYYY-MM-DD, an initial worksheet zoom, and a large default window size.
#' @param df A data frame to write.
#' @param path Output XLSX file path.
#' @param sheet Worksheet name. Default "Sheet 1".
#' @param zoom Initial worksheet zoom percentage. Default 170.
#' @param rownames_col If non-NULL, the data frame's row names are moved into a new first column with this name (via tibble::rownames_to_column). Default NULL.
#' @param window_width Excel workbook window width. Default 45000.
#' @param window_height Excel workbook window height. Default 30000.
#' @param pct_cols Character vector of column names holding mixed values where purely-numeric entries should be written as numbers with the "0\%" number format (so Excel shows e.g. "90\%") while non-numeric text entries (e.g. "<90\%", "No preop chemo") are written with general format. Default character(0).
#' @param max_col_width Maximum column width, in the same character units Excel shows in its "Column Width" dialog. Columns whose widest value exceeds this are pinned to it; narrower columns keep the auto-fitted width. NULL disables the cap. Default 100.
#' @param wrap_text Wrap cell contents instead of letting a value longer than its column spill across neighbouring cells. Default TRUE.
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
#' Column widths are auto-fitted, but openxlsx's auto-fit stops only at Excel's
#' 250-character ceiling, so a single long free-text column can render
#' unreadably wide. `max_col_width` pins such columns to a fixed width while
#' leaving every other column's auto-fitted width untouched. Because a capped
#' column is narrower than its longest value, `wrap_text` is on by default so
#' the overflow wraps within the cell rather than spilling across whichever
#' neighbouring cells happen to be empty. Excel auto-fits the row height for
#' wrapped cells, so rows holding long values render taller.
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
                              pct_cols = character(0), max_col_width = 100,
                              wrap_text = TRUE) {
  if (!is.null(rownames_col)) {
    df <- tibble::rownames_to_column(df, var = rownames_col)
  }
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, sheet, zoom = zoom)
  openxlsx::writeData(wb, sheet, df)
  cell_style <- openxlsx::createStyle(halign = "left", valign = "top",
                                      wrapText = wrap_text)
  # Row 1 is the header, which writeData leaves unstyled; include it so the
  # header aligns with the data beneath it. The per-type styles below start at
  # row 2 and so leave the header on this general format.
  openxlsx::addStyle(wb, sheet, cell_style,
                     rows = seq_len(nrow(df) + 1),
                     cols = seq_len(ncol(df)), gridExpand = TRUE)
  # Auto-fit every column, except those whose content exceeds max_col_width:
  # openxlsx resolves "auto" at save time and only stops at Excel's 250-char
  # ceiling, so wide columns are pinned with a second call instead.
  if (is.null(max_col_width)) {
    openxlsx::setColWidths(wb, sheet, cols = seq_len(ncol(df)), widths = "auto")
  } else {
    # na.rm because nchar(NA_character_) is NA: an all-NA column would
    # otherwise fall into neither branch and lose its width entirely.
    content_width = mapply(function(x, nm) max(nchar(c(nm, as.character(x))),
                                               na.rm = TRUE),
                           df, colnames(df))
    auto_cols = which(content_width <= max_col_width)
    wide_cols = which(content_width > max_col_width)
    if (length(auto_cols) > 0) {
      openxlsx::setColWidths(wb, sheet, cols = auto_cols, widths = "auto")
    }
    if (length(wide_cols) > 0) {
      openxlsx::setColWidths(wb, sheet, cols = wide_cols, widths = max_col_width)
    }
  }
  char_cols <- which(sapply(df, is.character))
  if (length(char_cols) > 0) {
    text_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "@",
                                        wrapText = wrap_text)
    openxlsx::addStyle(wb, sheet, text_style,
                       rows = seq_len(nrow(df)) + 1,
                       cols = char_cols, gridExpand = TRUE)
  }
  date_cols <- which(sapply(df, inherits, what = c("POSIXct", "Date")))
  if (length(date_cols) > 0) {
    date_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "YYYY-MM-DD",
                                        wrapText = wrap_text)
    openxlsx::addStyle(wb, sheet, date_style,
                       rows = seq_len(nrow(df)) + 1,
                       cols = date_cols, gridExpand = TRUE)
  }
  for (col_name in intersect(pct_cols, colnames(df))) {
    col_idx  <- which(colnames(df) == col_name)
    col_vals <- df[[col_name]]
    pct_style <- openxlsx::createStyle(halign = "left", valign = "top", numFmt = "0%",
                                       wrapText = wrap_text)
    gen_style <- openxlsx::createStyle(halign = "left", valign = "top",
                                       wrapText = wrap_text)
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
