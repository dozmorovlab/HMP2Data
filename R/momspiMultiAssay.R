#' Make MOMS-PI MultiAssayExperiment
#'
#' Construct MultiAssayExperiment for MOMS-PI 16S rRNA
#' and cytokines data.
#'
#' @format A MultiAssayExperiment object with a 16S rRNA matrix and Cytokine matrix
#' \subsection{rRNA}{}
#'     A counts matrix for the rRNA-seq results.
#' }
#' \subsection{cytokines} {
#'     A counts matrix for the cytokines results.
#' }
#' \subsection{colData}{
#'    \describe{
#'       \item{sample_id}{Sample identifier}
#'       \item{subject_id}{Participant identifier}
#'       \item{sample_body_site}{Body site of the sample}
#'       \item{visit_number}{Visit number}
#'       \item{subject_gender}{Participant gender}
#'       \item{subject_race}{Participant race}
#'       \item{study_full_name}{Name of the study}
#'       \item{file}{Filename which the sample was taken from}
#'    }
#' }
#' @import MultiAssayExperiment
#' @export
#' @examples momspiMA <- momspiMultiAssay()
momspiMultiAssay <- function() {
  # load MOMS-PI data
  data("momspi16S_mtx")
  data("momspi16S_samp")
  data("momspiCyto_mtx")
  data("momspiCyto_samp")
  # combine into multiAssayExperiment
  momsMultiAssay <- MultiAssayExperiment(experiments = ExperimentList(rRNA = momspi16S_mtx, cytokines = momspiCyto_mtx),
                                         colData = rbind(momspi16S_samp, momspiCyto_samp))
  return(momsMultiAssay)
}
