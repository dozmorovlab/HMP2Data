#' Create HMP2 16S sequencing data for Type 2 Diabetes (T2D) phyloseq object
#'
#' The HMP2 study gathered data on the microbiome for
#' patients with different disease. This dataset contains
#' 16S rRNA data for 79 patients with T2D over multiple visits.
#'
#' @export
#' @format A phyloseq object with 12,062 taxa and 2,208 samples.
#' \subsection{OTU Table}{
#'     A counts matrix for the rRNA-seq results.
#' }
#' \subsection{Sample Data}{
#'    \describe{
#'       \item{file_id}{The file ID}
#'       \item{sample_id}{Sample identifier}
#'       \item{file_name}{Name of file data was from}
#'       \item{subject_id}{Participant identifier}
#'       \item{sample_body_site}{Body site of the sample}
#'       \item{visit_number}{Visit number}
#'       \item{subject_gender}{Participant gender}
#'       \item{subject_race}{Participant race}
#'       \item{study_full_name}{Name of the study}
#'       \item{project_name}{Name of the project}
#'    }
#' }
#' \subsection{Taxonomy Table}{
#'     Taxonomy table for the taxa identified.
#' }
#' @return a phyloseq object
#' @examples T2D <- T2D16S()
T2D16S <- function() {
  # load data
  data('T2D16S_mtx')
  data('T2D16S_samp')
  data('T2D16S_tax')

  # create phyloseq object
  T2D16S <- phyloseq(otu_table(T2D16S_mtx, taxa_are_rows = TRUE),
                     sample_data(T2D16S_samp),
                     tax_table(T2D16S_tax))
  return(T2D16S)
}
