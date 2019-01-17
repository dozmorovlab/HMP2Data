#' Make MOMS-PI MultiAssayExperiment
#'
#'
#'
momspiMultiAssay <- function() {
  # load MOMS-PI data
  data("momspi16S")
  data("momspiCytokines")
  # pull out matrices
  rna_mat <- otu_table(momspi16S) %>% as.matrix()
  rna_samp <- sample_data(momspi16S)
}
