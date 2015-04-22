#Getting and Cleaning Data Course Project: README

**This README describes how to execute run_analysis.R script. For details of run_analysis.R script, please see CookBook.md and the comments within the script.**


1. Download raw data from the following website: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Unzip raw data.
    * Files needed to execute run_analysis.R script will be under: .../UCI HAR Dataset
3. Place run_analysis.R script under .../UCI HAR dataset
4. Start R or RStudio
5. Set working directory to .../UCI HAR Dataset
6. source("run_analysis.R")
7. The following files are the output of run_analysis.R script. It will be created under .../UCI HAR Dataset:
    - merged_data.txt
        - It's the merged dataset of train and test data sets with just the features that pertain to mean and std.
        - Activity IDs have been updated with activity names.
        - All the column names are properly labeled.
        - It's a data frame with 10299 rows and 68 columns.
    - tidy_data.txt
        - melt() function was applied to data in merged_data.txt to make the wide dataset long. Each row represents the average of mean or std feature for each activity and each subject
        - It's a data frame with 11880 rows and 4 columns.