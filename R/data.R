#' Single cell RNAseq metadata from Segerstolpe Pancreas Data
#'
#' A subset of data from the Segerstolpe Pancreas Data. Four donors were removed to
#' simplify the data. 3 normal and 3 disease donors remain. Donor id is converted into a
#' 'sample' id (i.e. C1, D1) to signify normal (i.e. control) or disease. Note: there is
#' no cluster metadata.
#'
#' @format
#' A data.frame with 2,269 rows and 7 columns:
#' \describe{
#'   \item{donor}{The donor id (6 unique donors) (chr)}
#'   \item{sample}{Donor id is converted to C1, C2, and C3 for the normal donors and D1, D2, D3 for disease donors (chr)}
#'   \item{disease}{Disease status. Either 'normal' or 'type II diabetes mellitus' (chr)}
#'   \item{celltype}{The celltype of the cell (n = 14). Contains <NA>. (chr)}
#'   \item{sex}{Donor sex (chr)}
#'   \item{age}{Donor age (int)}
#'   \item{body_mass_index}{Donor BMI (num)}
#' }
#' @references Bioconductor scRNAseq package <https://bioconductor.org/packages/release/data/experiment/html/scRNAseq.html>
#' @references Segerstolpe A et al. (2016). Single-cell transcriptome profiling of
#' human pancreatic islets in health and type 2 diabetes. Cell Metab. 24(4), 593-607.
"sctdata"


#' Polychrome color palette (visual impact over colorblind accessibility)
#'
#' Philosophy: Maximizes perceptual distance between colors using algorithmic methods
#' Uses computational optimization to create colors as visually distinct as possible
#' Prioritizes visual impact and distinctness over colorblind accessibility
#' Best for when you need maximum color separation
#'
#' @format A character vector of 25 hex color codes
#' @source Created with Polychrome::createPalette(25, c("#FF0000", "#00FF00", "#0000FF"), range = c(30, 80))
"colors_polychrome"

#' dittoSeq/Okabe-Ito (colorblind safe)
#'
#' Philosophy: Accessibility-first design optimized for scientific visualization
#' Based on Okabe-Ito colorblind-safe palette with systematic brightness variations
#' Specifically designed to be distinguishable by people with common colorblindness
#' Optimized for complex multi-group genomics visualizations
#' Best for scientific publications and colorblind-accessible visualizations
#'
#' @format A character vector of 40 hex color codes
#' @source \url{https://github.com/dtm2451/dittoSeq/}
"colors_ditto"


