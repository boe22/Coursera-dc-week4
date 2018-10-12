library(dplyr)

ReadCleanData <- function(NameFolder, NameDataSet = "train"){
  # NameFolder: name of folder where datasets are located
  # NameDataSet: train or test
  
  if(!(NameDataSet %in% c("train","test"))){
    stop("NameDataSet must be either train or test to be vallid. ")
  }
  
  # Read the activity labels
  ActivityLabels <- read.table(file = file.path(NameFolder, "activity_labels.txt"), col.names = c("ActivityNumber","ActivityLabel"), colClasses = c("numeric","character"))
  
  # Read the feature labels
  FeatureLabels <- read.table(file = file.path(NameFolder, "features.txt"), col.names = c("FeatureNumber","FeatureLabel"), colClasses = c("numeric","character"))
  
  # Clean the feature labels from (), as they are invallid in columnnames
  FeatureLabels[,"FeatureLabel"] <- gsub("\\(\\)","",FeatureLabels[,"FeatureLabel"])
  
  # Read subject numbers
  Subjects <- read.table(file.path(NameFolder, NameDataSet, paste0("subject_",NameDataSet,".txt")), col.names = "SubjectNumber", colClasses = "numeric")
  
  # Read activities of data
  ActivitiesData <- read.table(file.path(NameFolder, NameDataSet, paste0("y_",NameDataSet,".txt")), col.names = "ActivityNumber", colClasses = "numeric")
  
  # Merge activity labels with activities
  Data <- merge(ActivitiesData, ActivityLabels,by="ActivityNumber") %>% select(ActivityLabel)
  
  # Merge activities with subjects
  Data <- cbind(Subjects, Data)
  
  # Read measurement data
  Measurements <- read.table(file.path(NameFolder, NameDataSet, paste0("X_",NameDataSet,".txt")), col.names = FeatureLabels[,"FeatureLabel"])
  
  # Select the columns corresponding to mean and std measurements
  Measurements <- Measurements[,colnames(Measurements)[grepl("(mean|std)(-X|-Y|-Z){0,}$", colnames(Measurements))]]
  
  # Combine activities with measurements
  Data <- cbind(Data, Measurements)
  
  # Make columnames tidy
  colnames(Data) <- gsub(".mean","Mean",colnames(Data))
  colnames(Data) <- gsub(".std","Std",colnames(Data))
  
  # Return dataset
  Data
}



# The following function reads and cleans both datasets

ReadDatasets <- function(NameFolder = "UCI HAR Dataset"){
  if(!file.exists(NameFolder)){
    stop("NameFolder does not exist. ")
  }
  
  Data <- ReadCleanData(NameFolder=NameFolder, NameDataSet = "train")
  Data <- rbind(Data,ReadCleanData(NameFolder=NameFolder, NameDataSet = "test"))
}

# Call function to read and clean dataset
Data <- ReadDatasets(NameFolder = "UCI HAR Dataset")

# Create tidy dataset
Data %>% group_by(ActivityLabel, SubjectNumber) %>% summarise_all(funs(mean)) -> DataTidy

# Save dataset
write.table(Data, file="TidyDataset.txt", row.name=FALSE)
