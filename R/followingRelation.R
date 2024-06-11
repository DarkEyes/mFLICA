#' @title  followingRelation
#'
#' @description
#' 03/24/2021: Chai's code rewritten by Namrata to replicate Matlab version
#' The changes are in the DTW function, which is implemented here as DTW2 instead of the one in
#' the R package DTW
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
#' # Load example data ???
#'
#' leader<- mFLICA::TS[1,1:200,]
#' follower<- mFLICA::TS[2,1:200,]
#'
#' # Run the function
#'
#' out<-followingRelation(Y=follower,X=leader)
#'
#'@importFrom stats dist
#'
#'@export
#'
followingRelation<-function(Y,X,timeLagWindow,lagWindow=0.1)
{
  T<-dim(X)[1]
  follVal<-0

  Y<-TSNANNearestNeighborPropagation(Y) # filling NA
  X<-TSNANNearestNeighborPropagation(X) # filling NA

  if(missing(timeLagWindow))
  {
    timeLagWindow<-ceiling(lagWindow*T )
  }
  #print("in Following Relation")
  # print(X)
  # print("******************************")
  # print(Y)
  #Inferring an optimal warping path between Y (follower) and X (leader)
  #alignment<-dtw(x=Y,y=X,keep.internals=TRUE,window.type = "sakoechiba" ,window.size=timeLagWindow)
  alignment<-DTW2(X, Y)
  #dtwIndexVec<-alignment$index1[1:T]-alignment$index2[1:T] # Compute different of time lags between time series
  warp <- alignment$warp
  warp<-warp[!is.nan(warp)]
  follVal<-mean(sign(warp)) # Compute degree of following relation
  # if follVal is positive then:  Y (follower) and X (leader), otherwise,  X (follower) and Y (leader)
  # if abs(follVal) is around zero, then it implies weak or no following relation

  return(list(follVal=follVal,dtwIndexVec=warp))

}

pwiseDistance<-function(m, n)
{
  #print("in pwise")

  m <- as.matrix(m)
  #print(nrow(m))
  n <- as.matrix(n)
  #print(nrow(n))

  # Compute pairwise distances between rows of the matrices
  dist_matrix <- matrix(NA, nrow = nrow(m), ncol = nrow(n))
  for (i in 1:nrow(m)) {
    for (j in 1:nrow(n)) {
      dist_matrix[i, j] <- sqrt(sum((m[i,] - n[j,])^2))
    }
  }

  # Print the resulting matrix
  return(dist_matrix)
}

DTW2 <- function(d1, d2, band_h = 0.1, band_v = 0.1)
{
  # Default band values
  if (missing(band_h) || is.null(band_h)) {
    band_h <- 0.1
  }
  if (missing(band_v) || is.null(band_v)) {
    band_v <- 0.1
  }

  # Size of matrix
  d1 = t(d1)
  d2 = t(d2)
  s <- ncol(d1)
  m <- nrow(d1)
  #print(ncol(d2))
  #print(s)
 #print(nrow(d2))
  #print(m)
  # Check d2 sizes
  if (s != ncol(d2) || m != nrow(d2) || any(is.na(d1)) || any(is.na(d2))) {
    dist <- NaN
    warp <- NULL
    return(list(dist = dist, warp = warp))
  } else if (m < s) {
    d1 <- t(d1)
    d2 <- t(d2)
    m <- ncol(d1)
    s <- nrow(d1)
  }
  #print("In DTW")
  #print(s)
  # Preallocate
  D <- matrix(Inf, nrow = s, ncol = s) # DP matrix
  warp_path <- matrix(NA, nrow = s, ncol = s) # DP matrix for warping directionality

  # Band calculations and initial row column
  band_horizontal <- band_h
  if (band_horizontal <= 1) {
    band_horizontal <- ceiling(band_h * s)
  }
  band_vertical <- band_v
  if (band_vertical <= 1) {
    band_vertical <- ceiling(band_v * s)
  }
  band_lim_horizontal <- min(1 + band_horizontal, s)
  # print(as.matrix(d1[1,]))
  # print(as.matrix(d2[1:band_lim_horizontal,]))

  d_temp <- pwiseDistance(as.matrix(array(d1[1,], dim = c(1, 2))), as.matrix(array(d2[1:band_lim_horizontal,], dim = c(band_lim_horizontal, 2))))
  #print(d_temp)
  D[1, 1:band_lim_horizontal] <- cumsum(d_temp)
  band_lim_vertical <- min(1 + band_vertical, s)
  d_temp <- pwiseDistance(as.matrix(array(d2[1,], dim = c(1, 2))), as.matrix(array(d1[1:band_lim_vertical,], dim = c(band_lim_vertical, 2))))
  #print(d_temp)
  D[1:band_lim_vertical, 1] <- cumsum(d_temp)

  # Main DP fill
  for (i in 2:s) {
    st <- max(2, i - band_vertical)
    en <- min(s, i + band_horizontal)
    for (j in st:en) {
      cmin <- min(D[i-1, j-1], D[i-1, j], D[i, j-1])
      D[i, j] <- cmin
      warp_path[i, j] <- which.min(c(D[i-1, j-1], D[i-1, j], D[i, j-1]))

      D[i, j] <- min(c(D[i - 1, j - 1], D[i - 1, j], D[i, j - 1])) + norm(d1[i, ] - d2[j, ], type = "2")
    }
  }

  # Warping path reconstruction
  dist <- D[s, s]
  i <- s
  j <- s
  k <- s * 2
  warp <- array(NaN, dim = 2 * s)
  while (i != 1 && j != 1) {

    if (!is.na(warp_path[i, j]) && warp_path[i, j] == 1) {
      i <- i - 1
      j <- j - 1
    } else if (!is.na(warp_path[i, j]) && warp_path[i, j] == 2) {
      i <- i - 1
    } else if (!is.na(warp_path[i, j]) && warp_path[i, j] == 3) {
      j <- j - 1
    }
    warp[k] <- j - i
    k <- k - 1
  }
  return(list(dist = dist, warp = warp))
}

TSNANNearestNeighborPropagation<-function(X)
{
  if(sum(is.na(X) ) == 0)
    return(X)
  lengthL<-length(X)
  t<-1
  if(is.na(X[1]) )
  {
    for(k in seq(2,lengthL))
    {
      if(!is.na(X[k]))
      {
        X[1:(k-1)]<-X[k]
        t<-k
        break;
      }
    }
  }
  for(k in seq(t+1,lengthL))
  {
    if(is.na(X[k]) )
    {
      X[k]<-X[k-1]
    }
  }
  Xout<-X
  return(Xout)

}


