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

# Column widths live in the sheet XML, not in anything read.xlsx() returns, so
# these helpers unzip the workbook and pull the <col> width attributes.
col_widths = function(path) {
  unz_dir = withr::local_tempdir()
  utils::unzip(path, exdir = unz_dir)
  xml = readLines(file.path(unz_dir, "xl", "worksheets", "sheet1.xml"),
                  warn = FALSE)
  cols = regmatches(xml, regexpr("<cols>.*</cols>", xml))
  as.numeric(gsub('width="|"', "",
                  regmatches(cols, gregexpr('width="[0-9.]+"', cols))[[1]]))
}

has_wrap_text = function(path) {
  unz_dir = withr::local_tempdir()
  utils::unzip(path, exdir = unz_dir)
  styles = paste(readLines(file.path(unz_dir, "xl", "styles.xml"), warn = FALSE),
                 collapse = "")
  grepl("wrapText", styles)
}

test_that("write_xlsx_pretty wraps cell contents by default", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(long = strrep("long text ", 40), stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile)

  expect_true(has_wrap_text(testoutfile))
})

test_that("write_xlsx_pretty wrap_text = FALSE leaves cells unwrapped", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(long = strrep("long text ", 40), stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, wrap_text = FALSE)

  expect_false(has_wrap_text(testoutfile))
})

test_that("write_xlsx_pretty caps wide columns at max_col_width", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(short = "x", long = strrep("long text ", 40),
                   stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, max_col_width = 100)

  widths <- col_widths(testoutfile)
  # openxlsx adds 0.71 padding to the width it writes
  expect_equal(widths[2], 100.71)
  # the short column keeps its auto-fitted width
  expect_lt(widths[1], 10)
})

test_that("write_xlsx_pretty leaves widths uncapped when max_col_width is NULL", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(long = strrep("long text ", 40), stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, max_col_width = NULL)

  # openxlsx's own auto-fit stops at Excel's 250-character ceiling
  expect_equal(col_widths(testoutfile)[1], 250.71)
})

test_that("write_xlsx_pretty keeps a width for an all-NA column", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  # nchar(NA_character_) is NA, so an all-NA column must not fall out of both
  # the auto and the capped branch and lose its width entirely.
  df <- data.frame(id = c("001", "002"), empty = NA_character_,
                   stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, max_col_width = 100)

  widths <- col_widths(testoutfile)
  expect_length(widths, 2)
  # width comes from the header name, "empty" (5 chars) + openxlsx's 0.71
  expect_equal(widths[2], 5.71)
})

test_that("write_xlsx_pretty max_col_width is configurable", {
  testoutfile <- withr::local_file("write_xlsx_pretty_test.xlsx")

  df <- data.frame(long = strrep("long text ", 40), stringsAsFactors = FALSE)
  write_xlsx_pretty(df, testoutfile, max_col_width = 30)

  expect_equal(col_widths(testoutfile)[1], 30.71)
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
