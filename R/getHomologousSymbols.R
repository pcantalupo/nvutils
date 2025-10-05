#' Convert Gene Symbols Between Species Using Orthologs
#'
#' Converts gene symbols from one species to their orthologous symbols in
#' another species using the orthogene package. For genes with multiple
#' orthologs (non-1:1 mappings), returns the most popular ortholog mapping.
#'
#' @param symbols Character vector of gene symbols to convert
#' @param current Character string specifying the input species. Default is
#'   "mouse". See \code{\link[orthogene]{convert_orthologs}} for supported
#'   species names.
#' @param target Character string specifying the output species. Default is
#'   "human". See \code{\link[orthogene]{convert_orthologs}} for supported
#'   species names.
#'
#' @return A data frame with the same number of rows as the input \code{symbols} vector.
#'   The data frame contains two columns: the input species symbols and their
#'   corresponding orthologous symbols in the target species. The input order
#'   is preserved. Genes without orthologs are represented as empty strings ("").
#'
#' @details
#' This function wraps \code{orthogene::convert_orthologs} to provide a
#' simplified interface for gene symbol conversion. When multiple orthologs
#' exist for a single input gene (non-1:1 mappings), the function uses the
#' \code{non121_strategy = "keep_popular"} option, which returns the most
#' "popular" interspecies ortholog mappings based on frequency across databases.
#'
#' Note that this strategy maximizes the number of genes returned but may include
#' some orthologs that are not true biological 1:1 orthologs due to evolutionary
#' gene duplication or divergence events.
#'
#' The function guarantees a 1:1 correspondence between input and output through
#' the use of \code{match()}, ensuring that each input gene has exactly one row
#' in the output, with empty strings ("") for genes without identified orthologs.
#'
#' @importFrom orthogene convert_orthologs
#' @export
#'
#' @seealso \code{\link[orthogene]{convert_orthologs}} for the underlying
#'   conversion function and full list of supported species
#'
#' @examples
#' # Convert mouse genes to human orthologs
#' mouse_genes <- c("Trp53", "Brca1", "Pbsn")
#' getHomologousSymbols(mouse_genes, current = "mouse", target = "human")
#'
#' # Convert human genes to mouse orthologs
#' human_genes <- c("TP53", "RB1", "FOXP3")
#' getHomologousSymbols(human_genes, current = "human", target = "mouse")
#'
#' # Convert between other species
#' getHomologousSymbols(c("Tp53", "Brca1"), current = "mouse", target = "rat")
#'
getHomologousSymbols <- function(symbols, current = "mouse", target = "human") {
  # Check if orthogene is available
  if (!requireNamespace("orthogene", quietly = TRUE)) {
    stop("Package 'orthogene' is required but not installed. ",
         "Install it with: BiocManager::install('orthogene')",
         call. = FALSE)
  }

  # Input validation
  if (!is.character(symbols) || length(symbols) == 0) {
    stop("symbols must be a non-empty character vector", call. = FALSE)
  }

  # Convert orthologs
  result <- orthogene::convert_orthologs(
    gene_df = symbols,
    input_species = current,
    output_species = target,
    gene_output = "columns",
    non121_strategy = "keep_popular"
  )

  # Match results back to input symbols to ensure 1:1 correspondence
  if (nrow(result) > 0) {
    target_symbols <- result$ortholog_gene[match(symbols, result$input_gene)]
  } else {
    target_symbols <- rep(NA, length(symbols))
  }

  # Create results data frame
  results <- data.frame(symbols, target_symbols, stringsAsFactors = FALSE)
  colnames(results) <- c(current, target)

  # Convert NA to blank strings
  results[is.na(results)] <- ""

  return(results)
}

