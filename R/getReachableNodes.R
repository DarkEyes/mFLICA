#' getReachableNodes function
#'
#' getReachableNodes is a support function for inferring reachable nodes that have some directed path to a node \code{targetNode}.
#' This function uses Breadth-first search (BFS) algorithm.
#'
#' @param adjMat is an adjacency matrix of a following network of which its elements are binary: zero for no edge, and one for having an edge.
#' @param targetNode is a node in a graph that we want to find a set of nodes that can reach this target node via some paths.
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
#' followers<-getReachableNodes(adjMat=A,targetNode=1)$followers
#'
#'@export
#'
getReachableNodes<-function(adjMat,targetNode)
{
  adjMat
  N<-dim(adjMat)[1]
  IDs<-1:N

  Qmembers<-IDs[as.logical(adjMat[,targetNode])] # finding directed followers of targetNode
  flag<-logical(N)
  flag[Qmembers]<-TRUE
  while(length(Qmembers)>0) # loop until no members within the queue Qmembers (BFS)
  {
    ID<-Qmembers[1] # read head of the queue
    Qmembers<-Qmembers[-1] # dequeue
    currNewMembers<-IDs[as.logical(adjMat[,ID])] #list all followers of ID
    if(length(currNewMembers) <1) # if no follower, then just skip this iteration
      next
    for(i in currNewMembers) # for each follwer in currNewMembers
    {
      if(!flag[i]) # if i is the new follower never detected, then add i to the queue
      {
        flag[i]<-TRUE
        Qmembers<-c(Qmembers,i)
      }
    }

  }
  members<-IDs[flag] # return all reachable nodes that have the end of paths to targetNode
  return(list(followers=members))
}
