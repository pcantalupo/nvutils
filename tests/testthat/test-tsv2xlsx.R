# This just checks that the XLSX output file exists
test_that("tsv2xlsx outputs the excel file", {
  testoutfile = "tsv2xlsx_test.xlsx"
  suppressWarnings(file.remove(testoutfile)) # remove excel file if already exists

  tsv2xlsx("example_tsv.tsv", testoutfile)
  expect_equal(file.exists(testoutfile), TRUE)

  file.remove(testoutfile)  # remove excel file
})
