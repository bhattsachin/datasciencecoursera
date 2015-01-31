rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  outcomedata <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  states<-unique(outcomedata[,7])
  if(!any(states==state)){
    stop("invalid state")
  }
  
  if(!(outcome == "heart attack" || outcome == "heart failure" || outcome == "pneumonia")){
    stop("invalid outcome")
    
  }
  
  if(!(num=="best" || num=="worst" || !is.na(as.numeric(num)) )){
    stop("invalid num") 
  }
  

  
  #all the hospitals
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
  
  finalvector<- outcomedatastate[!is.na(valueVector),]
  
  
  
  if(num=="best"){
    minVal<-min(valueVector,na.rm=TRUE)
    
    hospitalvector<-outcomedatastate[!is.na(valueVector) & valueVector==minVal,2]
    
    if(length(hospitalvector)>1){
      #sorting characters
      sortedvector <-hospitalvector[order(hospitalvector)]
      sortedvector[1]
    }else{
      hospitalvector
    }
  }else if(num=="worst"){
    maxVal<-max(valueVector,na.rm=TRUE)
    hospitalvector<-outcomedatastate[!is.na(valueVector) & valueVector==maxVal,2]
    
    if(length(hospitalvector)>1){
      #sorting characters
      sortedvector <-hospitalvector[order(hospitalvector)]
      sortedvector[length(sortedvector)]
    }else{
      hospitalvector
    }
  }else{
    
    if(as.numeric(num)>length(finalvector)){
      NA
    }else{
      
      resultvector<-finalvector[order(as.numeric(finalvector[,colnum]), finalvector[,2]),c(2)]
      resultvector[num]
    }
    
    
  }
  
  
  
  
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
}