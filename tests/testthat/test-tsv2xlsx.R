# Test tsv file
tsv_lines = c("col1\tcol2\tcol3\tcol4\tcol5\tcol6",
              "1.25\t\t001\tNA\t\tred",
              "2.9\t2\t\t002\tblue\tNA",
              "NA\t3\t003\t003\tbrown\tgreen")

test_that("tsv2xlsx outputs the excel file", {
  testoutfile <- "tsv2xlsx_test.xlsx"
  test_tsv <- "test_types.tsv"
  suppressWarnings(file.remove(testoutfile, test_tsv))

  writeLines(tsv_lines, test_tsv)

  tsv2xlsx(test_tsv, testoutfile)

  expect_true(file.exists(testoutfile))

  file.remove(test_tsv)
  file.remove(testoutfile)
})

test_that("tsv2xlsx preserves blank fields as empty strings", {
  testoutfile <- "tsv2xlsx_test.xlsx"
  test_tsv <- "test_types.tsv"
  suppressWarnings(file.remove(testoutfile, test_tsv))

  writeLines(tsv_lines, test_tsv)

  tsv2xlsx(test_tsv, testoutfile)

  result <- read.xlsx(testoutfile, na.strings = NULL)
  expect_equal(result[1, 2], "")
  expect_equal(result[1, 5], "")
  expect_equal(result[2, 3], "")

  file.remove(test_tsv)
  file.remove(testoutfile)
})

test_that("tsv2xlsx preserves literal NA string as 'NA' string", {
  testoutfile <- "tsv2xlsx_test.xlsx"
  test_tsv <- "test_types.tsv"
  suppressWarnings(file.remove(testoutfile, test_tsv))

  writeLines(tsv_lines, test_tsv)

  tsv2xlsx(test_tsv, testoutfile)

  result <- read.xlsx(testoutfile, na.strings = NULL)
  expect_equal(result[3, 1], "NA")
  expect_equal(result[1, 4], "NA")
  expect_equal(result[2, 6], "NA")

  file.remove(test_tsv)
  file.remove(testoutfile)
})

test_that("tsv2xlsx preserves leading zeros", {
  testoutfile <- "tsv2xlsx_test.xlsx"
  test_tsv <- "test_types.tsv"
  suppressWarnings(file.remove(testoutfile, test_tsv))

  writeLines(tsv_lines, test_tsv)

  tsv2xlsx(test_tsv, testoutfile)

  result <- read.xlsx(testoutfile, na.strings = NULL)
  expect_equal(result[1, 3], "001")
  expect_equal(result[2, 4], "002")

  file.remove(testoutfile)
  file.remove(test_tsv)
})

