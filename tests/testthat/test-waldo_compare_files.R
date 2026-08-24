test_that("waldo_compare_files requires file1 and file2 params", {
  expect_error(waldo_compare_files("foo.txt"), "file1 and file2 params are required")
})

test_that("waldo_compare_files compares every sheet of an xlsx file", {
  file1 = withr::local_file("multisheet1.xlsx")
  file2 = withr::local_file("multisheet2.xlsx")
  openxlsx::write.xlsx(list(alpha = data.frame(x = c(1, 2)),
                            beta  = data.frame(z = c(3, 4))), file = file1)
  openxlsx::write.xlsx(list(alpha = data.frame(x = c(1, 5)),
                            gamma = data.frame(z = c(3, 4))), file = file2)

  capture.output(result <- waldo_compare_files(file1, file2))
  result = paste(result, collapse = "\n")

  expect_match(result, "old\\$alpha vs new\\$alpha")   # diff beyond the first sheet
  expect_match(result, "`new\\$beta` is absent")       # sheet only in file1
  expect_match(result, "`old\\$gamma` is absent")      # sheet only in file2
})

test_that("waldo_compare_files reports no differences for identical xlsx sheets", {
  sheets = list(alpha = data.frame(x = c(1, 2)), beta = data.frame(z = c(3, 4)))
  file1 = withr::local_file("identical1.xlsx")
  file2 = withr::local_file("identical2.xlsx")
  openxlsx::write.xlsx(sheets, file = file1)
  openxlsx::write.xlsx(sheets, file = file2)

  capture.output(result <- waldo_compare_files(file1, file2))
  expect_length(result, 0)
})
