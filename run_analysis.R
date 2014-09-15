## 1. read the data that are common to both testing and training set
##
features<-read.table("UCI HAR Dataset\\features.txt")
activityLabel<-read.table("UCI HAR Dataset\\activity_labels.txt", col.names=c("activity","activityName"), colClasses=c("factor","factor"))


## 2. read testing data set
##
testx<-read.table("UCI HAR Dataset\\test\\X_test.txt", col.names = features[,2])

subjectTest<-read.table("UCI HAR Dataset\\test\\subject_test.txt", colClasses = c("integer"), col.names = c("subject"))

activityTest<-read.table("UCI HAR Dataset\\test\\Y_test.txt", colClasses = c("factor"), col.names = c("activity"))

## combine x_test, subject_test, Y_test into a single table
testx <- cbind(cbind(subjectTest,activityTest),testx)

## 3. read training data set
##
trainx<-read.table("UCI HAR Dataset\\train\\X_train.txt", col.names = features[,2])

subjectTrain<-read.table("UCI HAR Dataset\\train\\subject_train.txt", colClasses = c("integer"), col.names = c("subject"))

activityTrain<-read.table("UCI HAR Dataset\\train\\Y_train.txt", colClasses = c("factor"), col.names = c("activity"))

## combine x_train, subject_train, Y_train into a single table
trainx <- cbind(cbind(subjectTrain,activityTrain),trainx)


## 4. Merges the training and the test sets to create one data set - fulldata
fulldata <- rbind(testx, trainx)

## 5. Extracts only the measurements on the mean and standard deviation for each measurement using grep function
## First two columns ("subject" and "activity") are included in selection, and therefore,
## need to add 2 to the positions of subsequent columns
interestedData<-fulldata[,c(1,2,grep("mean|std",features[,2], ignore.case=TRUE)+2)]

require(dplyr)
rpt <- tbl_df(interestedData)
label <- tbl_df(activityLabel)


## 6. 
rpt<-rpt %>%
    left_join(label,by="activity") %>%   ##Uses descriptive activity names to name the activities in the data set
    group_by(subject, activityName) %>%  ##group the data based on activity and subject
    summarise_each(funs(mean)) %>%  ##compute the average of each variable based on the groups
    arrange(subject, activity) %>%  ##sort the result base don subject, followed by activity
    select(-activity)   ## drop activity column from final output, since output requires "activity name" only.

## 7. Appropriately labels the data set with descriptive variable names. 
## Standardise all mean / std related variables to Mean / Std respectively
## Remove all .
names(rpt)<-gsub("\\.mean","Mean", names(rpt),)
names(rpt)<-gsub("\\.std","Std",names(rpt),)
names(rpt)<-gsub("\\.","",names(rpt),)

## 8. Output: rpt - An independent tidy data set with the average of each variable for each activity and each subject.
write.table(rpt,file="tidy.txt", row.names=FALSE)