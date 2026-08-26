#!/usr/bin/env Rscript
# Load only optparse up front so --help and arg errors return fast; nvutils
# (and its dependencies) is loaded after validation passes.
pacman::p_load('optparse')

# Arguments
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "Input XLSX file [required]"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "Output TSV path [default: input basename + .tsv]"),
  make_option("--sheet", type = "character", default = "1",
              help = "Sheet number or sheet name to read [default: %default]"),
  make_option(c("-v", "--verbose"), action = "store_true", default = FALSE,
              help = "Print session_info() after writing")
)

parser <- OptionParser(option_list = option_list)
# positional_arguments = TRUE keeps getopt from erroring out on a bare
# argument, so leftovers are reported here with the full help instead
parsed <- parse_args(parser, positional_arguments = TRUE)
opt <- parsed$options

if (length(parsed$args) > 0) {
  print_help(parser)
  stop("unexpected argument(s): ", paste(parsed$args, collapse = ", "),
       "\n  all arguments must be given as named flags (see usage above)")
}

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

# Derive output path if not supplied
output <- opt$output
if (is.null(output)) {
  output <- paste0(tools::file_path_sans_ext(opt$input), ".tsv")
}

# A sheet given as digits is an index; anything else is a sheet name
sheet <- opt$sheet
if (grepl("^[0-9]+$", sheet)) {
  sheet <- as.integer(sheet)
}

# Convert XLSX to TSV
xlsx2tsv(opt$input, output, sheet = sheet)

if (opt$verbose) {
  cat("\n\n")
  devtools::session_info()
}
