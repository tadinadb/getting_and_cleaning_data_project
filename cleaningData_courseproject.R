##read the test data set
x_test=read.table("UCI HAR Dataset/test/X_test.txt")
y_test=read.table("UCI HAR Dataset/test/y_test.txt")
sub_test=read.table("UCI HAR Dataset/test/subject_test.txt")
#combine the data into 1 table
test_data<-cbind(x_test,y_test,sub_test)
#read the training data set
y_train=read.table("UCI HAR Dataset/train/y_train.txt")
x_train=read.table("UCI HAR Dataset/train/X_train.txt")
sub_train=read.table("UCI HAR Dataset/train/subject_train.txt")
#combine the data into 1 table
train_data<-cbind(x_train,y_train,sub_train)
#combine the training and test data (first task complete)
all_Data<-rbind(test_data, train_data)

#to filter the combined data set to only have the mean and std dev values of the measurements
#read the column names from the features txt file
fileInput<-readLines("UCI HAR Dataset/features.txt")
#create the expression to match the fields we need 
toMatch<-c("mean()","std()")
#get the column numbers of the columns to filter on and extract it from the combined data
filtered_data<-all_Data[c(grep(paste(toMatch,collapse="|"),fileInput))]
#add back the activity and subject columns (second task complete)
filtered_data<-cbind(filtered_data, all_Data[c(562:563)])

#get the variable names from the features file
varnames<-strsplit(fileInput[grep(paste(toMatch,collapse="|"),fileInput)]," ")
varnames<-sapply(varnames,function(x){x[2]})
#add the names for the last 2 columns of activity and subject
varnames[length(varnames)+1]<-"activity"
varnames[length(varnames)+1]<-"subject"
#assign the names to the filtered_data set columns (fourth task completed)
colnames(filtered_data)<-varnames

#assign a name to the activity (third task completed)
filtered_data$activity[filtered_data$activity==1]<-"WALKING"
filtered_data$activity[filtered_data$activity==2]<-"WALKING_UPSTAIRS"
filtered_data$activity[filtered_data$activity==3]<-"WALKING_DOWNSTAIRS"
filtered_data$activity[filtered_data$activity==4]<-"SITTING"
filtered_data$activity[filtered_data$activity==5]<-"STANDING"
filtered_data$activity[filtered_data$activity==6]<-"LAYING"
#the above might have been better done by reading the file

#creating the tidy data set by filtering data for each subject for each activity
#then gathering the mean of the variables for that subset of measurements
k<-1
#for each subject
for(i in unique(filtered_data$subject)){
  #for each activity
   for(j in unique(filtered_data$activity)){
     filtered_subject<-filtered_data[filtered_data$subject==i, ]
     filtered_subjectactivity<-filtered_subject[filtered_subject$activity==j, ]
     #get the mean for the activity and subject once we have the subset of data we need
     a<-colMeans(filtered_subjectactivity[, 1:(length(colnames(filtered_subjectactivity))-2)])
     a<-t(a)
     a[length(a)+1]<-j
     a[length(a)+1]<-i
     if(k==1){
       tidy_data<-a
     }
     else{
       tidy_data<-rbind(tidy_data,a)
     }
     
     k<-k+1
   }
}

#now that we have the data just add the updated column names
colnamestd<-sapply(colnames(filtered_data),function(name){paste0("mean_",name)})
colnamestd[(length(colnamestd)-1)]<-"activity"
colnamestd[length(colnamestd)]<-"subject"
colnames(tidy_data)<-colnamestd

#save the data to a file
write.table(tidy_data,file="UCI HAR Dataset/tidy_data.txt",row.names = FALSE)
