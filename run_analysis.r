#### Getting and cleaning Data Course Project
library(plyr)
library(dplyr)
library(data.table)
library(tidyr)
## Looking at all the files
path_rf <- file.path("C:/Users/kaelo/Documents/UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
files
###Read data from the targeted files
dataAcTest <- read.table(file.path(path_rf, "test", "Y_test.txt"), header = FALSE)
dataAcTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)

### Read the Subject files
dataSubjTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
dataSubjTest <- read.table(file.path(path_rf, "test", "subject_test.txt"), header = FALSE)

### Read Features files
dataFTest <- read.table(file.path(path_rf, "test", "X_test.txt"), header = FALSE)
dataFTrain <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)

#Looking at the structure of the above variables
str(dataAcTest)
str(dataAcTrain)
str(dataSubjTrain)
str(dataSubjTest)
str(dataFTest)
str(dataFTrain)
### lets merge the the training $ the test data to create one datasets
dataSubj <- rbind(dataSubjTrain, dataSubjTest)
dataAct <- rbind(dataAcTrain, dataAcTest)
dataFT <- rbind(dataFTrain, dataFTest)
# renames the variables
names(dataSubj) <- c("subject")
names(dataAct) <- c("activity")
dataFNames <- read.table(file.path(path_rf, "features.txt"), head = FALSE)
names(dataFT) <- dataFNames$V2

#merge the columns to get an ideal dataframe
dataCmd <- cbind(dataSubj, dataAct)
alldata <- cbind(dataFT, dataCmd)
### Extracts only the measurements on the mean and standard deviation for each measurement
## subset measurement by the features names
mumudataFNames <- dataFNames$V2[grep("mean\\(\\)|std\\(\\)", dataFNames$V2)]
#Subset the data frame Data by seleted names of Features
colnames <- c(as.character(mumudataFNames), "subject", "activity")
alldata <- subset(alldata, select = colnames)
##Check the structures of the data frame 
str(alldata)

## Using the descriptive activity names to name the activities in the datasets
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"), header = FALSE)
# set it into a factor  using  descriptive activity namees 
alldata$activity <- factor(alldata$activity);
alldata$activity <- factor(alldata$activity, labels = as.character(activityLabels$V2))

names(alldata) <- gsub("^t", "time", names(alldata))
names(alldata) <- gsub("^f", "frequency", names(alldata))
names(alldata) <- gsub("Acc", "Accelerometer", names(alldata))
names(alldata) <- gsub("Gyro", "Gyroscope", names(alldata))
names(alldata) <- gsub("Mag", "Magnitude", names(alldata))
names(alldata) <- gsub("BodyBody", "Body", names(alldata))
names(alldata)

alldata2 <- aggregate(. ~ subject + activity, alldata, mean)
alldata2 <- alldata2[order(alldata2$subject, alldata2$activity),]
write.table(alldata2, file = "tidy.txt", row.name = FALSE)