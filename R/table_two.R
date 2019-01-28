#' Generate demographic summary table for HMP2 sample data
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
#' table_two(list(momspi16S = momspi16S(), momspiCytokines = momspiCytokines(), IBD16S = IBD16S(), T2D16S = T2D16S()))
table_two <- function(x) {
  # check that x is a named list
  if (class(x) != "list") {
    stop("You must enter a named list")
  }
  if (is.null(names(x))) {
    stop("You must enter a named list")
  }
  # extract table info
  tables <- lapply(x, extract_info)
  # merge tables into final table
  tables <- lapply(tables, function(y) {
    y <- lapply(y, function(z) {
      vars <- rownames(z)
      z <- as.data.frame(z)
      z$variable <- vars
      return(z)
    })
    y <- data.table::rbindlist(y)
    return(y)
  })
  # merge columns
  if (length(tables) > 1) {
    vars <- tables[[1]]$variable
    tables <- lapply(tables, function(z) z[, -c("variable")])
    tables <- do.call(cbind, tables) %>% as.data.frame()
    tables <- cbind(vars, tables)
  } else {
    tables <- tables[[1]]
    tables <- tables[, c('variable', 'N', '%')]
    colnames(tables)[1] <- 'vars'
  }
  # round numbers
  nums <- tables[,-1] %>% data.matrix() %>% round(digits = 2) %>% as.data.frame()
  tables <- data.frame(vars = tables$vars, nums)
  # add in headers for sections
  tables$vars <- as.character(tables$vars)
  tables <- rbind(c("**Body Site**", rep("", ncol(tables) - 1)), tables)
  tables <- rbind(tables[1:9,], c("**Sex**", rep("", ncol(tables) - 1)), tables[10:20, ])
  tables <- rbind(tables[1:13,], c("**Race**", rep("", ncol(tables) - 1)), tables[14:21, ])
  # replace underscores with spaces
  tables$vars <- gsub("_", " ", tables$vars)
  # total row
  # totals <- c("total", sum(tables[,2]), "100", sum(tables[,4]), "100", sum(tables[,6]))

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
  # header_vector <- c(2, 2, 2, 2, 2)
  # names(header_vector) <- c(" ", names(x))
  rownames(tables) <- NULL
  final <- knitr::kable(tables) %>% kableExtra::kable_styling(bootstrap_options = "condensed", full_width = TRUE) %>%
    kableExtra::add_header_above(header = header_vector)
  return(final)
}


# function to extract info from the tables
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
  body <- rbind(body, body / nrow(samp) * 100)
  gender <- table(factor(samp$subject_gender,
                         levels = c('male', 'female', 'unknown')))
  gender <- rbind(gender, gender / nrow(samp) * 100)
  race <- table(factor(samp$subject_race,
                       levels = c('african_american', 'asian',
                                  'caucasian', 'ethnic_other',
                                  'hispanic_or_latino',
                                  'american_indian_or_alaska_native',
                                  'unknown')))
  race <- rbind(race, race / nrow(samp) * 100)
  tables <- list(body, gender, race)
  tables <- lapply(tables, function(x) {
    x <- t(x)
    colnames(x) <- c('N', '%')
    return(x)
  })
  # add totals
  tables[[4]] <- matrix(data = c(length(unique(samp$subject_id)), 100), nrow = 1, ncol = 2)
  rownames(tables[[4]]) <- "**total subjects**"
  colnames(tables[[4]]) <- c("N", "%")
  return(tables)
}
