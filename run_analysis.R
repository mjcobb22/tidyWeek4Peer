if(!file.exists("./wk4")){dir.create("./wk4")}

##locate file and unzip into data
## fileloc[1]: 0 if online, 1 if local file
fileloc<-c(0,"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip")

if(fileloc[1]==0){download.file(fileloc[2],destfile = "./wk4/Data.zip")}
  unzip(zipfile="./wk4/Data.zip",exdir="./wk4")

if(fileloc[1]==1){unzip(zipfile=fileloc[2],exdir="./wk4")}

#read in data from fileloc
x_train <- read.table("./wk4/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./wk4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./wk4/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./wk4/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./wk4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./wk4/UCI HAR Dataset/test/subject_test.txt")

features<-read.table('./wk4/UCI HAR Dataset/features.txt')

activities<-read.table('./wk4/UCI HAR Dataset/activity_labels.txt')

#assign features to colnames
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(subject_train)<-"subjectId"
colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_test)<-"subjectId"
colnames(activities)<-c('activityId','activityType')

##bind data into single table 
bnd_train<-cbind(y_train,subject_train,x_train)
bnd_test<-cbind(y_test,subject_test,x_test)
allForOne<-rbind(bnd_train,bnd_test)
colNames<-colnames(allForOne)

#search and filter for mean and std
mean_std_grep<-(grepl("activityId",colNames)|
                grepl("subjectId",colNames)|
                grepl("mean",colNames)|
                grepl("std",colNames)
                )

mean_std <- allForOne[ , mean_std_grep == TRUE]

activitynames<-merge(mean_std, activities, by = "activityId", all.x=TRUE)

#aggregate tidysecondary and write to txt
tidysecondary<-aggregate(activitynames$subjectId + activitynames$activityId, activitynames, mean)
tidysecondary<-tidysecondary[order(tidysecondary$subjectId, tidysecondary$activityId),]

write.table(tidysecondary,"tidysecondary.txt",row.names = FALSE)




