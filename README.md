---
output: html_document
---
## ATTENTION!!! copy file "getdata-projectfiles-UCI HAR Dataset.zip" to work directory
```{r}
unzip("getdata-projectfiles-UCI HAR Dataset.zip", exdir = ".")
```
##0.1 Read the test sets
```{r}
features <- read.table("./UCI HAR Dataset/features.txt", header=F, sep=" ")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=F, sep= "")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header=F, sep= "")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=F, sep= "")
names(X_test) <- features$V2
```
### merge X_test, y_test, subject_test
```{r}
test_set <- cbind(X_test, activity = y_test$V1, subj = subject_test$V1 )
```

##0.2 Read the training sets
```{r}
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=F, sep= "")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=F, sep= "")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=F, sep= "")
names(X_train) <- features$V2
```
### merge X_train, y_train, subject_train
```{r}
train_set <- cbind(X_train, activity = y_train$V1, subj = subject_train$V1 )
```
##1 Merges the training and the test sets to create one data set.
```{r}
Union_set <- rbind(test_set, train_set)
```
##2 Extracts only the measurements on the mean and standard deviation for each measurement. 
```{r}
log_mean_or_std <- grepl("mean\\(\\)|std\\(\\)", names(Union_set))
Union_set_mean_std <- cbind(Union_set[,log_mean_or_std], activity_id=Union_set$activity, subj=Union_set$subj)
```
##3 Uses descriptive activity names to name the activities in the data set
```{r}
activity_name <- read.table("./UCI HAR Dataset/activity_labels.txt", header=F, sep= "")
Union_set_mean_std$activity_name <- activity_name[Union_set_mean_std$activity_id,2]
```
##4 Appropriately labels the data set with descriptive variable names. 

###I've already done this task
```{r}
names(Union_set_mean_std)
```
##5 From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.
```{r}
temp <- split(x = Union_set_mean_std[,-69], f = Union_set_mean_std[,68:69])
temp2 <- lapply(temp, function(e) sapply(e, mean))
temp2 <- as.data.frame(t(as.data.frame(temp2)))
temp2$activity_name <- activity_name[temp2$activity_id,2]
row.names(temp2) <- seq(along=row.names(temp2))
names(temp2)[1:66] <- paste0(names(temp2)[1:66],"_aver_by_subj_activ")
output <- temp2
```
