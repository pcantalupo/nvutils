test_that("xlsx2tsv outputs the TSV file", {
  testoutfile = "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))  # remove the test file if already exists

  xlsx2tsv("example_xlsx.xlsx", testoutfile)
  expect_equal(file.exists(testoutfile), TRUE)

  file.remove(testoutfile)  # remove the test file
})


test_that("xlsx2tsv uses the 'na' param appropriately", {
  testoutfile = "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))  # remove the test file if already exists

  # Do not output NA but rather ""
  xlsx2tsv("example_xlsx.xlsx", testoutfile, na = "")
  # The 5th line ends with a \t since the 3rd field is the empty string.
  expect_equal(endsWith(readLines(testoutfile)[5], "\t"), TRUE)

  file.remove(testoutfile)  # remove the test file
})


test_that("xlsx2tsv uses the sheet param corectly", {
  testoutfile = "xlsx2tsv_test.tsv"
  suppressWarnings(file.remove(testoutfile))  # remove the test file if already exists

  # Do not output NA but rather ""
  xlsx2tsv("example_xlsx.xlsx", testoutfile, sheet = "Sheet2")
  # The 5th line ends with a \t since the 3rd field is the empty string.
  expect_equal(readLines(testoutfile) == "sheet2\tsheet2_col2", TRUE)

  file.remove(testoutfile)  # remove the test file
})

