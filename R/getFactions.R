#' getFactions function
#'
#' getFactions is a support function for inferring faction leaders and their members as well as a faction size ratio of each faction.
#' Leaders are nodes that have zero outgoing degree. Members of leader A's faction are nodes that have some directed path to A in a following network.
#'
#' @param adjMat is an adjacency matrix of a following network.
#'
#' @return This function returns a list of leader IDs, a list of faction members, and network densities of factions.
#'
#'\item{leaders}{ is a list of faction leader IDs  }
#'\item{factionMembers}{ is a list of members of factions where \code{factionMembers[[i]]} is a list of faction members of a leader \code{leaders[i]}'s faction. }
#'\item{factionSizeRatio}{ is a vector of faction size ratio of each faction.
#' \code{factionSizeRatio[i]} is a number of edges within a leader \code{leaders[i]}'s faction divided by N choose 2 where N is a number of all nodes.}
#'
#' @examples
#' # Given an example of adjacency matrix
#' A<-matrix(FALSE,5,5)
#' A[2,1]<-TRUE
#' A[c(3,4),2]<-TRUE
#' A[5,3]<-TRUE
#' # Get faction leaders and their members as well as a network density of each faction.
#'
#' out<-getFactions(adjMat=A)
#'
#'@export
#'
getFactions<-function(adjMat)
{
  N<-dim(adjMat)[1]
  IDs<-1:N
  leaders<-IDs[rowSums(adjMat) == 0] # list all zero-outgoing-degree nodes as leaders of factions
  factionSizeRatio<-numeric(N)
  factionMembers<-list()
  if(length(leaders)>=1) #if there is at least one faction
  {
    k<-1
    for(leader in leaders) # for each faction 'leader' in the leader list 'leaders'
    {
      followers<-getReachableNodes(adjMat,leader)$followers #list all members of leader's faction
      currFactionMembers<- c(leader,followers) # keep all faction members of leader into a list
      factionMembers[[k]] <- currFactionMembers # keep a list of leader's faction members into a time series list
      factionSizeRatio[leader]<-getFactionSizeRatio(adjMat,currFactionMembers) # Computing a faction size ratio
      k<-k+1
    }
  }
  return(list(leaders=leaders,factionMembers=factionMembers,factionSizeRatio=factionSizeRatio))

}
