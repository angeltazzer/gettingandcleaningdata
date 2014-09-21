# Codebook
# Author: Angel Tazzer
# Purpose: Coursera Getting and Cleaning Data Assignment

## Purpose and Goals of the Project

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

The data for this project was collected from the following site: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The data collected represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (1= WALKING, 2 = WALKING_UPSTAIRS, 3 = WALKING_DOWNSTAIRS, 4= SITTING, 5= STANDING, 6 = LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record on it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset used in this project includes the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features. ()
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## How this information got processes (run_analysis.R)The script does the following.

The train and test datasets contained a list of 561 numerical variables
The feature dataset contains a list of 563 variable descriptions Type: character

The activity labels contains 2 variables (one numeric and one character)


### 1. Merges the training and the test sets to create one data set

Test Data set   2947 obs with 561 numerical variable
Train Data Set  7352 obs with 561 numerical variables
The program add 2 numerical variables to each of the training and testing datasets
These variables are: the identifier of the person who conduct the test (Subject) and the Activity that was performed (Activity)

The combined dataset produced by the code contained 10299 observations of 563 numerical variables

### 2. Extracts only the measurements on the mean and standard deviation for each measurement
To obtain the number of variables that we will include in the dataset I used the following code:

meanandstdindexes <- grep("mean\\(\\)|std\\(\\)|Subject|Activity", features$V2)
reduced_dataset <- combined_dataset[, meanandstdindexes]

The number of variables on the aggredated_dataset was reduced from 563 to 68 (only columns that contained means and SD were included plus + Subject and Activity)

### 3. Uses descriptive activity names to name the activities in the data set
The variable containing the Activity identifiers were transform from numeric to character and the underscores were removed from the labels and all text was converted to lowercase For example the number 2 was replaced by the label "walkingupstairs"

### 4. Appropriately labels the data set with descriptive variable names.
All column names were converted to lowercase and "()" were removed from the variable names. For example tBodyAcc-mean()-X was converted to tbodyacc-mean-x

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
A tidy dataset was created using the aggregate r function to calculate the verage of each variable for each activity and each subject

tidy_dataset <- aggregate(reduced_dataset,list(activity = reduced_dataset$activity, subject = reduced_dataset$subject),mean)

The tidy dataset only contained 180 observations and 68 variables. The variables are:
Activity (char)
Subject (integer) 
The rest 66 variables are numeric
