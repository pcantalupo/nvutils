test_that("write_xlsx_pretty writes the excel file and round-trips data", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(id = c("001", "002"), value = c(10, 20),
                   stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile)

  expect_true(file.exists(testoutfile))

  result <- read.xlsx(testoutfile)
  expect_equal(result$value, c(10, 20))
})

test_that("write_xlsx_pretty preserves leading zeros in character columns", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(id = c("001", "002"), stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile)

  result <- read.xlsx(testoutfile)
  expect_equal(result$id, c("001", "002"))
})

test_that("write_xlsx_pretty adds a row-names column when rownames_col is set", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(value = c(1, 2))
  rownames(df) <- c("a", "b")
  write_xlsx_pretty(df, testoutfile, rownames_col = "name")

  result <- read.xlsx(testoutfile)
  expect_equal(colnames(result)[1], "name")
  expect_equal(result$name, c("a", "b"))
})

test_that("write_xlsx_pretty pct_cols writes numeric percentages as numbers and keeps text", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(id = 1:2, Chemo_Response = c("0.9", "<90%"),
                   stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, pct_cols = "Chemo_Response")

  # numeric entry comes back as a number, text entry stays as text
  result <- read.xlsx(testoutfile)
  expect_equal(as.numeric(result$Chemo_Response[1]), 0.9)
  expect_equal(result$Chemo_Response[2], "<90%")
})
