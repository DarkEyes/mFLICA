#' @title  plotMultipleTimeSeries
#'
#' @description
#'
#' plotMultipleTimeSeries is a function for visualizing time series
#'
#'
#'@param TS is a set of time series where \code{TS[i,t,d]} is a numeric value of \code{i}th time series at time \code{t} and dimension \code{d}.
#'@param strTitle is a string of the plot title
#'@param TSnames is a list of legend of \code{X,Y} where TSnames[1] is a legend of \code{X} and  TSnames[2] is a legend of \code{Y}.
#'
#'@return This function returns an object of ggplot class.
#'
#'@examples
#' # Run the function
#' plotMultipleTimeSeries(TS=mFLICA::TS[1:5,1:60,1])
#'
#'@import ggplot2
#'@importFrom graphics plot
#'
#'@export
plotMultipleTimeSeries<-function(TS,strTitle="Time Series Plot",TSnames)
{
  N<-dim(TS)[1]
  name<-c()
  Tlength<-dim(TS)[2]
  Xaxis<-c()
  TSVec<-c()

  # Assign default text for time series legends if no values
  if(missing(TSnames))
  {
    TSnames<-c()
    for(i in seq(1,N))
    {
      TSnames[i]<-sprintf("TS#%d",i)
    }
  }

  # prepare one-dimentional time series data for ggplot
  for(i in seq(1,N))
  {
    name<-c(name,rep(x=TSnames[i],times=Tlength) )
    TSVec<-c(TSVec,TS[i,])
    Xaxis<-c(Xaxis,1:Tlength)
  }



  # plot time series using ggplot
  data1<-data.frame(Xaxis,TSVec,name)
  p<-ggplot(data1, aes(x=Xaxis, y=TSVec, group=name)) +
    geom_line(aes(color=name))+
    theme_light() + theme( text = element_text(size=20) )+
    ylab("Values") +xlab("Time steps")  +  labs(title = strTitle)
  p$labels$colour<-"Time series"

  return(p)
}
