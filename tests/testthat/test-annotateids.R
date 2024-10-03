library(org.Hs.eg.db)
test_that("returned ids match order and length of the input ids", {
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

