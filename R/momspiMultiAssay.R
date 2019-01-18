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
  # Metadata for the 16S and cytokine data
  momspi_16S_participants         <- sample_data(momspi)
  momspi_cytokine_participants    <- colData(momspiCyto)
  # Common participants should have the same "subject_id", "sample_body_site", "visit_number", "subject_gender", "subject_race", "study_full_name", "project_name"
  momspi_common_participants <- inner_join(as.data.frame(momspi_16S_participants), as.data.frame(momspi_cytokine_participants),
                                           by = c("subject_id", "sample_body_site", "visit_number", "subject_gender", "subject_race", "study_full_name", "project_name"))
  # Subset the 16S and cytokine data to the common participants
  momspi16S_mtx_common  <- momspi16S_mtx[, colnames(momspi16S_mtx) %in% momspi_common_participants$file.x]
  # all.equal(colnames(momspi16S_mtx_common), momspi_common_participants$file.x[match(colnames(momspi16S_mtx_common), momspi_common_participants$file.x)]) # Must be TRUE
  momspiCyto_mtx_common <- momspiCyto_mtx[, colnames(momspiCyto_mtx) %in% momspi_common_participants$file.y]
  # all.equal(colnames(momspiCyto_mtx_common), momspi_common_participants$file.y[match(colnames(momspiCyto_mtx_common), momspi_common_participants$file.y)]) # Must be TRUE
  # Make sample names as a combination of the 16S and cytokine file names
  common_names <- paste(colnames(momspi16S_mtx_common), colnames(momspiCyto_mtx_common), sep = ".")
  colnames(momspi16S_mtx_common)  <- common_names
  colnames(momspiCyto_mtx_common) <- common_names
  rownames(momspi_common_participants) <- common_names
  # Combine into multiAssayExperiment
  momspiMA <- MultiAssayExperiment(experiments = ExperimentList(`16S` = momspi16S_mtx_common, cytokines = momspiCyto_mtx_common), colData = momspi_common_participants)

  return(momspiMA)
}
