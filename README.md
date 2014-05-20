##How to get a Clean Dataset from HAR raw data

###Please read this document carefully before performing the analysis using the provided R script
###By Michael Chen, email: mikcolchen@hotmail.com

The purpose of this R script(run_analysis.R) is to perform the task of collect, work with, and clean the data set as provided by this project. The goal of it is to prepare tidy data that can be used for later analysis. The source of the data is from a research website of UCI shown as below, the second link indicates the location of the source data.

Research Website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Data Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

From the research website, you may have a quick study on how the Human Activity Recognition research data files were collected. While these data files are raw, to perform data analysis and extract valuable information, the first step is to make the datasets clean and tidy, the rest of this document will explain how this task will be performed using the attached R script "run_analysis.R".


* Download the zip file from the data source link:

	- Function: GetFile(fileUrl, fName = "har.zip", fileDir = ".")
	
	  * fileUrl: The complete file URL, as in this project, it should be:
	             https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	  * fName:   Represents the downloaded file name, has default value;
	  * fileDir: Represents the path of the unzipped folder, defaults to current working directory;
	
* Collect, combine and clean the data:
	
	- Function: RunAnalysis(dataFolder = "./UCI HAR Dataset")

	  * dataFolder: Indicates the path and folder in which all the data files are saved. Has default value;
	  * This function will automatically perform the following steps sequently, and eventually generate a tidy data set of average values for each measured feature by each activity and each subject:

	   1. Merges the training and the test sets to create one data set.
		- Function: CombTrainTest(trainFold, testFold)
		
		  * trainFold: The folder and its path which contains all training data files;
		  * testFold:  The folder and its path which contains all test data files;
		  * This function will in the first place sequently combine y_train data, subject_train data and X_train data by columns as training data set, combine y_test data, subject_test data and X_test data by columns as test data set. Then combine training data and test data by rows as a complete data set;

	   2. Extracts only the measurements on the mean and standard deviation for each measurement.
		- Function: ExMeanStd(dataSet, featureFile)

		  * dataSet:     The complete combined data set, generated from step 1;
		  * featureFile: The path of the file which contains complete list of measured features as named as features.txt originally;
		  * To filter out the mean and standard deviation measurements together with activity label and subject, the function scans the vector of feature meansurements (features.txt), find out the indices of the elements of which the values contain either "mean" or "std", then by using those indices it can figure out the indices of the columns which represent the mean and STD measuments of the complete data set, subsequently, a subset of the complete combined data set which only contains mean and STD measurements can be extracted. In the end, this function calls function AddColNames to add decriptive variable names to the extracted sub data set, function AddColNames will be introduced later;

	   3. Uses descriptive activity names to name the activities in the data set.
		- Function: NameActi(dataSet, labelFile)

      		  * dataSet:   The extracted data set which only contains activity lable, subject and mean or STD measured features, generated from step 2;
		  * labelFile: The path of activity definition file as named as activity_labels.txt originally;
		  * Function reads activity_labels.txt to a data set, then merges the mean/STD data set with this activity definition data set by the key column "label", afterward it moves the activity names column to the first column position and in the mean time drop column lable, as a result the label column was replaced by descriptive activity names column;

	   4. Appropriately labels the data set with descriptive variable names.





