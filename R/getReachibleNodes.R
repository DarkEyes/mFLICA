#' getReachibleNodes function
#'
#' getReachibleNodes is a support function for inferring reachable nodes that have some directed path to a node \code{targetNode}.
#'
#' @param adjMat is an adjacency matrix of a following network of which its elements are binary: zero for no edge, and one for having an edge.
#'
#' @return This function returns a set of node IDs \code{followers} that have some directed path to a node \code{targetNode}.
#'
#' @examples
#' # Given an example of adjacency matrix
#' A<-matrix(FALSE,5,5)
#' A[2,1]<-TRUE
#' A[c(3,4),2]<-TRUE
#' A[5,3]<-TRUE
#' # Get a set of reachable nodes of targetNode.
#'
#' followers<-getReachibleNodes(adjMat=A,targetNode=1)$followers
#'
#'@export
#'
getReachibleNodes<-function(adjMat,targetNode)
{
  adjMat
  N<-dim(adjMat)[1]
  IDs<-1:N

  Qmembers<-IDs[as.logical(adjMat[,targetNode])]
  flag<-logical(N)
  flag[Qmembers]<-TRUE
  while(length(Qmembers)>0)
  {
    ID<-Qmembers[1]
    Qmembers<-Qmembers[-1]
    currNewMembers<-IDs[as.logical(adjMat[,ID])]
    if(length(currNewMembers) <1)
      next
    for(i in currNewMembers)
    {
      if(!flag[i])
      {
        flag[i]<-TRUE
        Qmembers<-c(Qmembers,i)
      }
    }

  }
  members<-IDs[flag]
  return(list(followers=members))
}
