#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
#- 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.
#- 'train/y_train.txt': Training labels.
#- 'test/X_test.txt': Test set.
#- 'test/y_test.txt': Test labels.

#setwd("~/R Class/Getting and Cleaning Data/Project")
library("dplyr")
library("sqldf")
library("reshape2")


# download data

#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
#unzip("Dataset.zip")

# read in the datasets

xTest <- read.table("test/X_test.txt")
xTrain <- read.table("train/X_train.txt")
yTest <- read.table("test/y_test.txt")
yTrain <- read.table("train/y_train.txt")
subTest <- read.table("test/subject_test.txt")
subTrain <- read.table("train/subject_train.txt")
features <-  read.table("features.txt")
labels <- read.table("activity_labels.txt")


# Making column headers for the xTest & xTrain datasets
colnames(xTest) <- features[,2]
colnames(xTrain) <- features[,2]

# Extract only mean and std
extract_features <- grepl("mean|std", features[,2])
xTest = xTest[,extract_features]
xTrain = xTrain[,extract_features]

# Replace # with activity name by mapping to activity_labels (labels)
# binding two tables where labels.V1 = yTrain.activity
yTrain=as.data.frame(merge(labels,yTrain,by.x="V1",by.y="V1"))
yTest=as.data.frame(merge(labels,yTest,by.x="V1",by.y="V1"))
yTrain$V2 = as.data.frame(as.factor(yTrain$V2))
yTest$V2 = as.data.frame(as.factor(yTest$V2))

# Keep only activity description for the y datasets
yTrain <- yTrain[,2]
yTest <- yTest[,2]

# Making column header for the yTrain & yTest datasets
colnames(yTrain) <- "activity" 
colnames(yTest) <-  "activity"

# Making column header for the subject datasets
colnames(subTest) <- "subject"
colnames(subTrain) <- "subject"

# Append yTrain to xTrain & yTest to xTest
trainingSet <- cbind(yTrain, xTrain)
testingSet <-  cbind(yTest, xTest)

# Append Subject to the datasets
trainingSet <- cbind(subTrain, trainingSet)
testingSet <-  cbind(subTest, testingSet )

# Append trainingSet & testingSet
bothset <- rbind(trainingSet, testingSet)

# to get columns subject, activity, variable, value
id_columns   = c("subject", "activity")
other_columns = setdiff(colnames(bothset), id_columns)

dataset = melt(bothset, id = id_columns, measure.vars = other_columns)

# for each combination of subject and activity, get mean of every variable. 
dataset = dcast(dataset, subject + activity ~ variable, mean)

# sort to check
tidy_data = arrange(dataset, activity, subject)

# save file
write.table(tidy_data, file = "./tidy_data.txt",  row.name=FALSE)
