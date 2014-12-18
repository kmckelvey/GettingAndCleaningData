##--------------------------------------------------------------------------
## Name:    run_analysis.R
##
## By:      Ken McKelvey
##
## The purpose of this script is to meet the course project requirements for
## the Coursera "Getting and Cleaning Data" online class. There are 5 specific
## instructions, each identified below in a numbered comment block.
##---------------------------------------------------------------------------

## The "plyr" package is used in the script
## So make sure the package is installed
if (!("plyr" %in% rownames(installed.packages())))
{
    install.packages("plyr")
}

## load the plyr package
library(plyr)

## Initialize variables with the necessary file names
## that contain the project dataset

## Directory where data files are stored after being unzipped
data_dir        <- "UCI HAR Dataset/"

##------------
## input files
##------------

## The location of the data zip file
source_file     <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Features and activity datasets - filenames
features_file   <- paste(data_dir,"features.txt",sep="")
activity_file   <- paste(data_dir,"activity_labels.txt",sep="")

## training files
X_train_file        <- paste(data_dir,"train/X_train.txt" ,sep="")        
Y_train_file        <- paste(data_dir,"train/Y_train.txt",sep="")         
subj_train_file     <- paste(data_dir,"train/subject_train.txt",sep="")

## test files
X_test_file         <- paste(data_dir,"test/X_test.txt",sep="")
Y_test_file         <- paste(data_dir,"test/Y_test.txt",sep="")       
subj_test_file      <- paste(data_dir,"test/subject_test.txt",sep="")  

#-------------
# output files
#-------------
final_file          <- "course_project_results.txt"   ## Result output file
dest_zip_file       <- "accelerometer_data.zip"       ## Destination zip file

## Download the source zip file from the Internet
## if it hasn't already been downloaded
if (!file.exists(dest_zip_file))
{
  download.file(source_file,destfile=dest_zip_file,quiet=TRUE,mode="wb")
}

## unzip the source zip file if it hasn't already been unzipped
if (!file.exists(features_file))
{
  unzip(dest_zip_file,overwrite=FALSE)
}

## Load features and activities into corresponding data frames
## and give appropriate column names
features <- read.csv(features_file,sep="",header=FALSE,
                     col.names=c("feature_no","feature_name"))

activities <- read.csv(activity_file,sep="",header=FALSE,
                       col.names=c("activity_no","activity"))

##--------------------------------------------------------------------------
## 1. Merges the training and the test sets to create one data set.
##
## 2. Extracts only the measurements on the mean and standard deviation for 
##    each measurement.
##
## 3. Uses descriptive activity names to name the activities in the data set
##
## 4. Appropriately labels the data set with descriptive variable names.
##--------------------------------------------------------------------------

## Combine all test and train datasets into X, Y, and Subject components
X_combined_data <- rbind(read.csv(X_train_file,header=FALSE,sep=""), 
                         read.csv(X_test_file,header=FALSE,sep=""))  

Y_combined_data <- rbind(read.csv(Y_train_file,header=FALSE,sep=""),
                         read.csv(Y_test_file,header=FALSE,sep="")) 

subj_combined_data <- rbind(read.csv(subj_train_file,header=FALSE,sep=""),
                            read.csv(subj_test_file,header=FALSE,sep=""))

# set variable descriptive column names
colnames(X_combined_data)    <- as.character(features$feature_name)
colnames(Y_combined_data)    <- c("activity_no")
colnames(subj_combined_data) <- c("subject")

# Extract only mean() and std() columns
X_combined_data <- 
    X_combined_data[,sort( c(grep("std()",colnames(X_combined_data),value=FALSE,fixed=TRUE ),
                             grep("mean()",colnames(X_combined_data),value=FALSE,fixed=TRUE )))]

##-----------------------------------------------------------------
## Combine X, Y, activity and subject data sets.
##-----------------------------------------------------------------
combined_data <- cbind( subj_combined_data,
                        cbind(join(Y_combined_data,activities,by="activity_no"),
                              X_combined_data))
## remove activity_no variable
combined_data$activity_no <- NULL

##----------------------------------------------------------------------------
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.
##-----------------------------------------------------------------------------
final     <- ddply(combined_data,
                   c("subject","activity"),
                   function(x) 
                   {
                      mn <- numeric()
                      for (f in colnames(X_combined_data))
                      {
                        mn <- c(mn,mean(x[,f]))
                      }
                      mn
                    } )

colnames(final)[3:ncol(final)] <- colnames(X_combined_data)

write.table(final,file=final_file,row.name=FALSE)