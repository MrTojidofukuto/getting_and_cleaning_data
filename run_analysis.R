## Set working directory
setwd("C:/Users/Leo Van Chu Nguyen/Desktop/Data Science Specialization/Course 3 - Getting and Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#Step 1. Merge the training and test dataset to create on data set
## Reading training data set
train <- read.table("./train/X_train.txt")

trainLabel <- read.table("./train/y_train.txt", col.names = "label")

trainSubject <- read.table("./train/subject_train.txt", col.names = "subject")

## Reading test data set
test <- read.table("./test/X_test.txt")

testLabel <- read.table("./test/y_test.txt", col.names = "label")

testSubject <- read.table("./test/subject_test.txt", col.names = "subject")

## Joining the two data sets
data <- rbind(cbind(trainSubject, trainLabel, train),
              cbind(testSubject, testLabel, test))

#Step 2. Extract only the measurements on the mean and standard deviation for
#each measurement
## Reading features
features <- read.table("./features.txt",strip.white = TRUE, 
                       stringsAsFactors = FALSE)

## Retain mean and standard deviation 
features_mean_stdev <- features[grep("mean\\(\\)|std\\(\\)", features$V2),]

## Select only the means and standard deviation from data
data_mean_stdev <- data[,c(1,2,features_mean_stdev$V1 + 2)]

#Step 3. Use descriptive activity to name the activities in the data set
## Reading activities label
activitiesLabel <- read.table("./activity_labels.txt", stringsAsFactors = FALSE)

## Replace labels in data with label names
data_mean_stdev$label <- activitiesLabel[data_mean_stdev$label, 2]

#Step 4. Appropriately labels the data set with descriptive variable names
## Make a list of the current column names and feature names
list.colnames <- c("subject", "label", features_mean_stdev$V2)

## Removing every non-alphabetic character and converting to lowercase
list.colnames <- tolower(gsub("[^[:alpha:]]", "", list.colnames))

## Use the list of column names for data
colnames(data_mean_stdev) <- list.colnames

#Step 5. Create a second, independent tidy data set with the average of each 
#variable for each activity and each subject

# Find the mean for each combination of subject and label
aggregateData <- aggregate(data_mean_stdev[, 3:ncol(data_mean_stdev)],
                           by=list(subject = data_mean_stdev$subject, 
                                   label = data_mean_stdev$label),mean)

## Write the data into file
write.table(format(aggregateData, scientific = TRUE), "tidyData.txt",
            row.names = FALSE, quote = 2)