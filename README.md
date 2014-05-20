##How to get a Clean Dataset from HAR raw data

###Please read this document carefully before performing the analysis using the provided R script
###By Michael Chen, email: mikcolchen@hotmail.com

The purpose of this R script(run_analysis.R) is to perform the task of collect, work with, and clean the data set as provided by this project. The goal of it is to prepare tidy data that can be used for later analysis. The source of the data is from a research website of UCI shown as below, the second link indicates the location of the source data.

Research Website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Data Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

From the research website, you may have a quick study on how the Human Activity Recognition research data files were collected. While these data files are raw, to perform data analysis and extract valuable information, the first step is to make the datasets clean and tidy, the rest of this document will explain how this task will be performed using the attached R script "run_analysis.R".


* Download the zip file from the data source link:*

	- Function: GetFile(fileUrl, fName = "har.zip", fileDir = ".")
	
	- fileUrl: The complete file URL, as in this project, it should be:
	          https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	- fName:   Represents the downloaded file name, has default value;
	- fileDir: Represents the path of the unzipped folder, defaults to current working directory;
	

