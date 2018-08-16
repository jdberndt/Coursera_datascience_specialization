This repository contains one R script called **run_analysis.R** that takes two data files (X_train.txt and X_test.txt from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and does the following:  
  
1. Merges the training and the test sets to create one data set.
2. Uses descriptive measurement names to appropriately label variables.
3. Adds a factor variable that can be used to break down the data set by activity.
4. Adds a integer variable that identifies the subject/participant in the study.
5. Extract variables containing  the mean and standard deviation for each type of measurement.
6. Creates a second data frame that contains the means for each type of measurement for each activity for each subject.