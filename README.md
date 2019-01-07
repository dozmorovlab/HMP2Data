# HMP2Data

*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* is a Bioconductor
ExperimentData package of the Human Microbiome Project (HMP) 16S rRNA sequencing
data for variable regions 1вЂ“3 and 3вЂ“5. Raw data files are provided in the
package as downloaded from the
[HMP Data Analysis and Coordination Center](https://tinyurl.com/y7ev836z).


*[HMP2Data](http://bioconductor.org/packages/HMP2Data)* can be installed
using *[BiocManager](https://cran.r-project.org/package=BiocManager)* as
follows.

```r
BiocManager::install("HMP2Data")
```

Once installed, *[HMP2Data](http://bioconductor.org/packages/HMP2Data)*
provides two functions to access data вЂ“ one for variable region 1вЂ“3 and another
for variable region 3вЂ“5. When called, as follows, the functions will download
data from an *[ExperimentHub](http://bioconductor.org/packages/ExperimentHub)*
Amazon S3 (Simple Storage Service) bucket over `https` or load data from a local
cache.
