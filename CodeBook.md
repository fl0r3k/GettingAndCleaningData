# Code Book - run_analysis.R
## Data transformation
For more informatin refer to `README.txt` that comes with original data.

1. Loading all required data to workspace. That includes training and test measurements data, data sets with person and performed activity identifiers. `features` contains names of the measurements. It will be used to apply appropriate names to columns.

    ```
    subject.train <- read.table(paste(train.path,"subject_train.txt", sep = "/"), header = F)
    X.train <- read.table(paste(train.path,"X_train.txt", sep = "/"), header = F)
    y.train <- read.table(paste(train.path,"y_train.txt", sep = "/"), header = F)
    
    subject.test <- read.table(paste(test.path,"subject_test.txt", sep = "/"), header = F)
    X.test <- read.table(paste(test.path,"X_test.txt", sep = "/"), header = F)
    y.test <- read.table(paste(test.path,"y_test.txt", sep = "/"), header = F)
    
    features <- read.table(paste(main.path,"features.txt", sep = "/"), header = F)
    
    activity.labels <- read.table(paste(main.path,"activity_labels.txt", sep = "/"), header = F)
    
    ```

2. Concatenating corresponding data together. Train subjects with test subjects, train measurements with test measurements and train activities with test activities. 

    ```
    subjects <- rbind(subject.train, subject.test)
    X <- rbind(X.train, X.test)
    y <- rbind(y.train, y.test)
    ```

3. Apply column names for concateneted data sets. Using `features` readed in first step.

    ```
    names(X) <- features[[2]]
    names(subjects) <- "Subject ID"
    names(y) <- "Activity ID"
    names(activity.labels) <- c("Activity ID", "Activity Name")
    ```

4. subseting columns that contains `mean()`, `std()` or `meanFreq()` in its name. We are not interested in other measurements. Then bind together subject identifiers, measurement data and activity identifiers.

    ```
    X <- X[,grepl("\\-(mean|meanFreq|std)\\(\\)",features[[2]])]
    X <- cbind(subjects, X, y)
    ```

5. Merging main data with activity labels data set. Merging is done by activity id that is in both data set. After that `Activity ID` is dropped from main data set.

    ```
    X <- merge(X, activity.labels, by = "Activity ID")
    X$'Activity ID' <- NULL
    ```

6. Renaming measurement variables to be more descriptive. It is done by substitution abbreviations with full names e.g. `"t" = "Time Domain"`, `"Acc" = "Acceleration"`, `"-mean()" = "Mean"`.

    ```
    x.names <- names(X)
    x.names <- gsub("^t", "Time Domain ", x.names)
    x.names <- gsub("^f", "Frequency Domain ", x.names)
    x.names <- gsub("Body", "Body ", x.names)
    x.names <- gsub("Acc", "Acceleration ", x.names)
    x.names <- gsub("Gyro", "Gyroscope ", x.names)
    x.names <- gsub("Jerk", "Jerk ", x.names)
    x.names <- gsub("Mag", "Magnitude ", x.names)
    x.names <- gsub("\\-mean\\(\\)", "Mean ", x.names)
    x.names <- gsub("\\-std\\(\\)", "Standard Deviation ", x.names)
    x.names <- gsub("\\-meanFreq\\(\\)", "Mean Frequency ", x.names)
    x.names <- gsub("\\-X$", "X Axis", x.names)
    x.names <- gsub("\\-Y$", "Y Axis", x.names)
    x.names <- gsub("\\-Z$", "Z Axis", x.names)
    x.names <- gsub("\\s$", "", x.names)
    names(X) <- x.names
    ```

7. Calculating averages of all measurement columns grouped by each subject and activity combination.

    ```
    result <- X %>% group_by(`Subject ID`, `Activity Name`) %>% summarise_each(funs(mean), 2:(dim(X)[2]-1))
    ```

8. Adding 'Average' at the and of calculated column names

    ```
    names(result)[3:dim(result)[2]] <- lapply(names(result)[3:dim(result)[2]], function(x){paste(x,"Average")})
    ```

9. Outputing transformed data to working direcotry.

    ```
    write.table(result, file = "Cleaned Sensory Data.txt", row.names = FALSE)
    ```

## Transformed Data
### Identifier data
    Subject ID
      Integer unique identifier assigned for each person
        1..30
    
    Activity Name
      Name of the activity perfored by participants
        LAYING
        SITTING
        STANDING
        WALKING
        WALKING_DOWNSTAIRS
        WALKING_UPSTAIRS

