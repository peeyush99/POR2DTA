# This R program converts Portable SPSS (.por) format dataset to STATA compatible DTA (.dta) format keeping the column labels preserved.

# Importing required libraries

packagesReq <- c("tidyverse","haven", "memisc", "foreign")

pacman::p_load(packagesReq, character.only = TRUE, install = FALSE)


# Let’s suppose you have .por files in sequence of filename_1, filename_2,
# filename_3, filename_4, filename_5 in "your_import_folder" and you want
# to export  the files in dta format in "your_export_folder"

# The following function converts POR to DTA while preserving column labels

porToDTA <- function(fileSeq) {
  
  # Define your exports and import filepaths
  
  filePathImport <-  “your_import_folder/”                                            
  filePathExport <-  “your_export_folder/“ 
  
  # Import the .por file to R
  
  POR <- as.data.set(spss.portable.file(paste0(filePathImport,"filename_",fileSeq,".por")))
  
  # Convert Imported object to an R dataframe
  
  DF <- as.data.frame(POR)  
  
  # Extract the column labels explicitly from the dataframe
  
  labels <- unlist(description(DF), use.names = FALSE) 
  
  # Add the column labels attribute to the dataframe 
  
  attr(DF,"var.labels") <- labels 
  
  # Write the dataframe to dataset while preserving column labels
  
  write.dta(data = DF, file = paste0(filePathExport,"filename_",fileSeq,".dta"))                      
}

for(fileSeq in seq.int(1,5)) {
  porToDTA(fileSeq)
}

# To check if the column labels are preserved in dta dataset, read the first file

DFAgain <- read_dta("your_export_folder/filename_1.dta")
View(DFAgain)
