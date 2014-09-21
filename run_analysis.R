
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Coded by Angel Tazzer

# Set R working ditectory
library("reshape")
# Place data in the working directory. You can modify the working directory if you are planning to run this code
# in your own computer
setwd("~/Coursera/Johns Hopkins University - Data Science Specialization/Course 3 - Getting and Cleaning Data/Week3/Project")

# ____________________________________________________________________________
#STEP 1 - MERGE THE TRAINING AND TEST SETS TO CREATE A NEW DATASET
# ____________________________________________________________________________

# Read the files that contains the data that will be used to create the dataset

# The dataframe features contains the names of the variables that will be used as headings for the dataset
features <- read.table("features.txt", , stringsAsFactors=FALSE)
str(features)
dim(features)


# The dataframe subject_test contains the identifier of the person who run the test
subject_test <- read.table("subject_test.txt", stringsAsFactors=FALSE)
#str(subject_test)
dim(subject_test)

# The dataframe y_test contains the identifier of the ACTIVITIES of the train
y_test <- read.table("y_test.txt", stringsAsFactors=FALSE)
dim(y_test)

# The dataframe X_test contains the testing observations
X_test <- read.table("X_test.txt", stringsAsFactors=FALSE)
str(X_test)
dim(X_test)

# The dataframe testing_dataset contains the testing observations with the identifier of the person who run the test
testing_dataset<- cbind(X_test, subject_test, y_test)

# The dataframe subject_train contains the identifier of the person who run the tests 
subject_train <- read.table("subject_train.txt", stringsAsFactors=FALSE)
dim(subject_train)

# The dataframe y_train contains the identifier of the ACTIVITIES of the train
y_train <- read.table("y_train.txt", stringsAsFactors=FALSE)
dim(y_train)


# The dataframe X_train contains the testing observations
X_train <- read.table("X_train.txt")
str(X_train)
dim(X_train)

# The dataframe training_dataset contains the training observations with the identifier of the person who run the test
training_dataset<- cbind(X_train, subject_train, y_train)


#The dataframe first_dataset contains complete set of data that will be used to compute the Averages
combined_dataset <- rbind(training_dataset, testing_dataset)


#Add Variable Names to the First Dataset
features <- c(rbind(features, data.frame(V1=562, V2="Subject", stringsAsFactors=FALSE)))
features <- c(rbind(features, data.frame(V1=563, V2="Activity", stringsAsFactors=FALSE)))
colnames(combined_dataset) <- features$V2

write.csv(combined_dataset, file = "Combine_ddataset.csv")

# ____________________________________________________________________________
# STEP 2 - Extracts only the measurements on the mean and standard deviation 
# for each measurement
# ____________________________________________________________________________


# Obtain the number of the columns that needed to be included on the Tidy dataset
meanandstdindexes <- grep("mean\\(\\)|std\\(\\)|Subject|Activity", features$V2)
reduced_dataset <- combined_dataset[, meanandstdindexes]

# write.csv(reduced_dataset, file = "reduced_ddataset.csv")
write.table(reduced_dataset, "reduced_dataset.txt",sep="\t", row.names=FALSE, col.names=TRUE) 
# ____________________________________________________________________________
# STEP 3 - Uses descriptive activity names to name the activities in the data set
# ____________________________________________________________________________

# Read and store the dataframe activity_labels 
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
str(activity_labels)

#Remove "_" from Activity labels and make the activities lowercase
activity_labels[, 2] <- tolower(gsub("_", "", activity_labels[, 2]))
reduced_dataset$Activity <- activity_labels$V2[reduced_dataset$Activity]

# ____________________________________________________________________________
# STEP 4 Appropriately labels the data set with descriptive variable names. 
# ____________________________________________________________________________
original_col_names <- colnames(reduced_dataset)
# make the columns names lowercase
colnames(reduced_dataset) <- original_col_names <- tolower(original_col_names)
colnames(reduced_dataset) <- gsub("\\(\\)", "", colnames(reduced_dataset)) # remove "()"

# ____________________________________________________________________________
#STEP 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject
# ____________________________________________________________________________


tidy_dataset <- aggregate(reduced_dataset,list(activity = reduced_dataset$activity, subject = reduced_dataset$subject),mean)
tidy_dataset <- tidy_dataset[,-c(69,70)]
write.table(tidy_dataset, "tidy_dataset.txt",sep="\t", row.names=FALSE, col.names=TRUE) 
