---
title: "CODEBOOK.md"
---

This file describes the variables, the data, and any transformations used to complete the course project.

A description of the raw data sets can be found here
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The raw data sets are found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The output file is a space-delimited text file named:
course_project_results.txt and will be output to the working directory.

The script (run_analysis.R) performs the following steps

* Install the plyr package if it isn't already installed
* Load the plyr package into the workspace
* Create variables containing the filenames of all input/output files
* Download the source data set (zip) file if it hasn't already been downloaded
* Unzip the zip file if it hasn't already been unzipped (verified by looking for one of the unzipped files)
* Load features and activity files into data frames and give appropriate column names
* Read and combine X, Y, and Subject "train"" and "test"" data sets into corresonding data frames and set descriptive column names
* Combined X, Y, Activity and Subject data frames into a single data frame
*  From the combined data set, create a final, independent tidy data 
set with the average of each variable for each activity and each subject.
* The result file contains 35 observations of 68 variables

Working variables in this script are:


* source_file:        Filename and path of source dataset (zip file)
* features_file:      Path and Filename of unzipped features file
* activity_file:       Path and Filename of unzipped activity file
* X_train_file:        Path and filename of unzipped X training data set (features)
* Y_train_file:        Path and filename of unzipped Y training data set (activities)
* subj_train_file:     Path and filename of unzipped Subject training data set
* X_test_file:         Path and filename of unzipped X test data set (features)
* Y_test_file:         Path and filename of unzipped Y test data set (activities)
* subj_test_file:      Path and filename of unzipped Subject test data set
* final_file:          Filename of final results file
* dest_zip_file:       Filename to place downloaded zip file.

* features:            Data frame containing features
* activities:          Data frame containing activity labels
* X_combined_data:     Data frame containing combined X training and test data
* Y_combined_data:     Data frame containing combined Y training and test data
* subj_combined_data:  Data frame containing combined Subject training/test data
* combined_data:       Data frame containing all combined X/Y/Subject data, but only mean and std columns
* final:               Data frame containing results - data set with average of each variable by activity/subject