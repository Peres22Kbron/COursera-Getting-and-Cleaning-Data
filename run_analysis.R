library(data.table);library(plyr);library(dplyr)

#Merge the training and the test sets to create one data set.Set the appropriate 
#working directory and read the data sets into R. I read and include in the 
#merged data the subject and activity labels.

setwd("c:/Users/Peres/Downloads/data_science_coursera/03_getting_and_cleaning_data/course_project/UCI HAR Dataset/train/");dir()
train_subject<-fread("subject_train.txt",col.names="subject")
train_set<-fread("X_train.txt")
train_labels<-fread("y_train.txt",col.names="activity")

setwd("c:/Users/Peres/Downloads/data_science_coursera/03_getting_and_cleaning_data/course_project/UCI HAR Dataset/test/");dir()
test_subject<-fread("subject_test.txt",col.names="subject")
test_set<-fread("X_test.txt")
test_labels<-fread("y_test.txt",col.names="activity")

train<-cbind(train_subject,train_labels,train_set)
test<-cbind(test_subject,test_labels,test_set)

df<-rbind(train,test)

#Extracts only the measurements on the mean and standard deviation for each 
#measurement. Set the appropriate working directory and read the features data 
#sets into R. First, I manipulated the features$V2 character vector to 
#appropriately label the merged data (df) with it. Then, I extracted only 
#variables containingthe mean and standard deviation values.

setwd("c:/Users/Peres/Downloads/data_science_coursera/03_getting_and_cleaning_data/course_project/UCI HAR Dataset/");dir()
features<-fread("features.txt")

features$V2<-gsub("-mean","mean",features$V2)
features$V2<-gsub("-std","sd",features$V2)
features$V2<-gsub("[-()]","",features$V2)

colnames(df)<-c(names(df)[1:2],tolower(features$V2))

cols_clean<-c(1,2,grep(".*mean.*|.*sd.*",colnames(df)))
df<-select(df,cols_clean)

#Use descriptive activity names to name the activities in the data set. Set the
#appropriate working directory and read into R the activity labels data set and
#replace activity labels in the df data set to their names.

setwd("c:/Users/Peres/Downloads/data_science_coursera/03_getting_and_cleaning_data/course_project/UCI HAR Dataset/");dir()
activity_labels<-fread("activity_labels.txt",col.names=c("label","activity"))

from<- unique(sort(df$activity))
to<-tolower(activity_labels$activity)
df$activity<-mapvalues(df$activity,from,to)

aggregate(df,by=list(activity=df$activity,subject=df$subject),mean)

#Create a second, independent tidy data set with the average of each variable 
#for each activity and each subject.After that, remove the subject and activity
#mean values calculated since they have no value to the assignment.
tidy<-aggregate(df,by=list(activity=df$activity,subject=df$subject),mean)
tidy<-tidy[,-c(3,4)]

write.table(tidy,"c:/Users/Peres/Downloads/data_science_coursera/03_getting_and_cleaning_data/course_project/assignment_files/tidy.txt",sep="\t",row.names=FALSE)