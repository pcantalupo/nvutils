library(org.Hs.eg.db)
test_that("org.Hs.eg.db works (returned ids match order and length of the input ids)", {
  ids = c("TP53", "AKAP17A")
  idtype = "SYMBOL"
  res = annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
                    columns = c("ENSEMBL","GENENAME","GENETYPE"))
  expect_equal(res$SYMBOL, ids)
})

test_that("'keep' = TRUE works", {
  ids = c("TP53", "AKAP17A")
  idtype = "SYMBOL"
  res = annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
                    columns = c("ENSEMBL","GENENAME","GENETYPE"), keep = TRUE)

  # expect two rows for AKAP17A
  expect_true(unname(table(res$SYMBOL)["AKAP17A"] == 2))

  # remove the duplicate SYMBOLS and then expect that the returned ids match the input ids
  expect_equal(res$SYMBOL[!duplicated(res$SYMBOL)], ids)  # expect
})

test_that("non-existent IDs are handled correctly", {
  ids = c("TP53", "FOOBAR", "AKAP17A")
  idtype = "SYMBOL"
  res = annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
                    columns = c("ENSEMBL","GENENAME","GENETYPE"))
  expect_equal(res$SYMBOL, ids)
  expect_true(is.na(res$ENSEMBL[2]))
  expect_true(is.na(res$GENENAME[2]))
  expect_true(is.na(res$GENETYPE[2]))
})

test_that("different ID types work", {
  ids = c("7157", "22848")  # ENTREZ IDs for TP53 and AAK1
  idtype = "ENTREZID"
  res = annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
                    columns = c("SYMBOL","GENENAME","GENETYPE"))
  expect_equal(res$ENTREZID, ids)
  expect_equal(res$SYMBOL, c("TP53", "AAK1"))
})

test_that("empty input is handled correctly", {
  ids = character(0)
  idtype = "SYMBOL"
  res = annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
                    columns = c("ENSEMBL","GENENAME","GENETYPE"))
  expect_equal(nrow(res), 0)
  expect_equal(ncol(res), 4)
})


