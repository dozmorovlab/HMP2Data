#' Generate table for HMP2 sample data
#'
#'
table_two <- function(x) {
  # extract table info
  tables <- lapply(x, extract_info)
  # merge tables into final table
  tables <- lapply(tables, function(y) {
    y <- lapply(y, as.data.frame)
    y <- data.table::rbindlist(y)
    return(y)
  })
}



extract_info <- function(x) {
  # check if summarizedExperiment or phyloseq object
  if(class(x) == "SummarizedExperiment") {
    samp <- colData(x)
  }
  if(class(x) == "phyloseq") {
    samp <- sample_data(x)
  }
  if(class(x) != "SummarizedExperiment" & class(x) != "phyloseq") {
    stop("Only enter phyloseq or SummarizedExperiment objects")
  }
  # get tables of items
  body <- table(factor(samp$sample_body_site,
                       levels = c("buccal mucosa", 'cervix of uterus', 'feces',
                                  'rectum', 'unknown', 'vagina', 'blood cell',
                                  'nasal cavity')))
  body <- rbind(body, body / nrow(samp))
  gender <- table(factor(samp$subject_gender,
                         levels = c('male', 'female', 'unknown')))
  gender <- rbind(gender, gender / nrow(samp))
  race <- table(factor(samp$subject_race,
                levels = c('african_american', 'asian',
                           'caucasian', 'ethnic_other',
                           'hispanic_or_latino',
                           'american_indian_or_alaska_native',
                           'unknown')))
  race <- rbind(race, race / nrow(samp))
  tables <- list(body, gender, race)
  tables <- lapply(tables, function(x) {
    x <- t(x)
    colnames(x) <- c('N', '%')
    return(x)
  })
  return(tables)
}
