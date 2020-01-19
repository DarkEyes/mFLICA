Leadership-Inference Framework for Multivariate Time Series: mFLICA
===========================================================
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.5.0-6666ff.svg)](https://cran.r-project.org/)
[![License](https://img.shields.io/badge/License-GPL%203-orange.svg)](https://spdx.org/licenses/GPL-3.0-only.html)
[![](https://img.shields.io/badge/doi-10.1137%2F1.9781611975321.62-yellow)](https://doi.org/10.1137/1.9781611975321.62 )

The framework uses a notion of a leader as an individual who initiates collective patterns that everyone in a group follows. 

Given a set of time series of individual activities, our goal is to identify periods of coordinated activity, find factions of coordination if more than one exist, as well as identify leaders of each faction. 

For each time step, the framework infers following relations between individual time series, then identifying a leader of each faction whom many individuals follow but it follows noone. A faction is defined as a group of individuals that everyone follows the same leader.

mFLICA reports following relations, leaders of factions, and members of each faction for each time step. 

Installation
------------

For the newest version on github, please call the following command in R terminal.

``` r
remotes::install_github("DarkEyes/mFLICA")
```
This requires a user to install the "remotes" package before installing VLTimeSeriesCausality.

EXAMPLE
----------------------------------------------------------------------------------

In the first step, we have a build-in dataset of 30-individual  time series where ID1, ID2, ID3 are leaders at coordination intervals: [1,200], [201,400], and [401,600] respectively. These individuals move withine two dimentionsal space. Time series of each individual represents a sequece of coordinate (x,y) at each time step. A leader is an initiator who initiates coordinated movement that everyone in a faction follows. 

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

To make it short, we choose only the interval [1,200] that ID1 is a leader. The framework is used to analyze the data below.
```{r}
obj1<-mFLICA(TS=mFLICA::TS[,1:200,],timeWindow=60,sigma=0.5)
```
The network densities of a dynamic following network is shown below.
```{r}
 plotMultipleTimeSeries(TS=obj1$dyNetOut$dyNetBinDensityVec, strTitle="Network Dnesity")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/networkDensity.png" width="550">

We plot time series of faction size ratios of all leaders
```{r}
 plotMultipleTimeSeries(TS=obj1$factionSizeRatioTimeSeries, strTitle="Faction Size Ratios")
```
<img src="https://github.com/DarkEyes/mFLICA/blob/master/man/FIG/facSizeRatios.png" width="550">



Citation
----------------------------------------------------------------------------------
Amornbunchornvej, Chainarong, and  Tanya Y. Berger-Wolf.  "Framework for Inferring Leadership Dynamics of  Complex Movement  from Time Series." In Proceedings of the 2018 SIAM International Conference on Data Mining (SDM), pp. 549-557. Society for Industrial and Applied Mathematics, 2018. <a href="https://doi.org/10.1137/1.9781611975321.62">https://doi.org/10.1137/1.9781611975321.62</a>

Contact
----------------------------------------------------------------------------------
- Developer: C. Amornbunchornvej<div itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0003-3131-0370" href="https://orcid.org/0000-0003-3131-0370" target="orcid.widget" rel="noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">https://orcid.org/0000-0003-3131-0370</a></div>
- <a href="https://www.nectec.or.th/en/research/dsaru/dsarg-sai.html">Strategic Analytics Networks with Machine Learning and AI (SAI)</a>, <a href="https://www.nectec.or.th/en/">NECTEC</a>, Thailand
- Homepage: <a href="https://sites.google.com/view/amornbunchornvej/home">Link</a>
