# ReadMe file for Programming Assignment - Getting and Cleaning Data
The file run_analysis.R performs the following steps: 
1. Merge the training and the test sets to create one data set
  * for both sets, first read in the data, then add the activity labels and subject ID's 
  * create tibbles from both sets so we can use the dplyr package
  * add an identifier column to both tibbles to label the rows with either "train" or "test"
  * combine the two datasets using dplyr's bind_rows function into the data set called alldf
3. Use descriptive activity names to name the activities in the data set 
  * read in the table that links activity number to activity name
  * merge this table to the alldf data set to get descriptive activity names
4. Appropriately label the data set with descriptive variable names
  * read in the features.txt file that contains the variable names
  * set the names of alldf using the data frame that contains the features.txt data 
  * ensure there are no invalid characters in the variable names (for the next step) 
2. Extract only the measurements on the mean and standard deviation for each measurement 
  * Using the variable names, select only those columns that represent measurements on the mean and standard deviation for each measurement (using the helper function "contains" for "select" from the dplyr package)
5. From the data set in step, create a second, independent tidy data set with the average of each variable for each activity and each subject
  * with dplyr's "group_by" function, group the data set by activity and subject
  * with dplyr's "summarise_each" function, compute the mean of each measurement (so, excluding the ID columns). 
