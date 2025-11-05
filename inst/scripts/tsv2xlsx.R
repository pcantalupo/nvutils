#!/usr/bin/env Rscript
pacman::p_load('nvutils')

# Arguments
args = commandArgs(trailingOnly = TRUE)
file = args[1]      # file = "example_tsv.tsv"
outfile = args[2]   # outfile = "foo.xlsx"
verbose = args[3]     # verbose = TRUE

# Argument validation
stopifnot(file.exists(file))
if (is.na(outfile)) {
  outfile = paste0(tools::file_path_sans_ext(file), ".xlsx")
}
if (is.na(verbose)) { verbose = FALSE }


# Convert TSV to XLSX
tsv2xlsx(file, outfile, colClasses = "character", na.strings = NULL)


if (verbose == TRUE) {
  cat("\n\n")
  devtools::session_info()
}

