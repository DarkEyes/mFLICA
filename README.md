Leadership-Inference Framework for Multivariate Time Series: mFLICA
===========================================================
[![Travis CI build status](https://app.travis-ci.com/DarkEyes/mFLICA.svg?branch=master)](https://app.travis-ci.com/github/DarkEyes/mFLICA)
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.5.0-6666ff.svg)](https://cran.r-project.org/)
[![CRAN Status Badge](https://www.r-pkg.org/badges/version-last-release/mFLICA)](https://cran.r-project.org/package=mFLICA)
[![Download](https://cranlogs.r-pkg.org/badges/grand-total/mFLICA)](https://cran.r-project.org/package=mFLICA)
[![License](https://img.shields.io/badge/License-GPL%203-orange.svg)](https://spdx.org/licenses/GPL-3.0-only.html)
[![arXiv](https://img.shields.io/badge/cs.SI-arXiv%3A2004.06092-B31B1B.svg)](https://arxiv.org/abs/2004.06092)
[![](https://img.shields.io/badge/doi-10.1016%2Fj.softx.2021.100781-yellow)](https://doi.org/10.1016/j.softx.2021.100781 )
[![Open in Code Ocean](https://codeocean.com/codeocean-assets/badge/open-in-code-ocean.svg)](https://codeocean.com/capsule/2804717/tree)


The framework uses a notion of a leader as an individual who initiates collective patterns that everyone in a group follows. 

Given a set of time series of individual activities, our goal is to identify periods of coordinated activity, find factions of coordination if more than one exist, as well as identify leaders of each faction. 

For each time step, the framework infers following relations between individual time series, then identifying a leader of each faction whom many individuals follow but it follows no one. A faction is defined as a group of individuals that everyone follows the same leader.

mFLICA reports following relations, leaders of factions, and members of each faction for each time step. 

Installation
------------
You can install our package from CRAN

```r
install.packages("mFLICA")
```

For the newest version on github, please call the following command in R terminal.

``` r
remotes::install_github("DarkEyes/mFLICA")
```
This requires a user to install the "remotes" package before installing mFLICA.

EXAMPLE
----------------------------------------------------------------------------------

In the first step, we have a build-in dataset of 30-individual  time series where ID1, ID2, and ID3 are leaders at coordination intervals: [1,200], [201,400], and [401,600] respectively. These individuals move within two-dimensional space. Time series of each individual represents a sequence of coordinate (x,y) at each time step. A leader is an initiator who initiates coordinated movement that everyone in a faction follows. 

```{r}
library(mFLICA)

# mFLICA::TS[i,t,d] is an element of ith time series at time t in the dimension d. Here, we have only two dimensions: x and y. The time series length is 800, so, t is in the range [1,800]. There are 30 individuals, so, i is in the range [1,30].
plotMultipleTimeSeries(TS=mFLICA::TS[,,1],strTitle="x axis")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/Xspace.png" width="550">

```{r}
plotMultipleTimeSeries(TS=mFLICA::TS[,,2],strTitle="y axis")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/Yspace.png" width="550">

The framework is used to analyze the data below.
```{r}
obj1<-mFLICA(TS=mFLICA::TS[,1:800,],timeWindow=60,sigma=0.5)
```
The network densities of a dynamic following network is shown below. At any time step t, a higher network density implies a higher degree of coordination; the higher number of individuals that follow the same pattern with some time delays. 
```{r}
 plotMultipleTimeSeries(TS=obj1$dyNetOut$dyNetBinDensityVec, strTitle="Network Dnesity")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/networkDensity.png" width="550">

We plot time series of faction size ratios of all leaders. A faction size ratio is just a network density calculating from only edges within a faction leading by a specific leader. If everyone follows a single leader, then a faction size ratio is the same as the network density, which has the value at one.
```{r}
 plotMultipleTimeSeries(TS=obj1$factionSizeRatioTimeSeries, strTitle="Faction Size Ratios")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/facSizeRatios.png" width="550">

Here, we know that ID1, ID2, and ID3 are leaders at coordination intervals: [1,200], [201,400], and [401,600] respectively. Hence, ID1, ID2 and ID3 have their faction size ratios being high during the intervals that they lead the group.

Citation
----------------------------------------------------------------------------------
-Methodology
Amornbunchornvej, Chainarong, and  Tanya Y. Berger-Wolf.  "Framework for Inferring Leadership Dynamics of  Complex Movement  from Time Series." In Proceedings of the 2018 SIAM International Conference on Data Mining (SDM), pp. 549-557. Society for Industrial and Applied Mathematics, 2018. <a href="https://doi.org/10.1137/1.9781611975321.62">https://doi.org/10.1137/1.9781611975321.62</a>

-Software
Amornbunchornvej, Chainarong . "mFLICA: an R package for inferring leadership of coordination from time series." SoftwareX 15 (2021) 100781, <a href="https://doi.org/10.1016/j.softx.2021.100781">https://doi.org/10.1016/j.softx.2021.100781</a>

Contact
----------------------------------------------------------------------------------
- Developer: Chainarong Amornbunchornvej<div itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0003-3131-0370" href="https://orcid.org/0000-0003-3131-0370" target="orcid.widget" rel="noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">https://orcid.org/0000-0003-3131-0370</a></div>
- <a href="https://www.nectec.or.th">Strategic Analytics Networks with Machine Learning and AI (SAI)</a>, <a href="https://www.nectec.or.th">NECTEC</a>, Thailand
- Homepage: <a href="https://sites.google.com/view/amornbunchornvej/home">Link</a>
