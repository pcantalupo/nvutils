#!/usr/bin/env Rscript
# Load only optparse up front so --help and arg errors return fast; nvutils
# (and its openxlsx/tibble/stringr deps) is loaded after validation passes.
pacman::p_load('optparse')

# Arguments
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "Input data file (.tsv, .txt, or .xlsx) [required]"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "Output XLSX path [default: input basename + _pretty.xlsx]"),
  make_option("--sheet", type = "integer", default = NULL,
              help = paste("Sheet number to read from an xlsx input. If omitted",
                           "and the workbook has more than one sheet, the script",
                           "errors rather than guess [default: sole sheet]")),
  make_option("--rownames_col", type = "character", default = NULL,
              help = "If set, move row names into a first column with this name"),
  make_option("--pct_cols", type = "character", default = NULL,
              help = paste("Comma-separated column names holding mixed numeric",
                           "percentages and text (e.g. 0.9 shown as 90%, '<90%'",
                           "kept as text)")),
  make_option("--zoom", type = "integer", default = 170L,
              help = "Initial worksheet zoom percentage [default: %default]"),
  make_option("--max_col_width", type = "integer", default = 100L,
              help = paste("Cap column width at this many characters, matching",
                           "Excel's Column Width dialog. Use 0 for no cap",
                           "[default: %default]")),
  make_option("--no_wrap_text", action = "store_true", default = FALSE,
              help = paste("Do not wrap cell contents. By default cells wrap so",
                           "a value longer than its column does not spill across",
                           "neighbouring cells")),
  make_option("--infer_types", action = "store_true", default = FALSE,
              help = paste("Let fread infer column types instead of reading all",
                           "columns as text (numeric columns become numbers;",
                           "leading zeros in ID-like columns may be lost)"))
)

parser <- OptionParser(option_list = option_list)
opt <- parse_args(parser)

# Argument validation
if (is.null(opt$input)) {
  print_help(parser)
  stop("--input is required")
}
if (!file.exists(opt$input)) {
  stop("input file not found: ", opt$input)
}

# Load the package only after args validate
pacman::p_load('nvutils')

# Read input by extension
ext <- tolower(tools::file_ext(opt$input))
if (ext == "xlsx") {
  sheets <- openxlsx::getSheetNames(opt$input)
  if (is.null(opt$sheet)) {
    if (length(sheets) > 1) {
      stop("input has ", length(sheets), " worksheets (",
           paste(sheets, collapse = ", "),
           "); re-run with --sheet to choose one")
    }
    sheet_to_read <- 1L
  } else {
    sheet_to_read <- opt$sheet
  }
  data <- openxlsx::read.xlsx(opt$input, sheet = sheet_to_read)
} else if (ext %in% c("tsv", "txt", "")) {
  if (opt$infer_types) {
    data <- data.table::fread(opt$input, na.strings = NULL, data.table = FALSE)
  } else {
    data <- data.table::fread(opt$input, colClasses = "character",
                              na.strings = NULL, data.table = FALSE)
  }
} else {
  stop("unsupported input extension '", ext, "'; use .tsv, .txt, or .xlsx")
}

# Derive output path if not supplied
output <- opt$output
if (is.null(output)) {
  output <- paste0(tools::file_path_sans_ext(opt$input), "_pretty.xlsx")
}

# Split comma-separated percent columns into a character vector
pct_cols <- character(0)
if (!is.null(opt$pct_cols)) {
  pct_cols <- trimws(strsplit(opt$pct_cols, ",")[[1]])
}

# 0 is the CLI spelling of "no cap", which the function takes as NULL
max_col_width = opt$max_col_width
if (max_col_width <= 0) {
  max_col_width = NULL
}

# Write the prettified workbook
write_xlsx_pretty(data, output,
                  zoom = opt$zoom,
                  rownames_col = opt$rownames_col,
                  pct_cols = pct_cols,
                  max_col_width = max_col_width,
                  wrap_text = !opt$no_wrap_text)

cat("Wrote", output, "\n")

cat("\n\n")
devtools::session_info()
