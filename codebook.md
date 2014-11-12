Was code book submitted to GitHub that modifies and updates the codebooks available to you with the data to indicate all the variables and summaries you calculated,
along with units, and any other relevant information?

Downlaod data from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Use the following files:
-'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

Need to have the following library installed to run the code:
library("dplyr")
library("sqldf")
library("reshape2")

Code Steps:
1. read in datasets
2. Making column headers for the xTest & xTrain datasets
3. Extract only mean and std
4. Replace # with activity name by mapping to activity_labels (labels)
5. binding two tables where labels.V1 = yTrain.activity
6. Keep only activity description for the y datasets
7. Making column header for the yTrain & yTest datasets
8. Making column header for the subject datasets
9. Append yTrain to xTrain & yTest to xTest
10. Append Subject to the datasets
11. Append trainingSet & testingSet
12. modify dataset so it has columns subject, activity, variable, value
13. for each combination of subject and activity, get mean of every variable. 
14. output file as tidy_data.txt
