# Getting and Cleaning data project R file description

For this project the raw data is obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A decription of the methods used to obtain the data and variable names are available in the readme and features txt files that are part of the data set.


This project has 5 objectives:

1) To merge training and testing data sets

2) To extract only the mean and std dev of the measurements in the data set

3) To add a descriptive name to the activities rather than a numeric value to describe the activity

4) Add labels for variables in the data set

5) Create a tidy data set for the mean of each variable for each activity for each user from the data set in task 4

The r file in this project tackles each of the above items and eventually saves a tidy data set in a file called tidy_data.txt.
A description of the variables in the tidy_data.txt is provided in the code_book.md file.

## Using the r code to obtain a tidy_data set

First download the zip file with the raw data from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Save this file in the working directory from where the R code is run eg: /User/tadinadb/

Then unzip this file which will create a directory called UCI HAR Dataset with the test and training data sets along with
the details of what has been measured, derived from measurements and transformed

The final step is to run the cleaningData_courseproject.r from your R console or R studio.

Once run as a final set tidy_data.txt file will be generated in your UCI HAR Dataset directory that can be further used for any analysis

## Explaination of the code

The code is commented with details of the approach followed to obtain the data required. However the below is a brief explaination
of the code

The first section of the code involves reading the training set data. This involves reading data into 3 datasets as the raw data
is split into 3 different sections. The first with 591 variables of measured, derived, transformed values. The second the activity
and finally, the third the subject involved in the activity. Once the datasets are created they are merged into a single dataset
of training data

The next section reads the testing data set. It follows a similar pattern as obtaining a unified dataset for the training dataset.


With the two datasets available a unified dataset is created which combines the data from the training and testing datasets.

This unified dataset now needs to be subsetted to include only variables that are mean or standard deviation values of measurements.
To do this we read the features.txt available in the zip file that provides details of the variables we have just read into the data set.
Using the standard grep command (a standard linux command line tool) to extract the column indexes of all variables that contain
mean or standard deviation values of the measurements. With the index available, we can easily subset the data from the unified data set
to obtain the filtered_data dataset. To complete the filtered_data set we need to add the subject and activity for each row which
can be taken from the unified data set obtained in the earlier step.

The filtered_data dataset can now have its columns named appropriately so that users can have a context of the data they are observing.
To do this we again go back to the features.txt file that names all the columns we have in our unified dataset. So we just extract
the names from the features.txt file by again using the indexes we used to create the filtered_data dataset. We take only the 2nd 
portion of the line read by using the strsplit command and assign it to the colnames of filtered_data dataset. Finally we need to
add the activity and subject column names as this is not present in the features.txt file.

We are also tasked to rename the activity with a description rather than a numeric represtation of the activity. This is again
obtained by filtering the data based on the filtered_data's activity column and its values. As there are only 6 possible values 
for activities we go through each of the possible values and assign a description of the activity to override the numeric value
of the activity in the filtered_data's activity column

The last task to obtain the tidy data set we obtain the tidy data of values of the average of each variable grouped by activity
and subject. This is done using 2 for loops to loop through all unique subjects and first and for each user loop through all possible
activities. The filtered_data set is therefore subsetted further to obtain a dataset with just values for a particular subject, for 
a particular activity. The colMeans command is then used to obtain the mean value of each of variables available. We further 
need to transpose this as the colMeans command provides us an n-row dataset which we need to transpose to an n-column dataset.
Once transposed we add the additional columns of activity and subject. This is then added using the rbind (row bind) command to append
the new row the tidy_data dataset. When the for loops complete we have a tidy_data dataset complete with the data we required.

For clarity column names are added for the tidy_data dataset and the dataset is saved to disk using the write.table command.
