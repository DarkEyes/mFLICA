#' followingNetwork function
#'
#' followingNetwork is a support function for calculating a following network of a set of time series
#'
#' @param TS is a set of time series where \code{TS[i,t,d]} is a numeric value of \code{i}th time series at time \code{t} and dimension \code{d}.
#' @param timeLagWindow is a maximum possible time delay in the term of time steps.
#' @param lagWindow is a maximum possible time delay in the term of percentage of time length of \code{TS}.
#' @param sigma is a threshold of following relation. It is used to discretize an adjacency matrix \code{adjWeightedMat} to be a binary matrix \code{adjBinMat}.
#'
#' @return This function returns adjacency matrices of a following network of \code{TS}.
#'
#' \item{adjWeightedMat}{ An adjacency matrix of a following network
#' s.t. if \code{adjWeightedMat[i,j]>0}, then \code{TS[i,,]} follows  \code{TS[j,,]} with a degree \code{adjWeightedMat[i,j]}. }
#' \item{adjBinMat}{ A binary version of \code{adjWeightedMat} s.t. \code{adjBinMat[i,j] <- (adjWeightedMat[i,j] >=sigma)} for any \code{i,j}.  }
#'
#' @examples
#'
#' # Run the function
#'
#' out<-followingNetwork(TS=mFLICA::TS[,60:90,],sigma=0.5)
#'
#'@export
#'
followingNetwork<-function(TS,timeLagWindow,lagWindow=0.1,sigma=0.1)
{
  if(missing(timeLagWindow))
  {

    timeLagWindow<-ceiling(lagWindow*dim(TS)[2] )
  }

  N<-dim(TS)[1]
  adjBinMat<-matrix(0,N,N)
  adjWeightedMat<-matrix(0,N,N)

  #For each pair of time series (i,j) - no order - (i,j) is the same as (j,i)
  for(i in seq(N-1))
    for(j in seq(i,N))
    {
      # compute following relation degree
      follVal<- followingRelation(Y=TS[i,,],X=TS[j,,],timeLagWindow)$follVal
      if(follVal>0) # i is the follower and j is a leader
      {
        adjWeightedMat[i,j]<-follVal # save the magnitude of following degree
      }else # if it is another way around
      {
        adjWeightedMat[j,i]<-abs(follVal) # the magnitude of following degree
      }
    }
  adjBinMat <- adjWeightedMat >=sigma # Check whether the magnitude of following degree > sigma

  return(list(adjBinMat=adjBinMat,adjWeightedMat=adjWeightedMat))
}

#' getADJNetDen function
#'
#' getADJNetDen is a support function for calculating a network density of a network.
#'
#' @param adjMat is an adjacency matrix of a dominant-distribution network.
#'
#' @return This function returns a value of network density of of a network for a given adjMat.
#'
#' @examples
#'
#' # Given an example of adjacency matrix
#' A<-matrix(FALSE,5,5)
#' A[2,1]<-TRUE
#' A[c(3,4),2]<-TRUE
#'
#' # Get a network density of an adjacency matrix
#'
#' getADJNetDen(adjMat=A)
#'
#'@export
#'
getADJNetDen<-function(adjMat)
{
  N<-dim(adjMat)[1]
  netDen<-sum(adjMat)/(N*(N-1)/2)
  return(netDen)
}

#' getFactionSizeRatio function
#'
#' getFactionSizeRatio is a support function for calculating a faction size ratio of a given faction.
#' A faction size ratio is a number of edges that connect between faction-member nodes divided by a number of total nodes within a following network.
#'
#' @param adjMat is an adjacency matrix of a dominant-distribution network.
#' @param members is a list of member IDs of a given faction.
#'
#' @return This function returns a faction size ratio of a given faction.
#'
#' @examples
#'
#' # Given an example of adjacency matrix
#' A<-matrix(FALSE,5,5)
#' A[2,1]<-TRUE
#' A[c(3,4),2]<-TRUE
#'
#' # Get a faction size ratio of a given faction
#'
#' getFactionSizeRatio(adjMat=A,members=c(1,2,3,4))
#'
#'@export
#'
getFactionSizeRatio<-function(adjMat,members)
{
  N<-dim(adjMat)[1]
  M<-sum(adjMat[members,members])
  factionSizeRatio<-M/(N*(N-1)/2)
  return(factionSizeRatio)
}
