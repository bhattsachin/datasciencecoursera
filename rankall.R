rankall <- function(outcome, num = "best") {
  ## Read outcome data
  outcomedata <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  states<-unique(outcomedata[,7])
  
  if(!(outcome == "heart attack" || outcome == "heart failure" || outcome == "pneumonia")){
    stop("invalid outcome")
    
  }
  
  colnum<-1
  if(outcome=="heart attack"){
    colnum<-11
  }else if(outcome=="heart failure"){
    colnum<-17
  }else{
    colnum<-23
  }
  
  outcomedata<-outcomedata[,c(1,2,7,colnum)]
  
  ## For each state, find the hospital of the given rank
  resultframe<-data.frame(hospital = NA, state=states)
  
  #best is same as first
  if(num=="best"){
    num <- 1
  }
  #keep point on worst stuff
  isworst<-FALSE
  if(num=="worst"){
    num<-1
    isworst<-TRUE
  }
  
  for(state in states){
    outcomedatastate<-outcomedata[outcomedata[,3]==state,]
    valueVector<- as.numeric(outcomedatastate[,4])
    finalvector<- outcomedatastate[!is.na(valueVector),]
    if(as.numeric(num)<=length(finalvector[,1])){
      if(isworst){
        resultvector<-finalvector[order(-as.numeric(finalvector[,4]), finalvector[,2]),c(2)]
      }else{
        resultvector<-finalvector[order(as.numeric(finalvector[,4]), finalvector[,2]),c(2)]
      }
     
      resultframe[resultframe[,2]==state,1]<-resultvector[num]
      
      
    }
    
  }
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  resultframe[order(resultframe[,2]),]
}