#' @title Annotate biological IDs with AnnotationDbi::select
#' @description
#' This function annotates biological identifiers such as Symbols, ENSEMBLIDs, and more. It requires the appropriate AnnotationDb object (OrgDB, EnsDb) that contains your identifiers of interest. Then you choose what fields (i.e. columns) to annotate your input IDs.
#'
#' @param db An AnnotationDb object (i.e org.Hs.eg.db)
#' @param ids Input IDs (i.e. TP53)
#' @param idtype The type of input IDs (i.e. SYMBOL)
#' @param columns The output annotation fields that you want (i.e. ENSEMBL)
#' @param keep Keep all multiple values returned by select() (default: FALSE)
#' @param allowable Show the columns that are available for the database object
#' as input and output (default: FALSE)
#'
#' @return A data.frame in the same order and length as your input ids (but see
#' 'keep' param)
#' @export
#' @importFrom AnnotationDbi select
#'
#' @examples
#' # Using OrgDb database
#' library(org.Hs.eg.db)
#'
#' # Show allowable columns
#' annotateids(org.Hs.eg.db, allowable = TRUE)
#'
#' # Keep all multi values. Notice that multiple rows are returned for AKAP17A
#' ids = c("TP53", "AKAP17A")
#' idtype = "SYMBOL"
#' annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
#'             columns = c("ENSEMBL","GENENAME","GENETYPE"), keep = TRUE)
#'
#' # Default action is to remove multi values
#' annotateids(org.Hs.eg.db, ids = ids, idtype = idtype,
#'             columns = c("ENSEMBL","GENENAME","GENETYPE"))
#'
#' \dontrun{
#' # Using EnsDb database (EnsDb object) from AnnotationHub
#' ah = AnnotationHub::AnnotationHub()
#' query(ah, c("EnsDb", "Homo sapiens"))  # accession AH116291 is version 111
#' edb = query(ah, pattern = c("Homo sapiens", "EnsDb", 111))[[1]]
#' ids = c("ENSG00000141510", "ENSG00000236362")
#'
#' annotateids(edb, ids = ids, idtype = "GENEID",
#'             columns = c("SYMBOL","DESCRIPTION","GENEBIOTYPE"))
#' }
annotateids = function(db, ids, idtype, columns, keep = FALSE, allowable = FALSE) {
  if (allowable) {
    message("Supported input ids for this database")
    print(AnnotationDbi::keytypes(db))
    message("\nSupported columns to choose from to annotate your ids from this database")
    print(AnnotationDbi::columns(db))
  } else {
    if (missing(db)) stop("The 'db' parameter must be supplied [i.e. org.Hs.eg.db].")
    if (missing(ids)) stop("The 'ids' parameter must be supplied [i.e. c('TP53')].")
    if (missing(idtype)) stop("The 'idtype' parameter must be supplied [i.e. c('SYMBOL')].")
    if (missing(columns)) stop("The 'columns' parameter must be supplied [i.e. c('GENENAME')].")

    # Query the database
    res = AnnotationDbi::select(db, keys = ids, keytype = idtype, columns = columns)

    # Create data.frame with all input IDs
    all_ids = data.frame(id = ids)
    names(all_ids)[1] = idtype

    # Merge results with the input IDs which will keep all matches
    res = merge(all_ids, res, by = idtype, all.x = TRUE)

    if (keep) {
      message("\nCareful: there might be multiple rows for each id since you chose 'keep' == TRUE")
      # Sort the result to maintain the original order of the ids
      res = res[order(match(res[, idtype], ids)), ]
    } else {
      message("\nReturning a unique row for each id")
      # Keep only the first match for each id
      res = res[match(ids, res[, idtype]),]
    }

    # 'res' is a data.frame. 1st column is the idtype (i.e. SYMBOL) and then N columns to match the 'column' param (i.e. ENSEMBL, etc...)
    rownames(res) = NULL
    return(res)
  }
}

