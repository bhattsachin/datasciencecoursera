# Activity Recognition Using Smartphones


run_analysis <- function(){
  
  #fdownload file and unzip
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp, method="curl")
  unz(temp, "UCI")
  
  current_dir<-getwd()
  
  #set work space to UCI directory
  setwd("UCI") 
  
  #read and merge the outside files
  write.table(do.call(rbind, lapply(c("test/y_test.txt", "train/y_train.txt"), read.csv, sep="", header=FALSE)), file="combined/y.txt", row.names=FALSE, col.names=FALSE)
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
  
  # read the merged data
  combined_x<-read.csv("combined/X.txt", sep="", header=FALSE)
  
  #read features too
  features<-read.table("features.txt")
  
  #all the columns with mean and standard deviation
  desired_features<-features[grepl("-mean\\(\\)|-std\\(\\)", features$V2),]
  desired_cols<-features[grepl("-mean\\(\\)|-std\\(\\)", features$V2),c(1)]
  
  mean_and_std<-combined_x[,desired_cols]
  
  
  # 3. bind descriptive label
  merged_labels<-read.table("combined/y.txt", sep="")
  activities_label<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
  merged_labels$V1<-activities_label[merged_labels$V1]
  names(merged_labels)<-c("Activity")
  #merge this with the feature vector
  
  
  #4 descriptive variable names
  #clean variable names
  desired_features$V2<-gsub('-mean\\(\\)', 'Mean', desired_features$V2)
  desired_features$V2<-gsub('-std\\(\\)', 'Deviation', desired_features$V2)
  desired_features$V2<-gsub('^f', 'Frequency', desired_features$V2)
  desired_features$V2<-gsub('Acc', 'Acceleration', desired_features$V2)
  desired_features$V2<-gsub('^t', 'Time', desired_features$V2)

  #bodybody to be replaced by Body and remove hyphens
  desired_features$V2<-gsub('BodyBody', 'Body', desired_features$V2)
  desired_features$V2<-gsub('-', '', desired_features$V2)

  names(mean_and_std)<-desired_features$V2
  
  ## 3 add subject and activity to this set
  merged_subjects<-read.table("combined/subject.txt", sep="")
  names(merged_subjects)<-c("Subject")
  
  mean_and_std<-cbind(merged_labels, merged_subjects, mean_and_std) 

  # 5 mean of columns except first and second, group by subject and activity
  tidyData<-ddply(mean_and_std, c("Subject", "Activity"), function(x) colMeans(x[,-c(1,2)]))
  
  write.table(tidyData, "tidyData.txt", row.names=FALSE, col.names=TRUE)
  
  #Set back the current working directory
  setwd(current_dir)
  
  
}