#' getFactions function
#'
#' getFactions is a support function for inferring faction leaders and their memebers as well as a network density of each faction.
#' Leaders are nodes that have zero outgoing degree. Members of leader A's faction are nodes that have some directed path to A in a following network.
#'
#' @param adjMat is an adjacency matrix of a following network.
#'
#' @return This function returns a list of leader IDs, a list of faction members, and network densities of factions.
#'
#'\item{leaders}{ is a list of faction leader IDs  }
#'\item{factionMembers} { is a list of memebrs of factions where \code{factionMembers[[i]]} is a list of faction members of a leader \code{leaders[i]}'s faction. }
#'\item{factionSizeRatio} { is a vector of faction size ratio of each faction.
#' \code{factionSizeRatio[i]} is a number of edges within a leader \code{leaders[i]}'s faction divided by N choose 2 where N is a number of all nodes.}
#'
#' @examples
#' # Given an example of adjacency matrix
#' A<-matrix(FALSE,5,5)
#' A[2,1]<-TRUE
#' A[c(3,4),2]<-TRUE
#' A[5,3]<-TRUE
#' # Get faction leaders and their memebers as well as a network density of each faction.
#'
#' out<-getFactions(adjMat=A)
#'
#'@export
#'
getFactions<-function(adjMat)
{
  N<-dim(adjMat)[1]
  IDs<-1:N
  leaders<-IDs[rowSums(adjMat) == 0]
  factionSizeRatio<-numeric(N)
  factionMembers<-list()
  if(length(leaders)>=1)
  {
    k<-1
    for(leader in leaders)
    {
      followers<-getReachibleNodes(adjMat,leader)$followers
      currFactionMembers<-c(leader,followers)
      factionMembers[[k]] <- currFactionMembers
      factionSizeRatio[leader]<-getFactionSizeRatio(adjMat,currFactionMembers)
      k<-k+1
    }
  }
  return(list(leaders=leaders,factionMembers=factionMembers,factionSizeRatio=factionSizeRatio))

}
