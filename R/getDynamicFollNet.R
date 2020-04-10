#' getDynamicFollNet function
#'
#' getDynamicFollNet is a support function for calculating a dynamic following network of a set of time series
#'
#' @param TS is a set of time series where \code{TS[i,t,d]} is a numeric value of \code{i}th time series at time \code{t} and dimension \code{d}.
#' @param timeWindow is a time window parameter that limits a length of each sliding window. The default is 10 percent of time series length.
#' @param timeShift is a number of time steps a sliding window shifts from a previous window to the next one. The default is 10 percent of \code{timeWindow}.
#' @param lagWindow is a maximum possible time delay in the term of percentage of time length of \code{timeWindow} supplying to the followingNetwork function.
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
getDynamicFollNet<-function(TS,timeWindow,timeShift,sigma=0.50,lagWindow=0.1,silentFlag=FALSE)
{

  if(length(dim(TS)) ==2) # fix one-dimensional problem
  {
    B<-array(0,c(dim(TS),2))
    B[,,1]<-TS
    TS<-B
  }
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
    # if the length of remainding interval is shorter than time window
    if(t+timeWindow >= Tlength)
    {
      # Fill everything by the previous interval values
      dyNetBinMat[,,t:Tlength] <-follOut$adjBinMat
      dyNetWeightedMat[,,t:Tlength] <-follOut$adjWeightedMat
      dyNetBinDensityVec[t:Tlength]<-dval1
      dyNetWeightedDensityVec[t:Tlength]<-dval2
      break;
    }else
    {
      currTWInterval<-t:(t+timeWindow-1) # set current interval
      currTS<-TS[,currTWInterval,] # subset time series by focusing on only currTWInterval interval
      follOut<-followingNetwork(TS=currTS,sigma=sigma,lagWindow=lagWindow) # infer a following network
      dyNetBinMat[,,currTWInterval] <-follOut$adjBinMat  # save a binary adjacency matrix
      dyNetWeightedMat[,,currTWInterval] <-follOut$adjWeightedMat # save a weighted adjacency matrix
      dval1<-getADJNetDen(follOut$adjBinMat) # Compute a network density of binary adjacency matrix
      dval2<-getADJNetDen(follOut$adjWeightedMat) # Compute a network density of weighted adjacency matrix
      dyNetBinDensityVec[currTWInterval]<-dval1 # save a network density value
      dyNetWeightedDensityVec[currTWInterval]<-dval2  # save a network density value

      if(silentFlag == FALSE)
        print(sprintf("TW%d shift-%d - t%d",timeWindow,timeShift,t) )
    }
  }
  return(list(dyNetBinMat=dyNetBinMat,dyNetWeightedMat=dyNetWeightedMat,dyNetBinDensityVec=dyNetBinDensityVec,dyNetWeightedDensityVec=dyNetWeightedDensityVec))
}
