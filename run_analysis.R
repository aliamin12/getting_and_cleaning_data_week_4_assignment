library(dplyr)

#Reading in the training files 
setwd("/Users/aliamin/Desktop/R/C-Assignment/Getting and cleaning data/Week 4 assignment/UCI HAR Dataset/train/")

dataSubjectTrain <- read.table("subject_train.txt", header = FALSE)
dataActivityTrain <- read.table("y_train.txt", header = FALSE)
dataFeatureTrain <- read.table("X_train.txt", header = FALSE)


#Reading in the test files
setwd("/Users/aliamin/Desktop/R/C-Assignment/Getting and cleaning data/Week 4 assignment/UCI HAR Dataset/test/")

dataSubjectTest <- read.table("subject_test.txt", header = FALSE)
dataActivityTest <- read.table("y_test.txt", header = FALSE)
dataFeatureTest <- read.table("X_test.txt", header = FALSE)

#merging vector by vector data
dataSubject <- rbind(dataSubjectTest,dataSubjectTrain)
dataActivity <- rbind(dataActivityTest,dataActivityTrain)
dataFeature <- rbind(dataFeatureTest,dataFeatureTrain)

#adding names 
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
setwd("/Users/aliamin/Desktop/R/C-Assignment/Getting and cleaning data/Week 4 assignment/UCI HAR Dataset/")
featurenames <- read.table("features.txt",header = FALSE)
names(dataFeature) <- featurenames$V2

#merge into one data set
all_data <- cbind(dataSubject,dataActivity,dataFeature)

#extracting mean and std only 
x <- grep("mean\\(\\)|std\\(\\)",colnames(all_data),value = TRUE)
nameswanted <- c("subject","activity",x)
extrData <- subset(all_data,select = nameswanted)

#naming the activity label using stringi package
library(stringi)
pattern <- c(as.character(1:6))
labels <- read.table("activity_labels.txt",header = FALSE)
labels_rep <- as.character(labels$V2)
extrData$activity <- stri_replace_all_regex(extrData$activity,
                                            pattern = pattern,
                                            replacement = labels_rep,
                                            vectorize_all = FALSE)


extrData$activity <-  as.factor(extrData$activity)

#labeling variables with descriptive names 
names(extrData) <- gsub("^t","time",names(extrData))
names(extrData) <- gsub("^f","frequency",names(extrData))
names(extrData) <- gsub("Acc","Acceleration",names(extrData))
names(extrData) <- gsub("BodyBody","Body",names(extrData))
names(extrData) <- gsub("Mag","Magnitude",names(extrData))
names(extrData) <- gsub("Gyro","Gyroscope",names(extrData))


#average of each variable for each activity and each subject
library(plyr)

extrData2 <- aggregate(.~subject+activity,data = extrData,FUN = mean)
extrData2 <- extrData2[order(extrData2$subject,extrData2$activity),]

write.table(extrData2, file="wearable_tidy_dataset", row.names = FALSE)

library(knitr)
knit2html("datacodebook.Rmd")






