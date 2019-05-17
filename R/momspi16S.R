#' Construct MOMS-PI 16S rRNA phyloseq object
#'
#' The Multi-Omic Microbiome Study-Pregnancy Initiative (MOMS-PI)
#' was funded by the NIH Roadmap HUman Microbiome Project to
#' understand the impact of the vaginal microbiome
#' on pregnancy and the fetal microbiome. This longitudinal study
#' contains samples from various body sites of 596 women. This phyloseq
#' object contains the 16S rRNA sequencing data that was collected.
#' Also contained are the taxa data and participant metadata.
#'
#' @export
#' @format A phyloseq object with 7,665 taxa and 9,107 samples.
#' \subsection{OTU Table}{
#'     A counts matrix for the rRNA-seq results.
#' }
#' \subsection{Sample Data}{
#'    \describe{
#'       \item{file_id}{File identifier}
#'       \item{md5}{md5 hash for the file}
#'       \item{size}{file size}
#'       \item{urls}{URL for the file}
#'       \item{sample_id}{Sample identifier}
#'       \item{file_name}{Filename which the sample was taken from}
#'       \item{subject_id}{Participant identifier}
#'       \item{sample_body_site}{Body site of the sample}
#'       \item{visit_number}{Visit number}
#'       \item{subject_gender}{Participant gender}
#'       \item{subject_race}{Participant race}
#'       \item{study_full_name}{Name of the study}
#'       \item{project_name}{Name of project}
#'    }
#' }
#' \subsection{Taxonomy Table}{
#'     Taxonomy table for the taxa identified.
#' }
#'
#' @import phyloseq
#' @importFrom dplyr %>%
#' @import AnnotationHub
#' @import assertthat
#' @import ExperimentHub
#' @import kableExtra
#' @import knitr
#' @import magrittr
#' @import methods
#' @import readr
#' @import S4Vectors
#' @return a phyloseq object
#' @examples momspi <- momspi16S()
momspi16S <- function() {
  # load data
  data('momspi16S_mtx')
  data('momspi16S_samp')
  data('momspi16S_tax')

  # create phyloseq object
  momspi16S <- phyloseq(otu_table(momspi16S_mtx, taxa_are_rows = TRUE),
                        sample_data(momspi16S_samp),
                        tax_table(momspi16S_tax))
  return(momspi16S)
}
