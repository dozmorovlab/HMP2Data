# HMP2Data

*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* is a Bioconductor
ExperimentData package of the Human Microbiome Project (iHMP) 16S rRNA sequencing
data. Raw data files are provided in the package as downloaded from the
[iHMP Data Analysis and Coordination Center](https://hmpdacc.org/ihmp/).
See the [package vignette](vignettes/hmp2data.Rmd) for usage details. 
Please, review the [publication moratorium](https://hmpdacc.org/ihmp/overview/datapolicy.php) when using this data.

*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* can be installed
using *[BiocManager](https://cran.r-project.org/package=BiocManager)* as
follows.

```r
BiocManager::install("HMP2Data")
```

The vignettes can be browsed using `browseVignettes("HMP2Data")`.

The development version can be installed from this repository (https://github.com/jstansfield0/HMP2Data) using `r BiocStyle::CRANpkg("devtools")`. First, generate a Personal Access Token [as described](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/), granting it full control over a repository (example what will be created: "e1ef7c328f2c14b2627ad113093b65726f9e24d3"). Second, install the package as `devtools::install_github("jstansfield0/HMP2Data", auth_token = "whatever_token_you_generated")`.

```r
library(HMP2Data)
MOMSPI16s <- momspi16S()
```
