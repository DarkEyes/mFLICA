#' getDynamicFollNet function
#'
#' getDynamicFollNet is a support function for calculating a dynamic following network of a set of time series
#'
#' @param TS is a set of time series where \code{TS[i,t,d]} is a numeric value of \code{i}th time series at time \code{t} and dimension \code{d}.
#' @param timeWindow is a time window parameter that limits a length of each sliding window. The default is 10 percent of time series length.
#' @param timeShift is a number of time steps a sliding window shifts from a previous window to the next one. The default is 10 percent of \code{timeWindow}.
#' @param sigma is a threshold of following relation. The default is 0.5.
#' @param silentFlag is a flag that prohibit the function to print the current status of process.
#'
#' @return This function returns adjacency matrices of a dynamic following network of \code{TS} as well as the corresponding time series of network densities.
#'
#' \item{dyNetWeightedMat}{ An adjacency matrix of a dynamic following network
#' s.t. if \code{dyNetWeightedMat[i,j,t]>0}, then \code{TS[i,,]} follows  \code{TS[j,,]} at time \code{t} with a degree \code{dyNetWeightedMat[i,j,t]}. }
#' \item{dyNetBinMat}{ A binary version of \code{dyNetWeightedMat} s.t. \code{dyNetWeightedMat[i,j,t] <- (dyNetWeightedMat[i,j,t] >=sigma)} for any \code{i,j,t}.  }
#' \item{dyNetWeightedDensityVec}{A time series of dynamic network densities of \code{dyNetWeightedMat}}
#' \item{dyNetBinDensityVec}{A time series of dynamic network densities of \code{dyNetBinDensityVec}}
#'
#' @examples
#'
#' # Run the function
#' out<-getDynamicFollNet(TS=mFLICA::TS[,1:10,],timeWindow=5,timeShift = 5,sigma=0.5)
#'
#'@export
#'
getDynamicFollNet<-function(TS,timeWindow,timeShift,sigma=0.50,silentFlag=FALSE)
{
  invN<-dim(TS)[1]
  Tlength<-dim(TS)[2]
  dimensionsN<-dim(TS)[3]
  dyNetBinMat<- array(0,dim=c(invN,invN,Tlength))
  dyNetWeightedMat <- array(0,dim=c(invN,invN,Tlength))
  dyNetBinDensityVec<- array(0,dim=c(1,Tlength))
  dyNetWeightedDensityVec<- array(0,dim=c(1,Tlength))
  if(missing(timeWindow))
  {
    timeWindow<-ceiling(0.1*Tlength)
  }
  if(missing(timeShift))
  {
    timeShift<-max(1,ceiling(0.1*timeWindow))
  }
  #======== sliding window
  for( t in seq(1, Tlength, by = timeShift) )
  {
    if(t+timeWindow >= Tlength)
    {
      dyNetBinMat[,,t:Tlength] <-follOut$adjBinMat
      dyNetWeightedMat[,,t:Tlength] <-follOut$adjWeightedMat
      dyNetBinDensityVec[t:Tlength]<-dval1
      dyNetWeightedDensityVec[t:Tlength]<-dval2
      break;
    }else
    {
      currTWInterval<-t:(t+timeWindow-1)
      currTS<-TS[,currTWInterval,]
      follOut<-followingNetwork(TS=currTS,sigma=sigma)
      dyNetBinMat[,,currTWInterval] <-follOut$adjBinMat
      dyNetWeightedMat[,,currTWInterval] <-follOut$adjWeightedMat
      dval1<-getADJNetDen(follOut$adjBinMat)
      dval2<-getADJNetDen(follOut$adjWeightedMat)
      dyNetBinDensityVec[currTWInterval]<-dval1
      dyNetWeightedDensityVec[currTWInterval]<-dval2

      if(silentFlag == FALSE)
        print(sprintf("TW%d shift-%d - t%d",timeWindow,timeShift,t) )
    }
  }
  return(list(dyNetBinMat=dyNetBinMat,dyNetWeightedMat=dyNetWeightedMat,dyNetBinDensityVec=dyNetBinDensityVec,dyNetWeightedDensityVec=dyNetWeightedDensityVec))
}
