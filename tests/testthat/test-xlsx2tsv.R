test_that("xlsx2tsv writes NA values in numeric columns as NA string", {
  testoutfile <- "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))

  xlsx2tsv("example_xlsx.xlsx", testoutfile)

  # Line 3 (Dec-19 row): NA in numeric column should end with NA
  expect_true(endsWith(readLines(testoutfile)[3], "NA"))

  file.remove(testoutfile)
})

test_that("xlsx2tsv writes blank cells in numeric columns as blank fields", {
  testoutfile <- "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))

  xlsx2tsv("example_xlsx.xlsx", testoutfile)

  # Line 5 (15-Feb row): blank cell in numeric column should end with \t
  expect_true(endsWith(readLines(testoutfile)[5], "\t"))

  file.remove(testoutfile)
})

test_that("xlsx2tsv writes blank cells in character columns as blank fields", {
  testoutfile <- "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))

  xlsx2tsv("example_xlsx.xlsx", testoutfile)

  # Line 6 (17-Mar-23 row): blank in character column, followed by numeric 0
  expect_true(endsWith(readLines(testoutfile)[6], "\t\t0"))

  file.remove(testoutfile)
})

test_that("xlsx2tsv uses the sheet param correctly", {
  testoutfile <- "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))

  xlsx2tsv("example_xlsx.xlsx", testoutfile, sheet = "Sheet2")
  expect_true(readLines(testoutfile) == "sheet2\tsheet2_col2")

  file.remove(testoutfile)
})

test_that("xlsx2tsv stops on missing arguments", {
  expect_error(xlsx2tsv(), "Usage")
  expect_error(xlsx2tsv("nonexistent.xlsx", "out.tsv"), "not found")
})