### Measurements data
Averaged sensory data for each subject and activity combination.

    Time Domain Body Acceleration Mean X Axis Average
    Time Domain Body Acceleration Mean Y Axis Average
    Time Domain Body Acceleration Mean Z Axis Average
    Time Domain Body Acceleration Standard Deviation X Axis Average
    Time Domain Body Acceleration Standard Deviation Y Axis Average
    Time Domain Body Acceleration Standard Deviation Z Axis Average
    Time Domain GravityAcceleration Mean X Axis Average
    Time Domain GravityAcceleration Mean Y Axis Average
    Time Domain GravityAcceleration Mean Z Axis Average
    Time Domain GravityAcceleration Standard Deviation X Axis Average
    Time Domain GravityAcceleration Standard Deviation Y Axis Average
    Time Domain GravityAcceleration Standard Deviation Z Axis Average
    Time Domain Body Acceleration Jerk Mean X Axis Average
    Time Domain Body Acceleration Jerk Mean Y Axis Average
    Time Domain Body Acceleration Jerk Mean Z Axis Average
    Time Domain Body Acceleration Jerk Standard Deviation X Axis Average
    Time Domain Body Acceleration Jerk Standard Deviation Y Axis Average
    Time Domain Body Acceleration Jerk Standard Deviation Z Axis Average
    Time Domain Body Gyroscope Mean X Axis Average
    Time Domain Body Gyroscope Mean Y Axis Average
    Time Domain Body Gyroscope Mean Z Axis Average
    Time Domain Body Gyroscope Standard Deviation X Axis Average
    Time Domain Body Gyroscope Standard Deviation Y Axis Average
    Time Domain Body Gyroscope Standard Deviation Z Axis Average
    Time Domain Body Gyroscope Jerk Mean X Axis Average
    Time Domain Body Gyroscope Jerk Mean Y Axis Average
    Time Domain Body Gyroscope Jerk Mean Z Axis Average
    Time Domain Body Gyroscope Jerk Standard Deviation X Axis Average
    Time Domain Body Gyroscope Jerk Standard Deviation Y Axis Average
    Time Domain Body Gyroscope Jerk Standard Deviation Z Axis Average
    Time Domain Body Acceleration Magnitude Mean Average
    Time Domain Body Acceleration Magnitude Standard Deviation Average
    Time Domain GravityAcceleration Magnitude Mean Average
    Time Domain GravityAcceleration Magnitude Standard Deviation Average
    Time Domain Body Acceleration Jerk Magnitude Mean Average
    Time Domain Body Acceleration Jerk Magnitude Standard Deviation Average
    Time Domain Body Gyroscope Magnitude Mean Average
    Time Domain Body Gyroscope Magnitude Standard Deviation Average
    Time Domain Body Gyroscope Jerk Magnitude Mean Average
    Time Domain Body Gyroscope Jerk Magnitude Standard Deviation Average
    Frequency Domain Body Acceleration Mean X Axis Average
    Frequency Domain Body Acceleration Mean Y Axis Average
    Frequency Domain Body Acceleration Mean Z Axis Average
    Frequency Domain Body Acceleration Standard Deviation X Axis Average
    Frequency Domain Body Acceleration Standard Deviation Y Axis Average
    Frequency Domain Body Acceleration Standard Deviation Z Axis Average
    Frequency Domain Body Acceleration Mean Frequency X Axis Average
    Frequency Domain Body Acceleration Mean Frequency Y Axis Average
    Frequency Domain Body Acceleration Mean Frequency Z Axis Average
    Frequency Domain Body Acceleration Jerk Mean X Axis Average
    Frequency Domain Body Acceleration Jerk Mean Y Axis Average
    Frequency Domain Body Acceleration Jerk Mean Z Axis Average
    Frequency Domain Body Acceleration Jerk Standard Deviation X Axis Average
    Frequency Domain Body Acceleration Jerk Standard Deviation Y Axis Average
    Frequency Domain Body Acceleration Jerk Standard Deviation Z Axis Average
    Frequency Domain Body Acceleration Jerk Mean Frequency X Axis Average
    Frequency Domain Body Acceleration Jerk Mean Frequency Y Axis Average
    Frequency Domain Body Acceleration Jerk Mean Frequency Z Axis Average
    Frequency Domain Body Gyroscope Mean X Axis Average
    Frequency Domain Body Gyroscope Mean Y Axis Average
    Frequency Domain Body Gyroscope Mean Z Axis Average
    Frequency Domain Body Gyroscope Standard Deviation X Axis Average
    Frequency Domain Body Gyroscope Standard Deviation Y Axis Average
    Frequency Domain Body Gyroscope Standard Deviation Z Axis Average
    Frequency Domain Body Gyroscope Mean Frequency X Axis Average
    Frequency Domain Body Gyroscope Mean Frequency Y Axis Average
    Frequency Domain Body Gyroscope Mean Frequency Z Axis Average
    Frequency Domain Body Acceleration Magnitude Mean Average
    Frequency Domain Body Acceleration Magnitude Standard Deviation Average
    Frequency Domain Body Acceleration Magnitude Mean Frequency Average
    Frequency Domain Body Body Acceleration Jerk Magnitude Mean Average
    Frequency Domain Body Body Acceleration Jerk Magnitude Standard Deviation Average
    Frequency Domain Body Body Acceleration Jerk Magnitude Mean Frequency Average
    Frequency Domain Body Body Gyroscope Magnitude Mean Average
    Frequency Domain Body Body Gyroscope Magnitude Standard Deviation Average
    Frequency Domain Body Body Gyroscope Magnitude Mean Frequency Average
    Frequency Domain Body Body Gyroscope Jerk Magnitude Mean Average
    Frequency Domain Body Body Gyroscope Jerk Magnitude Standard Deviation Average
    Frequency Domain Body Body Gyroscope Jerk Magnitude Mean Frequency Average