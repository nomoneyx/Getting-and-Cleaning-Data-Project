###############################################################################
#############################     Import Files    #############################
###############################################################################

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

###############################################################################
#   Uses descriptive activity names to name the activities in the data set    #
###############################################################################

#Define data frame to hold discriptive labels for activity
desc_y_train <- data.frame(V1 = character(7352),  stringsAsFactors=FALSE)
desc_y_test <- data.frame(V1 = character(2947),  stringsAsFactors=FALSE)

#Rename activities with descriptive names.
for(i in 1:6){
    
    desc_y_train[y_train == i,] <- activity_labels[i,2]
    desc_y_test[y_test == i,] <- activity_labels[i,2]
}
rm(i)

#Define and fill data frame to hold discriptive labels for test and train data
desc_test <- data.frame(V1 = character(2947), stringsAsFactors=FALSE)
desc_test[,1] <- "test"

desc_train <- data.frame(V1 = character(7352), stringsAsFactors=FALSE)
desc_train[,1] <- "train"

###############################################################################
######   Merges the training and the test sets to create one data set.   ######
###############################################################################

#Combine test and train data into one data set
train <- cbind(desc_y_train, desc_train, subject_train, X_train)
test <- cbind(desc_y_test, desc_test, subject_test,  X_test)
group <- rbind(train, test)

###############################################################################
###   Appropriately labels the data set with descriptive variable names.   ####
###############################################################################

#Label combined group data set with descriptive variable names
group_colnames <- c("Activity","Data Type","Volunteer",features[,2])
colnames(group) <- group_colnames

###############################################################################
############    Extracts only the measurements on the mean    ################# 
############    and standard deviation for each measurement.  #################
###############################################################################

# searches colmnames for "mean" and "std" and retuns columns numbers
mean_colnames <- grep("mean|std", colnames(group), ignore.case=TRUE)
mean_colnames <- c(1,2,3,mean_colnames)

#define tidy data frame with measure mean and std
tidy_group <- group[,mean_colnames]

###############################################################################
#####    Creates a second, independent tidy data set with the average     #####
#####       of each variable for each activity and each subject.          #####
###############################################################################
i = 1
j = 1
k = 1
tidy_means <- data.frame(matrix(NA, nrow = 180, ncol = 89))
for(i in 1:30){
    
    for(k in 1:6){
    sub_set <- tidy_group[tidy_group$Activity == activity_labels[k,2] 
                                            & tidy_group$Volunteer == i,]
    
    sub_means <- apply(sub_set[4:89], 2, mean)
    
    tidy_means[j,] <- c(sub_set[1,1:3], sub_means)
    
    j = j + 1
    }
}

colnames(tidy_means) <- colnames(tidy_group)

tidy_means[,2] <- NULL

View(tidy_means)

write.table(tidy_means, file = "tidy_means.txt", sep="\t",col.names = TRUE,
            row.names = FALSE)



