#' Create HMP2 16S sequencing data for Inflammatory Bowel Disease (IBD) phyloseq object
#'
#' The HMP2 study gathered data on the microbiome for
#' patients with different disease. This dataset contains
#' 16S rRNA data for 196 patients with IBD over multiple visits.
#'
#' @export
#' @format A phyloseq object with 982 taxa and 178 samples.
#' \subsection{OTU Table}{
#'     A counts matrix for the rRNA-seq results.
#' }
#' \subsection{Sample Data}{
#'    \describe{
#'       \item{Project}{Name of the project}
#'       \item{sample_id}{Sample identifier}
#'       \item{subject_id}{Subject identifier}
#'       See colnames(sample_data(IBD16S())) for remaining values.
#'    }
#' }
#' \subsection{Taxonomy Table}{
#'     Taxonomy table for the taxa identified.
#' }
#' @return a phyloseq object
#' @examples IBD <- IBD16S()
IBD16S <- function() {
  # load data
  data('IBD16S_mtx')
  data('IBD16S_samp')
  data('IBD16S_tax')

  # create phyloseq object
  IBD16S <- phyloseq(otu_table(IBD16S_mtx, taxa_are_rows = TRUE),
                        sample_data(IBD16S_samp),
                        tax_table(IBD16S_tax))
  return(IBD16S)
}

