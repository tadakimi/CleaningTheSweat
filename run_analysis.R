#requires dplyr package
#there are 5 tasks required for the assignment

#Merges the training and the test sets to create one data set
#load the test set
test.set <- read.table("test/X_test.txt"); head(test.set)
#load activity id
test.label <- read.table("test/y_test.txt", col.names = "activity.id"); head(test.label)
#load subject id
test.subject <- read.table("test/subject_test.txt", col.names = "subject.id")
#add activity id and subject id to the set
test.set <- cbind(test.set, test.label, test.subject)

#load the train set
train.set <- read.table("train/X_train.txt"); head(train.set)
#load activity id
train.label <- read.table("train/y_train.txt", col.names = "activity.id"); head(train.label)
#load subject id
train.subject <- read.table("train/subject_train.txt", col.names = "subject.id")
#add activity id and subject id to the set
train.set <- cbind(train.set, train.label, train.subject)

#Task 1: Merges the training and the test sets to create one data set.
#rbind both set and check the dimention
merged.set <- rbind(test.set, train.set); dim(merged.set) #variable 563
#read the variable names from features.txt
variables <- read.table("features.txt"); dim(variables) #$V2 is the variable name
colnames(merged.set) <- variables$V2; head(merged.set)
colnames(merged.set)[562:563] <- c("activity.id", "subject.id"); head(merged.set)

#Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
#subset by grep either mean(), std(), or in the colnames
mergedData = merged.set[, grep("mean\\(\\)|std\\(\\)|activity|subject", colnames(merged.set))]; head(mergedData)

#Task 3: Uses descriptive activity names to name the activities in the data set
#read activity lookup table, V1 is the number and V2 is the Activity Label
activity.lookup <- read.table("activity_labels.txt", col.names = c("activity.id", "activity.name")); activity.lookup
#use merge to get the activity name by activity id
mergedData <- merge(mergedData, activity.lookup, by = "activity.id"); head(mergedData)
#remove the activity id from the data
mergedData <- mergedData[2:ncol(mergedData)]; head(mergedData)

#Task 4: Appropriately labels the data set with descriptive variable names
#use gsub to get rid of () from the colnames of mergedData
colnames(mergedData) <- gsub("\\(\\)", "", colnames(mergedData)); colnames(mergedData)

#Task 5: From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
library(dplyr)
#group the mergedData by activity name then subject id
by_activity_subject <- group_by(mergedData, activity.name, subject.id)
#use summarise_each to apply means to each groups on each columns
DataSummary <- summarise_each(by_activity_subject, funs(mean))
#write the resulting table into a file
write.table(DataSummary, file = "tidydata.txt", row.names = FALSE)
test <- read.table("tidydata.txt", header = TRUE); head(test)

