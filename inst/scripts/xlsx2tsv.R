#!/usr/bin/env Rscript
pacman::p_load('nvutils')

# Arguments
args = commandArgs(trailingOnly = TRUE)
file = args[1]      # file = "foo.xlsx"
outfile = args[2]   # outfile = "foo.tsv"
sheet = args[3]
verbose = args[4]     # verbose = TRUE

# Argument validation
stopifnot(file.exists(file))

if (is.na(outfile)) {
  outfile = paste0(tools::file_path_sans_ext(file), ".tsv")
}

if (is.na(sheet)) {
  sheet = 1  # when not set by user, set to default value of 1
} else {
  if (!is.na(as.integer(sheet))) {  # integer value used by user
    sheet = as.integer(sheet)
  }
}

if (is.na(verbose)) { verbose = FALSE }


# Convert XLSX to TSV
xlsx2tsv(file, outfile, sheet = sheet)


if (verbose == TRUE) {
  cat("\n\n")
  devtools::session_info()
}
