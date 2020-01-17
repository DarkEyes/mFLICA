#' @title  followingRelation
#'
#' @description
#'
#' followingRelation is a function that infers whether \code{Y} follows \code{X}.
#'
#'
#'@param Y is a T-by-D matrix of numerical time series of a follower
#'@param X is a T-by-D matrix numerical time series of a leader
#'@param timeLagWindow is a maximum possible time delay in the term of time steps.
#'@param lagWindow is a maximum possible time delay in the term of percentage of length(X).
#'If \code{timeLagWindow} is missing, then \code{timeLagWindow=ceiling(lagWindow*length(X))}. The default is 0.2.
#'
#'@return This function returns a list of following relation variables below.
#'
#'\item{follVal}{ is a following-relation value s.t. if \code{follVal} is positive, then \code{Y} follows \code{X}. If  \code{follVal} is negative, then \code{X} follows \code{Y}.
#' Otherwise, if \code{follVal} is zero, there is no following relation between \code{X,Y}. }
#'\item{dtwIndexVec}{ is a numeric vector of index-warping difference: dtwIndexVec[k] = dtwOut$index1[k] - dtwOut$index2[k] where dtwOut is the output from dtw::dtw(x=Y,y=X) function.}
#'
#'@examples
#' # Load example data
#'
#' leader<- mFLICA::TS[1,1:200,]
#' follower<- mFLICA::TS[2,1:200,]
#'
#' # Run the function
#'
#' out<-followingRelation(Y=follower,X=leader)
#'
#'@importFrom stats dist
#'@import dtw
#'@export
#'
followingRelation<-function(Y,X,timeLagWindow,lagWindow=0.1)
{
  T<-dim(X)[1]
  follVal<-0

  if(missing(timeLagWindow))
  {
    timeLagWindow<-ceiling(lagWindow*T )
  }

    alignment<-dtw(x=Y,y=X,keep.internals=TRUE,window.type = "sakoechiba" ,window.size=timeLagWindow)
    dtwIndexVec<-alignment$index1[1:T]-alignment$index2[1:T]

    follVal<-mean(sign(dtwIndexVec))

  return(list(follVal=follVal,dtwIndexVec=dtwIndexVec))

}
