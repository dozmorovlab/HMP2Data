#' Create MOMS-PI cytokines SummarizedExperiment object
#'
#' The Multi-Omic Microbiome Study-Pregnancy Initiative (MOMS-PI)
#' was funded by the NIH Roadmap HUman Microbiome Project to
#' understand the impact of the vaginal microbiome
#' on pregnancy and the fetal microbiome. This longitudinal study
#' contains samples from three body sites of 116 women.
#' This summarizedExperiment
#' object contains the cytokine data that was collected and
#' the participant metadata.
#'
#' @export
#' @format A SummarizedExperiment object with 29 features
#' and 872 samples.
#' \subsection{colData}{
#'      \describe{
#'      \item{sample_id}{Sample identifier}
#'     \item{subject_id}{Participant identifier}
#'     \item{sample_body_site}{Body site of the sample}
#'     \item{visit_number}{Visit number}
#'     \item{subject_gender}{Participant gender}
#'     \item{subject_race}{Participant race}
#'     \item{study_full_name}{Name of the study}
#'     \item{file}{Filename which the sample was taken from}
#'      }
#' }
#'
#'
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @return A SummarizedExperiment object
#' @examples momspiCyto <- momspiCytokines()
momspiCytokines <- function() {
  # load data
  data('momspiCyto_mtx')
  data('momspiCyto_samp')

  # create phyloseq object
  momspiCytokines <- SummarizedExperiment(momspiCyto_mtx, colData = momspiCyto_samp,
                                          rowData = data.frame(cytokine = rownames(momspiCyto_mtx)))
  return(momspiCytokines)
}


