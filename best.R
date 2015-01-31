best <- function(state, outcome) {
  ## Read outcome data
  outcomedata <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

  ## Check that state and outcome are valid
  if(!(outcome == "heart attack" || outcome == "heart failure" || outcome == "pneumonia")){
    stop("invalid outcome")
    
  }
  
  states<-unique(outcomedata[,7])
  if(!any(states==state)){
    stop("invalid state")
  }
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
  #find all the hospitals in this state
  outcomedatastate<-outcomedata[outcomedata[,7]==state,]
  
  colnum<-1
  if(outcome=="heart attack"){
    colnum<-11
  }else if(outcome=="heart failure"){
    colnum<-17
  }else{
    colnum<-23
  }
  
valueVector<- as.numeric(outcomedatastate[,colnum])
minVal<-min(valueVector,na.rm=TRUE)
hospitalvector<-outcomedatastate[!is.na(valueVector) & valueVector==minVal,2]

if(length(hospitalvector)>1){
  #sorting characters
  sortedvector <-hospitalvector[order(hospitalvector)]
  sortedvector[1]
}else{
  hospitalvector
}


}
