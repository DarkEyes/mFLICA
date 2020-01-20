#' @title  mFLICA: leadership-inference framework for multivariate time series
#' @author Chainarong Amornbunchornvej, \email{chai@@ieee.org}
#'
#' @description
#' A leadership-inference framework for multivariate time series. The framework uses a notion of a leader as an individual who initiates collective patterns that everyone in a group follows. Given a set of time series of individual activities, our goal is to identify periods of coordinated activity, find factions of coordination if more than one exist, as well as identify leaders of each faction. For each time step, the framework infers following relations between individual time series, then identifying a leader of each faction whom many individuals follow but it follows no one. A faction is defined as a group of individuals that everyone follows the same leader. mFLICA reports following relations, leaders of factions, and members of each faction for each time step. Please see Chainarong Amornbunchornvej and Tanya Berger-Wolf (2018) <doi:10.1137/1.9781611975321.62> when referring to this package in publications.
#'
#'
#' @param TS is a set of time series where \code{TS[i,t,d]} is a numeric value of \code{i}th time series at time \code{t} and dimension \code{d}.
#' @param timeWindow is a time window parameter that limits a length of each sliding window. The default is 10 percent of time series length.
#' @param timeShift is a number of time steps a sliding window shifts from a previous window to the next one. The default is 10 percent of \code{timeWindow}.
#' @param sigma is a threshold of following relation. The default is 0.5. Note that if \code{sigma} is not one, an individual might be a member of multiple factions.
#' @param silentFlag is a flag that prohibit the function to print the current status of process.
#'
#' @return This function returns dynamic following networks, as well as leaders of factions, and members of each faction for each time step.
#'
#' \item{dyNetOut$dyNetWeightedMat}{ An adjacency matrix of a dynamic following network
#' s.t. if \code{dyNetWeightedMat[i,j,t]>0}, then \code{TS[i,,]} follows  \code{TS[j,,]} at time \code{t} with a degree \code{dyNetWeightedMat[i,j,t]}. }
#' \item{dyNetOut$dyNetBinMat}{ A binary version of \code{dyNetWeightedMat} s.t. \code{dyNetWeightedMat[i,j,t] <- (dyNetWeightedMat[i,j,t] >=sigma)} for any \code{i,j,t}.  }
#' \item{dyNetOut$dyNetWeightedDensityVec}{A time series of dynamic network densities of \code{dyNetWeightedMat}}
#' \item{dyNetOut$dyNetBinDensityVec}{A time series of dynamic network densities of \code{dyNetBinDensityVec}}
#' \item{leadersTimeSeries}{A time series of leaders of each faction where \code{leadersTimeSeries[[t]]} is a set of leaders at time \code{t}. A number of factions is the same as a number of leaders.}
#' \item{factionMembersTimeSeries}{A time series of sets of faction members where \code{factionMembersTimeSeries[[t]][[k]]} is a set of faction-members at time \code{t} leading by a leader \code{leadersTimeSeries[[t]][k]}. }
#' \item{factionSizeRatioTimeSeries}{A time series of faction-size ratios of all individuals. A faction size ratio is a number of edges that connect between faction-member nodes divided by a number of total nodes within a following network. If a leader has a higher faction-size ratio, then it has more followers than a leader with a lower faction-size ratio. A faction-size ratio has a value between 0 and 1.}
#'
#' @examples
#'
#' # Run the function
#'
#' obj1<-mFLICA(TS=mFLICA::TS[,60:90,],timeWindow=10,timeShift=10,sigma=0.5)
#'
#' # Plot time series of faction size ratios of all leaders
#'
#' plotMultipleTimeSeries(TS=obj1$factionSizeRatioTimeSeries, strTitle="Faction Size Ratios")
#'
#'@export
#'
mFLICA <- function(TS,timeWindow,timeShift,sigma=0.50,silentFlag=FALSE) {

  invN<-dim(TS)[1]
  Tlength<-dim(TS)[2]
  dimensionsN<-dim(TS)[3]

  leadersTimeSeries<-list()
  factionMembersTimeSeries<-list()
  factionSizeRatioTimeSeries<- array(0,dim=c(invN,Tlength))

  if(missing(timeWindow))
  {
    timeWindow<-ceiling(0.1*Tlength)
  }

  if(missing(timeShift))
  {
    timeShift<-max(1,ceiling(0.1*timeWindow))
  }

  dyNetOut<-getDynamicFollNet(TS=TS,timeWindow=timeWindow,timeShift=timeShift,sigma=sigma,silentFlag=silentFlag)

  for(t in seq(1,Tlength))
  {
    currMat<-dyNetOut$dyNetBinMat[,,t]
    dyFactionout<-getFactions(currMat)
    leadersTimeSeries[[t]]<-dyFactionout$leaders
    factionMembersTimeSeries[[t]]<-dyFactionout$factionMembers
    factionSizeRatioTimeSeries[,t]<-dyFactionout$factionSizeRatio
    if(silentFlag == FALSE)
      if(t%%timeWindow==1)
        print(sprintf("Finding factions:t%d",t) )
  }

  value <- list(dyNetOut=dyNetOut,leadersTimeSeries=leadersTimeSeries,factionMembersTimeSeries=factionMembersTimeSeries,factionSizeRatioTimeSeries=factionSizeRatioTimeSeries) # outputs
  attr(value, 'class') <- 'mFLICA'
  value
}
