#Getting and Cleaning Data Course Project: CodeBook

**Study Design**

* Here are the details of run_analysis.R script to create tidy data. For setup information, please refer to README.md.
    1. Following libraries were loaded in R
        + library(data.table)
        + library(reshape2)
        + library(timeSeries)
    2. The following files were read into R using read.table(). Description of the files is from the README.txt file included in the zip file.
        + activity_labels.txt <- read.table("./activity_labels.txt")
            - Links the class label with their activity name.
        + features.txt <- read.table("./features.txt")
            - List of all features.
        + subject_test.txt <- read.table("./test/subject_test.txt")
            - Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
        + X_test.txt <- read.table("./test/X_test.txt")
            - Test set.
        + y_test.txt <- read.table("./test/y_test.txt")
            - Test label.
        + subject_train.txt <- read.table("./train/subject_train.txt")
            - Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
        + X_train.txt <- read.table("./train/X_train.txt")
            - Train set.
        + y_train.txt <- read.table("./train/y_train.txt")
            - Train label.
    3. (Instruction step 1) Datasets in train and test directories were merged to a master dataset using rbind().
        + subject_master.txt <- rbind(subject_train.txt, subject_test.txt)
            - 1 column. It is the subject ID. There are 30 subjects from 1 - 30.
            - 10299 rows. Each row identifies the subject who performed the activity for fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
        + X_master.txt <- rbind(X_train.txt,X_test.txt)
            - 561 columns. Each column is a measurement of a feature.
            - 10299 rows. Each row consists of 561 measurements per activity per subject for a window sample.
        + y_master.txt <- rbind(y_train.txt,y_test.txt)
            - 1 column. It is the activity ID. There are 6 activities from 1 - 6.
            - 10299 rows. Each row identifies an activity performed by a subject for a window sample.
    4. (Instruction step 2) Columns that measure mean() or std() have been extracted from X_master.txt to form mean.std.data
        + mean.std.features <- subset(features.txt, grepl("mean\\(",features.txt\$V2, ignore.case=TRUE) | grepl("std\\(",features.txt$V2, ignore.case=TRUE))
            - Of the 561 features in features.txt, 66 features that measure mean() or std() have been assigned to mean.std.features.
        + mean.std.data <- select(X_master.txt, mean.std.features$V1)
            - 66 columns that correspond to features in mean.std.features have been selected from X_master.txt to form mean.std.data
    5. (Instruction step 3) Assign descriptive activity names to name the activities in the data set
        + master.data <- cbind(subject_master.txt, y_master.txt, mean.std.data)
            - use cbind() to concatnate subject_master.txt, y_master.txt, and mean.std.data to form master.data
        + setnames(activity_labels.txt, 1:2, c("activity_id", "activity"))
            - assign column names to activity_labels.txt
        + setnames(master.data, 1, "subject_id")
            - assign descriptive name to 1st column in master.data
        + setnames(master.data, 2, "activity_id")
            - assign descriptive name to 2nd column in master.data
        + merged.data <- merge(activity_labels.txt, master.data, by="activity_id")
            - merge activity_labels.txt and master.data by activity_id to form merged.data
        + merged.data <- merged.data[,-1]
            - Drops the activity_id as it is not longer needed.
    5. (Instruction step 4) Label merged.data with descriptive variable names. 
        + mean.std.features_list <- lapply(mean.std.features$V2, as.character)
            - lapply is used to create a list of features called mean.std.features_list
        + setnames(merged.data, 3:length(merged.data), unlist(mean.std.features_list))
            - column names are assigned to merged.data using the list mean.std.features_list from previous step
    7. (Instruction step 5) From the data set in Step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
        + aggregated.data <- aggregate(merged.data[, 3:length(merged.data)], list(merged.data\$subject_id, merged.data$activity), mean)
            - aggregate() function is used to calculate the mean of each feature variable for each activity and each subject
        + tidy.data <- melt(aggregated.data, id.vars = c("Group.1","Group.2"))
            - melt() is used to make the wide dataset long. Each row now represents the average of a feature for each activity and each subject
        + setnames(tidy.data, 1:4, c("subject", "activity", "mean and std features", "average of mean and std features"))
            - Meaningful column names are assigned
        + write.table(tidy.data, file="./tidy_data.txt", row.name=FALSE)
            - tidy.data is written to a output file


**Code book**

* subject
    - ID of the subject.
* activity
    - activity names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* activity_id
    - activity ID for each activity
* mean and std features
    - Features pertaining to mean and std from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
* average of mean and std features
    - average of the mean values for each feature per activity per subject and average of std values for each feature per activity per subject
    - the values are bounded within [-1,1]

