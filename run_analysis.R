# Getting and Cleaning Data
# Programming assignment week 4
# Purpose of this script: 
# 1. Merge training and test sets to create one data set 
# 2. Extract only the measurements on the mean and standard deviation for each measurement
# 3. Use descriptive activity names to names the activities in the data set 
# 4. Appropriately label the data set with descriptive variable names
# 5. From the data set in step 4, create a second independent tidy data set with the average of each variable
#    for each activity and each subject. 

# Date: 10-03-2017
#

# set working directory
setwd("C:/Users/isabe/Dropbox/Rprogramming/course3/week4/programmingassignment")

# download and combine test data into one data frame, including subject_test

file_path_testx <- "./UCI HAR Dataset/test/X_test.txt"
file_path_testy <- "./UCI HAR Dataset/test/Y_test.txt"
file_path_testsubject <- "./UCI HAR Dataset/test/subject_test.txt"
testdata_data <- read.table(file_path_testx)
testdata_labels <- read.table(file_path_testy)
testdata_subject <- read.table(file_path_testsubject)

testdata <- cbind(testdata_subject, testdata_labels, testdata_data)
names(testdata)[1:2] <- c("subject", "activity")
View(testdata)

# Download and combine train data into one data frame, including subject_train

file_path_trainx <- "./UCI HAR Dataset/train/X_train.txt"
file_path_trainy <- "./UCI HAR Dataset/train/Y_train.txt"
file_path_trainsubject <- "./UCI HAR Dataset/train/subject_train.txt"
traindata_data <- read.table(file_path_trainx)
traindata_labels <- read.table(file_path_trainy)
traindata_subject <- read.table(file_path_trainsubject)

traindata <- cbind(traindata_subject, traindata_labels, traindata_data)
names(traindata)[1:2] <- c("subject", "activity")
View(traindata)


# Create tbl so we can work with dplyr
testdf <- tbl_df(testdata)
traindf <- tbl_df(traindata)
rm(testdata)
rm(traindata)

# Test whether the two data sets have the same columns
#names(testdf) == names(traindf)

# Add column with test/train identifier
testdf <- testdf %>%
    # add identifier column
    mutate(identifier = "test") %>%
    # reorder the columns
    select(identifier, subject, activity, V1:V561)
    
traindf <- traindf %>%
    # add identifier column
    mutate(identifier = "train") %>%
    # reorder the columns
    select(identifier, subject, activity, V1:V561)

View(testdf)
View(traindf)

# Combine into one data set
alldf <- bind_rows(testdf, traindf)

# Add descriptive activity names 

# Download the activity names
file_path_activitynames <- "./UCI HAR Dataset/activity_labels.txt"
activitynames <- read.table(file_path_activitynames)
names(activitynames) = c("activity", "activityname")

# Merge the activity names into the data set 
alldf <- alldf %>%
    # include descriptive activity names
    merge(activitynames, by="activity") %>%
    # reorder the columns
    select(identifier, subject, activity, activityname, V1:V561)



# Label the variable columns with descriptive variable names (from features.txt)
# Download the variables from the features text file 
file_path_features <- "./UCI HAR Dataset/features.txt"
features <- read.table(file_path_features)
features_names <- as.vector(features[,2])
# Define the names of alldf using the variable names from the features text file
names(alldf) <- c("identifier", "subject", "activity", "activitynames", features_names)

# The following step is to ensure we don't have any invalid characters in the column names
# This will ensure we can use the special function "contains" that comes with select in the dplyr package
valid_column_names <- make.names(names=names(alldf), unique=TRUE, allow_ = TRUE)
names(alldf) <- valid_column_names


# Extract only the measurements on the mean and standard deviation for each measurement:  
# We select all columns that have either "mean" or "std" included in their name. 
alldf_selected <- alldf %>%
    select(identifier:activitynames, contains("mean"), contains("std"))
View(alldf_selected)

# Create data set with average of each variable for each activity and each subject
grouped_data <- alldf_selected %>%
    # group by subject and activity so we get the mean for each subject and each activity
    group_by(subject, activity) %>%
    # only summarize the columns that represent measure variables (and not the ones with ID variables)
    summarize_each(funs(mean), -(identifier:activitynames))
# View(grouped_data)
# str(grouped_data)

# Download grouped_data as a text file 
# dit nog afmaken
write.table(grouped_data)


