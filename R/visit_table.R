#' Make table of visits
#'
#' This function allows you to produce a summary table for
#' the HMP2Data visits.
#'
#' @param x A named list of phyloseq or SummarizedExperiment
#'     objects.
#' @return A knitr::kable table.
#' @export
#' @importFrom knitr kable
#' @importFrom kableExtra add_header_above
#' @examples
#' visit_table(list(momspi16S = momspi16S(),
#'   momspiCytokines = momspiCytokines(),
#'   IBD16S = IBD16S(), T2D16S = T2D16S()))

visit_table <- function(x) {
  visits <- lapply(x, extract_info2)
  # bin periods
  visits <- lapply(visits, function(y) {
    idx <- 1:length(y)
    first <- sum(y[1:round(quantile(idx, 0.33))])
    second <-sum(y[(round(quantile(idx, 0.33)) + 1) : round(quantile(idx, 0.66))])
    third <- sum(y[(round(quantile(idx, 0.66)) + 1) : length(y)])
    percent <- (c(first, second, third) / sum(y)) * 100
    percent <- round(percent,digits = 2)
    table <- data.frame(N = c(first, second, third),
              percent = percent)
  })
  # cbind tables
  if (length(visits) > 1) {
    visits <- do.call(cbind, visits)
    visits <- cbind("Visit Quantile" = c('First quantile', 'Second quantile', 'Third quantile'), visits)
  } else {
    visits <- visits[[1]]
    visits <- cbind("Visit Quantile" = c('First quantile', 'Second quantile', 'Third quantile'), visits)
  }
  # set up extra column headers
  column_names <-
    c("N", "%") %>%
    rep(length(x)) %>%
    c("", .)
  colnames(visits) <- column_names
  header_names <-
    names(x) %>%
    c(" ", .)
  header_vector <-
    length(names(x)) %>%
    rep(2, .) %>%
    c(1, .) %>%
    as.character() %>%
    magrittr::set_names(header_names)
  final <- knitr::kable(visits) %>% kableExtra::kable_styling(bootstrap_options = "condensed", full_width = TRUE) %>%
    kableExtra::add_header_above(header = header_vector)
  return(final)
}



extract_info2 <- function(x) {
  # check if summarizedExperiment or phyloseq object
  if(is(x, "SummarizedExperiment")) {
    samp <- colData(x)
  }
  if(is(x, "phyloseq")) {
    samp <- sample_data(x)
  }
  if(!is(x, "SummarizedExperiment") & !is(x, "phyloseq")) {
    stop("Only enter phyloseq or SummarizedExperiment objects")
  }
  # get visit tables
  tables <- table(samp$visit_number)
  return(tables)
}
