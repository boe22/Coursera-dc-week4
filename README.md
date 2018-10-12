# Samsung exercise coursera
This document describes the analysis script of the Samsung exercise of the datascience track on Coursera. 

## run_analysis.R
This file contains the script to read and clean the datafiles of the exercise. 
The file contains two functions:

- ReadCleanData(NameFolder, NameDataSet = "train"), reads either the test or train dataset and cleans the dataset. Further details can be found as comments in the function itself. NameDataSet is either "train" or "test" depending on the dataset to read. NameFolder is the name of the folder containing the test and train folders. 

- ReadDatasets <- function(NameFolder = "UCI HAR Dataset"), calls ReadCleanData() for both the test and train dataset. NameFolder is the name of the folder containing the test and train folders. 

Finally, ReadDatasets() is called in run_analysis.R and the tidy dataset is created. 

## Codebook
Contains the codebook of this project. 