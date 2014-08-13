R program run_analysis.R scripts and explanations 
=================================================
R program run_analysis.R produces the data frame tidy_means.  Data contained within tidy_means was produced from experiments
carried out by 30 volunteers wearing Samsung Galaxy S II smartphones.  Each smartphone recorded 3-axial linear acceleration 
and 3-axial angular velocity using an embedded accelerometer and gyroscope.   Below is the name and a description of the files 
produced from the experiments and how they were used to produce the tidy_means data frame.

Original files:
===============
- 'features.txt': Discriptive list of all features variables which represent data collected from the Samsung accelerometer and gyroscope
- 'activity_labels.txt': Links the class labels with their activity name, WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
- 'train/X_train.txt': Numeric values recorded by the Samsung smartphones in the training group.
- 'train/y_train.txt': Training labels. Intergers representing volunteers participating in the experiments from the training group.
- 'test/X_test.txt': Numeric values recorded by the Samsung smartphones in the test group.
- 'test/y_test.txt': Test labels. Intergers representing volunteers participating in the experiments from the test group.

Transformations used to produce tidy_means:
===========================================
- Above files were imported into R v3.1.1 using rStudio.
- 'test/y_test.txt' and train/y_train.txt along with 'activity_labels.txt' were used to construct vectors that contained descriptive variable names 
   for the activities preformed in the experiments.
-  'test/X_test.txt','test/y_test.txt', and vectors containing descriptions of activities preformed where combined horizontally to form a data frame.
-  'test/X_train.txt','test/y_train.txt', and vectors containing descriptions of activities preformed where combined horizontally to form a data frame.
-  Both of the data frames produced in the two previous lines were joined vertically to produce a data frame containing both test and training data.
-  Column names were produced using 'features.txt' and other descriptive variable names and were added to the combined data frame
-  A nested for loop was used to calculate the column means of the combined data frame and populate the tidy_means data frame with the results.




Import Files.    
=============
```
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE,
                              strip.white = TRUE)

features <- read.table("features.txt", stringsAsFactors=FALSE, 
                       strip.white = TRUE)

subject_train <- read.table("train/subject_train.txt", stringsAsFactors=FALSE, 
                            strip.white = TRUE)

X_train <- read.table("train/X_train.txt", stringsAsFactors=FALSE, 
                      strip.white = TRUE)

y_train <- read.table("train/y_train.txt", stringsAsFactors=FALSE, 
                      strip.white = TRUE)

subject_test <- read.table("test/subject_test.txt", stringsAsFactors=FALSE, 
                           strip.white = TRUE)

X_test <- read.table("test/X_test.txt", stringsAsFactors=FALSE, 
                     strip.white = TRUE)

y_test <- read.table("test/y_test.txt", stringsAsFactors=FALSE, 
                     strip.white = TRUE)
```

Uses descriptive activity names to name the activities in the data set.    
=======================================================================
Define data frame to hold descriptive labels for activity preformed in experiments.
Both of these data frames will be used as the first column in the intermediate data frames
train and test.
```
desc_y_train <- data.frame(V1 = character(7352),  stringsAsFactors=FALSE)
desc_y_test <- data.frame(V1 = character(2947),  stringsAsFactors=FALSE)
```
Rename activities with descriptive names. For loop populates desc_y_train and desc_y_test
using the labels contained in the activity_labels data frame.
```
for(i in 1:6){
    
    desc_y_train[y_train == i,] <- activity_labels[i,2]
    desc_y_test[y_test == i,] <- activity_labels[i,2]
}
rm(i)
```
Define and fill data frame to hold discriptive labels for test and train data.
```
desc_test <- data.frame(V1 = character(2947), stringsAsFactors=FALSE)
desc_test[,1] <- "test"

desc_train <- data.frame(V1 = character(7352), stringsAsFactors=FALSE)
desc_train[,1] <- "train"
```

Merges the training and the test sets to create one data set.   
==============================================================

Combine test and train data into one data set.  Train and test data are combined vertically 
with their respective data and then are combined vertically to form the complete data frame group.
```
train <- cbind(desc_y_train, desc_train, subject_train, X_train)
test <- cbind(desc_y_test, desc_test, subject_test,  X_test)
group <- rbind(train, test)
```

Appropriately labels the data set with descriptive variable names.   
==================================================================

Label combined group data set with descriptive variable names.  Labels are taken from the features data frame
and combined along with "Activity", "Data Type", "Volunteer" and inserted into the column names.
```
group_colnames <- c("Activity","Data Type","Volunteer",features[,2])
colnames(group) <- group_colnames
```

Extracts only the measurements on the mean and standard deviation for each measurement.  
=======================================================================================

Grep() searches column names for "mean" and "std" and retuns columns numbers that contain either.
```
mean_colnames <- grep("mean|std", colnames(group), ignore.case=TRUE)
mean_colnames <- c(1,2,3,mean_colnames)
```
Defines tidy_group data frame with measures mean and std contained in the colum names.
```
tidy_group <- group[,mean_colnames]
```

Creates a second, independent tidy data set with the average of each variable for each activity and each subject.          
=================================================================================================================

```
i = 1
j = 1
k = 1
```
Defines tidy_means to contain means of the tidy_group data.
```
tidy_means <- data.frame(matrix(NA, nrow = 180, ncol = 89))
```
For loop separates data by activities and volunteers takes the means of the columns and 
and inserts this data into the data frame tidy_means.
```
for(i in 1:30){
    
    for(k in 1:6){
    sub_set <- tidy_group[tidy_group$Activity == activity_labels[k,2] 
                                            & tidy_group$Volunteer == i,]
    
    sub_means <- apply(sub_set[4:89], 2, mean)
    
    tidy_means[j,] <- c(sub_set[1,1:3], sub_means)
    
    j = j + 1
    }
}
```
Adds column names to the data frame tidy_means.
```
colnames(tidy_means) <- colnames(tidy_group)
```
Removes column two.
```
tidy_means[,2] <- NULL
```
Prints tidy_means in viewer.
```
View(tidy_means)
```
Writes text file of tidy_means data frame to the working directory.
```
write.table(tidy_means, file = "tidy_means.txt", sep="\t",col.names = TRUE,
            row.names = FALSE)
```





