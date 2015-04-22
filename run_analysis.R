# load libraries
library(data.table)
library(reshape2)
library(timeSeries)

# read data into R
activity_labels.txt <- read.table("./activity_labels.txt")
features.txt <- read.table("./features.txt")

subject_test.txt <- read.table("./test/subject_test.txt")
X_test.txt <- read.table("./test/X_test.txt")
y_test.txt <- read.table("./test/y_test.txt")

subject_train.txt <- read.table("./train/subject_train.txt")
X_train.txt <- read.table("./train/X_train.txt")
y_train.txt <- read.table("./train/y_train.txt")


## Step 1: Merges the training and the test sets to create one data set.

subject_master.txt <- rbind(subject_train.txt, subject_test.txt)
X_master.txt <- rbind(X_train.txt,X_test.txt)
y_master.txt <- rbind(y_train.txt,y_test.txt)

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# Subset only mean() and std() features. "\\" is the escape character for punctuation like "(".
mean.std.features <- subset(features.txt, grepl("mean\\(",features.txt$V2, ignore.case=TRUE) | grepl("std\\(",features.txt$V2, ignore.case=TRUE))
# create a dataset of only mean() and std() measurements
mean.std.data <- select(X_master.txt, mean.std.features$V1)

## Step 3: Uses descriptive activity names to name the activities in the data set

master.data <- cbind(subject_master.txt, y_master.txt, mean.std.data)

setnames(activity_labels.txt, 1:2, c("activity_id", "activity"))
setnames(master.data, 1, "subject_id")
setnames(master.data, 2, "activity_id")

merged.data <- merge(activity_labels.txt, master.data, by="activity_id")
merged.data <- merged.data[,-1] # Drops the activity_id as it is not longer needed.

## Step 4: Appropriately labels the data set with descriptive variable names. 

mean.std.features_list <- lapply(mean.std.features$V2, as.character)
setnames(merged.data, 3:length(merged.data), unlist(mean.std.features_list))

write.table(merged.data, file="./merged_data.txt", row.name=FALSE)

## Step 5: From the data set in step 4, create a second, independent tidy data set
## with the average of each variable for each activity and each subject.

aggregated.data <- aggregate(merged.data[, 3:length(merged.data)], list(merged.data$subject_id, merged.data$activity), mean)

tidy.data <- melt(aggregated.data, id.vars = c("Group.1","Group.2"))

setnames(tidy.data, 1:4, c("subject", "activity", "mean and std features", "average of mean and std features"))
write.table(tidy.data, file="./tidy_data.txt", row.name=FALSE)