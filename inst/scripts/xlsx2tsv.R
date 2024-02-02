#!/usr/bin/env Rscript
pacman::p_load('nvutils')

args = commandArgs(trailingOnly = TRUE)
file = args[1]
outfile = args[2]
sheet = args[3]

if (is.na(sheet)) {
  sheet = 1  # when not set by user, set to default value of 1
} else {
  if (!is.na(as.integer(sheet))) {  # integer value used by user
    sheet = as.integer(sheet)
  }
}

# param na = "" means that 1) for empty fields and 2) for <NA> values in R,
# it writes the empty string ""
xlsx2tsv(file, outfile, sheet = sheet, na = "")


cat("\n\n")
devtools::session_info()
