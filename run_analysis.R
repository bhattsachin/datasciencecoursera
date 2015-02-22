# Activity Recognition Using Smartphones


run_analysis <- function(){
  
  #for this exercise we assume the file has been downloaded and zipped
  #temp <- tempfile()
  #download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp, method="curl")
  #unz(temp, "UCI")
  current_dir<-getwd()
  
  #set work space to UCI directory
  setwd("UCI") 
  
  #read and merge the outside files
  write.table(do.call(rbind, lapply(c("test/y_test.txt", "train/y_train.txt"), read.csv)), file="combined/y.txt", row.names=FALSE, col.names=FALSE)
  write.table(do.call(rbind, lapply(c("test/X_test.txt", "train/X_train.txt"), read.csv, sep="", header=FALSE)), file="combined/X.txt", row.names=FALSE, col.names=FALSE)
  write.table(do.call(rbind, lapply(c("test/subject_test.txt", "train/subject_train.txt"), read.csv, sep="", header=FALSE)), file="combined/subject.txt", row.names=FALSE, col.names=FALSE)
  
  #merge the files inside Inertial Signals
  inertial_files<-list.files("test/Inertial Signals")
  dir.create(file.path("combined","Inertial Signals"), showWarnings = FALSE)
  for (inertial_file in inertial_files){
    write.table(do.call(rbind, lapply(c(paste("test/Inertial Signals/", inertial_file, sep=""),  
                                        paste("train/Inertial Signals/", gsub('test', 'train', inertial_file), sep="")), read.csv, sep="", header=FALSE)), 
                        file=paste("combined/Inertial Signals/", gsub('_test','',inertial_file), sep=""), row.names=FALSE, col.names=FALSE)
  }
  
  
  
  
  #Set back the current working directory
  setwd(current_dir)
  
  
}