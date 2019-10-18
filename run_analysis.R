library(dplyr)

if(!file.exists("./data")){dir.create("./data")}

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile="./data/Coursera_Final.zip") #backup

download.file(fileUrl, destfile="./Coursera_Final.zip")  #working directory

unzip("Coursera_Final.zip") 

#Assigning all data frames

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merge data

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# selects from merge data only columns subject code and anything with mean and std in name

Q2<- select(Merged_Data,subject, code, contains("mean"), contains("std"))

# Uses descriptive activity names  in the data set from activities file.

Q2$code<- activities[Q2$code, 2]

#fix label names

names(Q2)[2] = "activity"
names(Q2)<-gsub("Acc", "Accelerometer", names(Q2))
names(Q2)<-gsub("Gyro", "Gyroscope", names(Q2))
names(Q2)<-gsub("BodyBody", "Body", names(Q2))
names(Q2)<-gsub("Mag", "Magnitude", names(Q2))
names(Q2)<-gsub("^t", "Time", names(Q2))
names(Q2)<-gsub("^f", "Frequency", names(Q2))
names(Q2)<-gsub("tBody", "TimeBody", names(Q2))
names(Q2)<-gsub("-mean()", "Mean", names(Q2), ignore.case = TRUE)
names(Q2)<-gsub("-std()", "STD", names(Q2), ignore.case = TRUE)
names(Q2)<-gsub("-freq()", "Frequency", names(Q2), ignore.case = TRUE)
names(Q2)<-gsub("angle", "Angle", names(Q2))
names(Q2)<-gsub("gravity", "Gravity", names(Q2))


View(Q2)

data set with the average of each variable for each activity and each subject.

Q5 <- Q2 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

View(Q5)

write.table(Q5, "Q5.txt", row.name=FALSE)