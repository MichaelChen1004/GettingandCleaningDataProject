
GetFile <- function(fileUrl, fName = "har.zip", fileDir = ".") {
    # Provide a link to the file and the location where you want to put
    # the file,then this function will get it ready for analysis.
    # fName: A new name (include file extension) given to the 
    # downloaded file
    #
    if (!file.exists(fileDir)) {dir.create(fileDir)}  
    # check if data folder exists, if not, create one automatically.
    destFileValue <- paste0(fileDir, "/", fName)
    if(!file.exists(destFileValue)){
        download.file(fileUrl, destfile = destFileValue)
        
        # Unzip the file if zipped.
        fileExt <- substr(fName, nchar(fName)-3+1, nchar(fName)) 
        # Get the file extension.
        if (fileExt == "zip") {
            unzip(destFileValue, exdir = fileDir)
            file.remove(destFileValue)
        }
    }else{
        stop("The file to be downloaded already exists!")
    }
    
}   

RunAnalysis <- function(dataFolder = "./UCI HAR Dataset") {
    # dataFolder: A path which points to the folder which contains 
    # all the data files and related subfolders.
    #
    # Combine the train and test data and create a tidy data set by
    # following below steps:
    # 1.Merges the training and the test sets to create one data set.
    # 2.Extracts only the measurements on the mean and standard 
    # deviation for each measurement.
    # 3.Uses descriptive activity names to name the activities in 
    # the data set.
    # 4.Appropriately labels the data set with descriptive variable 
    # names.
    # 5.Create new tidy data set with the average of each variable 
    # for each activity and each subject.
    if (!file.exists(dataFolder)) {
        stop("Folder does not exist!")
    }
    trainF <- paste0(dataFolder, "/train") # train folder
    testF <- paste0(dataFolder, "/test") # test folder
    feaFile <- paste0(dataFolder, "/features.txt")
    labelFile <- paste0(dataFolder, "/activity_labels.txt")
    compSet <- CombTrainTest(trainF, testF)
    # 1.Merges the training and the test sets to create one data 
    # set.
    meanStdSubSet <- ExMeanStd(compSet, feaFile)
    # 2.Extracts only the measurements on the mean and standard 
    # deviation for each measurement.
    # 4.Appropriately labels the data set with descriptive variable 
    # names.
    detailTidySet <- NameActi(meanStdSubSet, labelFile)
    # 3.Uses descriptive activity names to name the activities in 
    # the data set.
    expDest <- paste0(dataFolder, "/AvgTidaySet.txt")
    meanTidySet <- GetAvgSet(detailTidySet, expDest)
}

GetAvgSet <- function(dataSet, 
                      expDest = 
                          "./UCI HAR Dataset/AvgTidySet.txt") {
    # 5.Create new tidy data set with the average of each variable 
    # for each activity and each subject. 
    # 
    # expDest: Indicate the path of the exported data file, must be
    # .txt file extension.
    #
    library(plyr)
    if (!file.exists(dirname(expDest))) {
        stop("Folder for exported data doesn't exist!")
    }
    avgSet <- ddply(dataSet, .(acti.name, subject), 
                    function(x) colMeans(x[, -c(1:2)]))
    colnames(avgSet)[-c(1:2)] <- paste0("avg.", 
                                        colnames(avgSet)[-c(1:2)])
    write.table(avgSet, expDest, sep = "\t", row.names = F)
    return(avgSet)
}

CombTrainTest <- function(trainFold, testFold) {
    # Merges the training and the test sets to create one data set.
    #
    # trainFold: The path of training data folder; 
    # testFold: The path of test data folder; 
    #
    xTrain <- paste0(trainFold, "/X_train.txt")
    yTrain <- paste0(trainFold, "/y_train.txt")
    subjTrain <- paste0(trainFold, "/subject_train.txt")
    xTest <- paste0(testFold, "/X_test.txt")
    yTest <- paste0(testFold, "/y_test.txt")
    subjTest <- paste0(testFold, "/subject_test.txt")
    # Get all the files with their full paths.
    xTrainData <- read.table(xTrain, nrow = 8000)
    yTrainData <- read.table(yTrain)
    subjTrainData <- read.table(subjTrain)
    trainSet <- cbind(subjTrainData, yTrainData, xTrainData)
    # Combine them together as complete training set by columns
    xTestData <- read.table(xTest, nrow = 4000)
    yTestData <- read.table(yTest)
    subjTestData <- read.table(subjTest)
    testSet <- cbind(subjTestData, yTestData, xTestData)
    # combine them together as complete test set by columns
    wholeSet <- rbind(trainSet, testSet)
    colnames(wholeSet)[1:2] <- c("subject", "label")
    # Add column names to the first two columns which represent
    # subjects and label codes.
    return(wholeSet)
}

ExMeanStd <- function(dataSet, featureFile) {
    # Extracts only the measurements on the mean and standard 
    # deviation for each measurement.
    #
    # dataSet: The complete observation dataset
    # featureFile: The name of the features file together with its
    # path.
    fSet <- read.table(featureFile, quote = "")
    colInd <- grep("mean|std", fSet[,2])
    # get the column indexes of which the names contain "mean" or 
    # "STD"
    exFNameSet <- fSet[colInd, 2]
    colInd <- colInd + 2
    compColInd <- c(1:2, colInd)
    # add the first two columns' indexes.
    subSet <- dataSet[, compColInd]
    subSet <- AddColNames(subSet, exFNameSet)
    # Add descriptive names to the feature valculation variables.
}

NameActi <- function(dataSet, labelFile) {
    # Uses descriptive activity names to name the activities in 
    # the data set
    # 
    # labelFile: The label description file with its path.
    #
    lData <- read.table(labelFile, quote = "")
    names(lData) <- c("label", "acti.name")
    # name each column
    dataSet <- merge(dataSet, lData, by = "label")
    dataSet <- dataSet[,names(dataSet)[c(1,82,2,3:81)]]
    # put the l.desc column to position 2.
    dataSet[,"label"] = NULL
    # remove label column.
    return(dataSet)
}

AddColNames <- function(dataSet, vNameSet) {
    # Appropriately labels the data set with descriptive variable 
    # names. 
    vNSetF <- gsub("-|\\(\\)(-*)", "\\.", vNameSet)
    vNSetF <- sub("[\\.]$", "", vNSetF)
    # Replace "-" and "()-" within the names with "."
    vNSetF <- tolower(vNSetF)
    colnames(dataSet)[c(-1,-2)] <- vNSetF
    # Name the variables of dataSet using the formated name set.
    return(dataSet)
}






