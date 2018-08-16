# A full description is available at the site where the data was obtained:
#         
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.


library(dplyr)
if (!file.exists("UCI HAR Dataset.zip")){download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip", method = "curl")}
unzip("UCI HAR Dataset.zip")

#loads the test and train data, adds activity column, and combines into a single primary df
totaldf <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"), 
                 read.table("UCI HAR Dataset/train/X_train.txt"))

#assigns descriptive variable names to primary df
colnames(totaldf) <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)[,2]

#subsets primary df to variables representing mean and stdev for each measurement 
totaldf <- totaldf[,grep("mean\\(|std", names(totaldf))]

#adds descriptive activity labels in rows
activitydf <- rbind(read.table("UCI HAR Dataset/train/y_train.txt"), 
                    read.table("UCI HAR Dataset/test/y_test.txt"))
labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
activitydf <- left_join(activitydf, labels) #matches integer labels to descriptive labels
totaldf <- cbind(totaldf, activitydf[,2]) #adds descriptive labels to primary df
colnames(totaldf)[ncol(totaldf)] <- "activities"

#add subject numbers in rows
subjects <- rbind(read.table("UCI HAR Dataset/train/subject_train.txt"), 
                    read.table("UCI HAR Dataset/test/subject_test.txt"))
totaldf <- cbind(totaldf, subjects) 
colnames(totaldf)[ncol(totaldf)] <- "subject"

#creates new df with means of measurements for each subject for each activity
by_act_subj <- totaldf %>%
                group_by(activities, subject) %>%
                summarise_all(mean)

write.csv(by_act_subj, file = "by_act_subj.csv", row.names = F)


