# HMP2Data

## Package description

*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* is a Bioconductor
ExperimentData package of the Human Microbiome Project (iHMP) 16S rRNA sequencing
data. Raw data files are provided in the package as downloaded from the
[iHMP Data Analysis and Coordination Center](https://hmpdacc.org/ihmp/).
See the [package vignette](vignettes/hmp2data.Rmd) for usage details. 
Please, review the [publication moratorium](https://hmpdacc.org/ihmp/overview/datapolicy.php) when using this data.

## Installation

*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* can be installed
using *[BiocManager](https://cran.r-project.org/package=BiocManager)* as
follows.

```r
BiocManager::install("HMP2Data")
```

The vignettes can be browsed using `browseVignettes("HMP2Data")`.

The development version can be installed from this repository [https://github.com/jstansfield0/HMP2Data](https://github.com/jstansfield0/HMP2Data) using `r BiocStyle::CRANpkg("devtools")`. Install the package using the command `devtools::install_github("jstansfield0/HMP2Data")`.

The stable version is available at the dozmorovlab GitHub repository [https://github.com/dozmorovlab/HMP2Data](https://github.com/dozmorovlab/HMP2Data) and can be installed using the command `devtools::install_github("dozmorovlab/HMP2Data")`.


## Usage example

To load the MOMSPI16S data run the following commands. This will generate a phyloseq object with the 16S rRNA data.

```r
library(HMP2Data)
MOMSPI16s <- momspi16S()
```

The MOMSPI cytokines data can be accessed with this command.

```r
cyto <- momspiCytokines()
```

You may also load the Type 2 diabetes data and the Inflammatory bowel disease data as follows.

```r
T2D <- T2D16S()
IBD <- IBD16S()
```

Please see the vignette for more information about the usage of the package.

## Contact information

If you have questions, comments, or suggestions you feel free to contact John Stansfield (stansfieldjc[at]vcu[dot]edu) or Mikhail Dozmorov (mikhail.dozmorov[at]vcuhealth[dot]org).
