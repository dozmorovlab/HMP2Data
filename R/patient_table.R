#' Generate patient summary table for HMP2 sample data
#'
#' This function allows you to produce a summary table for
#' the HMP2Data data sets.
#'
#' @param x A named list of phyloseq or SummarizedExperiment
#'     objects.
#' @return A knitr::kable table.
#' @export
#' @importFrom knitr kable
#' @importFrom kableExtra add_header_above
#' @importFrom data.table rbindlist
#' @examples
#' patient_table(list(momspi16S = momspi16S(),
#'   momspiCytokines = momspiCytokines(),
#'   IBD16S = IBD16S(), T2D16S = T2D16S()))
patient_table <- function(x) {
  # check that x is a named list
  if (! is(x, "list")) {
    stop("You must enter a named list")
  }
  if (is.null(names(x))) {
    stop("You must enter a named list")
  }
  # extract table info
  tables <- lapply(x, extract_info3)

  # merge columns
  if (length(tables) > 1) {
    vars <- tables[[1]]$variable
    tables <- lapply(tables, function(z) z[, -1])
    tables <- do.call(cbind, tables) %>% as.data.frame()
    tables <- cbind(vars, tables)
  } else {
    tables <- tables[[1]]
    colnames(tables)[1] <- 'vars'
  }
  # add in headers for sections
  tables$vars <- as.character(tables$vars)
  tables <- rbind(c("**Sex**", rep("", ncol(tables) - 1)), tables)
  tables <- rbind(tables[1:4,], c("**Race**", rep("", ncol(tables) - 1)), tables[5:12,])
  # replace underscores with spaces
  tables$vars <- gsub("_", " ", tables$vars)
  # set up extra column headers
  column_names <-
    c("N", "%") %>%
    rep(length(x)) %>%
    c("", .)
  colnames(tables) <- column_names
  header_names <-
    names(x) %>%
    c(" ", .)
  header_vector <-
    length(names(x)) %>%
    rep(2, .) %>%
    c(1, .) %>%
    as.character() %>%
    magrittr::set_names(header_names)
  rownames(tables) <- NULL
  final <- knitr::kable(tables) %>% kableExtra::kable_styling(bootstrap_options = "condensed", full_width = TRUE) %>%
    kableExtra::add_header_above(header = header_vector)
  return(final)
}




extract_info3 <- function(y) {
  # check if summarizedExperiment or phyloseq object
  if(is(y,"SummarizedExperiment")) {
    samp <- colData(y)
  }
  if(is(y, "phyloseq")) {
    samp <- sample_data(y)
  }
  if(!is(y, "SummarizedExperiment") & !is(y,"phyloseq")) {
    stop("Only enter phyloseq or SummarizedExperiment objects")
  }
  sex <- aggregate(samp$subject_gender, by = list(samp$subject_id), function(x) table(factor(x,
                                                                                               levels = c('male', 'female', 'unknown'))))
  race <- aggregate(samp$subject_race, by = list(samp$subject_id), function(x) table(factor(x,
                                                                                            levels = c('african_american', 'asian',
                                                                                                       'caucasian', 'ethnic_other',
                                                                                                       'hispanic_or_latino',
                                                                                                       'american_indian_or_alaska_native',
                                                                                                       'unknown'))))

  sex.tmp <- as.matrix(sex[,-1])
  sex.tmp <- colSums(sex.tmp > 0)
  race.tmp <- as.matrix(race[,-1])
  race.tmp <- colSums(race.tmp > 0)

  table <- data.frame(variable = c('male', 'female', 'unknown', 'african_american', 'asian',
                     'caucasian', 'ethnic_other',
                     'hispanic_or_latino',
                     'american_indian_or_alaska_native',
                     'unknown'),
             N = c(sex.tmp, race.tmp),
             percent = c(round(((sex.tmp/nrow(sex)) * 100), digits = 2),
                     round(((race.tmp/nrow(race)) * 100), digits = 2)))
  table$variable <- as.character(table$variable)
  table <- rbind(table, c("**Total patients**", nrow(sex), 100))
  return(table)
}
