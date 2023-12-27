test_that("waldo_compare_files requires file1 and file2 params", {
  expect_error(waldo_compare_files("foo.txt"), "file1 and file2 params are required")
})
