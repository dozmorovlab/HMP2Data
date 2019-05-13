#' Make MOMS-PI MultiAssayExperiment
#'
#' Construct MultiAssayExperiment for MOMS-PI 16S rRNA
#' and cytokines data.
#'
#' @format A MultiAssayExperiment object with a 16S rRNA matrix and Cytokine matrix
#' \subsection{16S}{
#'     A counts matrix for the 16S rRNA-seq results.
#' }
#' \subsection{cytokines}{
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
#' @return A multiAssay Experiment object
#' @import MultiAssayExperiment
#' @importFrom dplyr id
#' @export
#' @examples momspiMA <- momspiMultiAssay()
momspiMultiAssay <- function() {
  # load MOMS-PI data
  data("momspi16S_mtx")
  data("momspi16S_samp")
  data("momspiCyto_mtx")
  data("momspiCyto_samp")
  # # Metadata for the 16S and cytokine data
  # momspi_16S_participants         <- momspi16S_samp
  # momspi_cytokine_participants    <- momspiCyto_samp
  # # Common participants should have the same "subject_id", "sample_body_site", "visit_number", "subject_gender", "subject_race", "study_full_name", "project_name"
  # momspi_common_participants <- inner_join(as.data.frame(momspi_16S_participants), as.data.frame(momspi_cytokine_participants),
  #                                          by = c("subject_id", "sample_body_site", "visit_number", "subject_gender", "subject_race", "study_full_name", "project_name"))
  # # Subset the 16S and cytokine data to the common participants
  # momspi16S_mtx_common  <- momspi16S_mtx[, colnames(momspi16S_mtx) %in% momspi_common_participants$file.x]
  # # all.equal(colnames(momspi16S_mtx_common), momspi_common_participants$file.x[match(colnames(momspi16S_mtx_common), momspi_common_participants$file.x)]) # Must be TRUE
  # momspiCyto_mtx_common <- momspiCyto_mtx[, colnames(momspiCyto_mtx) %in% momspi_common_participants$file.y]
  # # all.equal(colnames(momspiCyto_mtx_common), momspi_common_participants$file.y[match(colnames(momspiCyto_mtx_common), momspi_common_participants$file.y)]) # Must be TRUE
  # # Make sample names as a combination of the 16S and cytokine file names
  # common_names <- paste(colnames(momspi16S_mtx_common), colnames(momspiCyto_mtx_common), sep = ".")
  # colnames(momspi16S_mtx_common)  <- common_names
  # colnames(momspiCyto_mtx_common) <- common_names
  # rownames(momspi_common_participants) <- common_names
  # # Combine into multiAssayExperiment
  # momspiMA <- MultiAssayExperiment(experiments = ExperimentList(`16S` = momspi16S_mtx_common, cytokines = momspiCyto_mtx_common), colData = momspi_common_participants)


  # make colData
  # add new ID
  momspi16S_samp$id  <- paste0('a', 1:nrow(momspi16S_samp))
  momspiCyto_samp$id <- paste0('b', 1:nrow(momspiCyto_samp))
  # merge
  common_participants <- dplyr::inner_join(momspi16S_samp, momspiCyto_samp,
                                          by = c("subject_id", "sample_body_site", "visit_number",
                                                 "subject_gender", "subject_race", "study_full_name",
                                                 "project_name"))
  # Get sample data for samples not in merged data.frame
  uncommon <- rbind(momspi16S_samp[! momspi16S_samp$id %in% common_participants$id.x, ],
                    momspiCyto_samp[! momspiCyto_samp$id %in% common_participants$id.y, ])
  # merge common IDs
  common_participants$id   <- paste0(common_participants$id.x, common_participants$id.y)
  # merge file names
  common_participants$file <- paste(common_participants$file.x, common_participants$file.y, sep = '.')
  # merge sample ids
  common_participants$sample_id <- paste(common_participants$sample_id.x, common_participants$sample_id.y, sep = '.')
  # make sample data.frame, using the same columns line "uncommon" object
  samp <- rbind(common_participants[, colnames(uncommon)],
                uncommon)


  rownames(samp) <- samp$file
  # Drop "file" column
  samp <- dplyr::select(samp, select = -c(file))
  ids <- rownames(samp)
  # set up sampleMap
  # assay column: the name of the assay, and found in the names of ExperimentList list names
  # primary column: identifiers of patients or biological units, and found in the row names of colData
  # colname column: identifiers of assay results, and found
  #     in the column names of ExperimentList elements Helper functions are available for creating a map from a list. See ?listToMap
  # make assay vector
  assay_common <- grepl("\\.", ids)   # Dot-separated IDs
  assay_rna    <- grepl("a", samp$id) # IDs that start with "a"
  # make map for the samples not in common between 16S and cytokines
  map_uncommon <- data.frame(assay   = ifelse(assay_rna, "16S", "cytokines")[!assay_common],
                             primary = rownames(samp)[!assay_common],
                             colname = rownames(samp)[!assay_common],
                             stringsAsFactors = FALSE)
  # make map for the samples in common between 16S and cytokines
  map_common <- data.frame(assay   = c(rep("16S", sum(assay_common)), rep("cytokines", sum(assay_common))),
                           primary = c(rownames(samp)[assay_common], rownames(samp)[assay_common]),
                           colname = c(gsub("\\..*$", "", rownames(samp)[assay_common]), gsub("^.*\\.", "", rownames(samp)[assay_common])),
                           stringsAsFactors = FALSE)
  map <- rbind(map_common, map_uncommon)

  # drop "id" column for sample data
  samp <- dplyr::select(samp, select = -c(id))
  # make multiassay object
  momspiMA <- MultiAssayExperiment(experiments = ExperimentList(`16S` = momspi16S_mtx, cytokines = momspiCyto_mtx),
                                   colData     = samp,
                                   sampleMap   = map)

  return(momspiMA)
}
