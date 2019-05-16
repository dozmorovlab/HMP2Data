context("data")

test_that("data are correct objects", {
  momspi16S() %>%
    expect_s4_class("phyloseq")

  momspiCytokines() %>%
    expect_s4_class("SummarizedExperiment")

  IBD16S() %>%
    expect_s4_class("phyloseq")

  T2D16S() %>%
    expect_s4_class("phyloseq")

  momspiMultiAssay() %>%
    expect_s4_class("MultiAssayExperiment")
})
