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
#'
#'\item{follVal}{ is a following-relation value s.t. if \code{follVal} is positive, then \code{Y} follows \code{X}. If  \code{follVal} is negative, then \code{X} follows \code{Y}.
#' Otherwise, if \code{follVal} is zero, there is no following relation between \code{X,Y}.  }
#'\item{nX}{ is a time series that is rearranged from \code{X} by applying the lags \code{optIndexVec} in order to imitate \code{Y}. }
#'\item{optDelay}{ is the optimal time delay inferred by cross-correlation of \code{X,Y}. It is positive if \code{Y} is simply just a time-shift of \code{X} (e.g. \code{Y[t]=X[t-optDelay]}). }
#'\item{optCor}{ is the optimal correlation of \code{Y[t]=X[t-optDelay]} for all \code{t}.  }
#'\item{optIndexVec}{ is a time series of optimal warping-path from DTW that is corrected by cross correlation.
#' It is approximately that \code{Y[t]=X[t-optIndexVec[t]]}).  }
#'\item{VLval}{ is a percentage of elements in \code{optIndexVec} that is not equal to \code{optDelay}. }
#'\item{ccfout}{ is an output object of \code{ccf} function. }
#'
#'
#'@examples
#' # Generate simulation data
#' TS <- SimpleSimulationVLtimeseries()
#' # Run the function
#' out<-followingRelation(Y=TS$Y,X=TS$X)
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
