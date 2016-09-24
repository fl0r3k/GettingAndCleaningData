# Seting path to data direcotry
main.path <- "./UCI HAR Dataset";
train.path <- paste(main.path, "train", sep = "/")
test.path <- paste(main.path, "test", sep = "/")

# Reading train data sets
subject.train <- read.table(paste(train.path,"subject_train.txt", sep = "/"), header = F)
X.train <- read.table(paste(train.path,"X_train.txt", sep = "/"), header = F)
y.train <- read.table(paste(train.path,"y_train.txt", sep = "/"), header = F)

# Reading test data sets
subject.test <- read.table(paste(test.path,"subject_test.txt", sep = "/"), header = F)
X.test <- read.table(paste(test.path,"X_test.txt", sep = "/"), header = F)
y.test <- read.table(paste(test.path,"y_test.txt", sep = "/"), header = F)

# Reading features/variables names
features <- read.table(paste(main.path,"features.txt", sep = "/"), header = F)
# Reading activity names
activity.labels <- read.table(paste(main.path,"activity_labels.txt", sep = "/"), header = F)

# Concatenating train and test data sets(train and test subjects, X train and test, y train and test)
subjects <- rbind(subject.train, subject.test)
X <- rbind(X.train, X.test)
y <- rbind(y.train, y.test)

# Setting column names in concatenated data sets
names(X) <- features[[2]]
names(subjects) <- "Subject ID"
names(y) <- "Activity ID"
names(activity.labels) <- c("Activity ID", "Activity Name")

X <- X[,grepl("\\-(mean|meanFreq|std)\\(\\)",features[[2]])]
X <- cbind(subjects, X, y)

# Merging activity names from activity_labels.txt with activity id then drops activity id
X <- merge(X, activity.labels, by = "Activity ID")
X$'Activity ID' <- NULL

## Renaming variables to be more descriptive
# It is done by substitution abbreviations with full names e.g.
# "t" = "Time Domain"
# "Acc" = "Acceleration"
# "-mean()" = "Mean"
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


result <- data.frame()
subjects.col <- c()
activities.col <- c()
for(i in unique(X$`Subject ID`)) {
    for(j in unique(X$`Activity Name`)) {
        subjects.col <- c(subjects.col, i)
        activities.col <- c(activities.col, j)
        result <- rbind(result,
                        X %>%
                            filter(`Subject ID` == i & `Activity Name` == j) %>%
                            summarise_each(funs(mean), 2:(dim(X)[2]-1))
        )
    }
}
result[is.na(result)] <- 0
names(result) <- lapply(names(result),function(x){paste(x,"Average")})
result <- cbind(subjects.col,activities.col,result)
names(result)[1:2] <- c("Subject ID", "Activity Name")

write.table(result, file = "Cleaned Sensory Data.txt", row.names = FALSE)