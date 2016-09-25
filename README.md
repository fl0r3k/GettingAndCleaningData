# Sensory Data Cleaning Script
### Required Data
To correcly run script `run_analysis.R` you need to download sensory data from the following link.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Extract data to your working directory so there will be a directory called `UCI HAR Dataset` with the content shown below eg.:

    /home/<your user name>/UCI HAR Dataset
    
        ./test
        ./train
        ./activity_labels.txt
        ./features.txt
        ./features_info.txt
        ./README.txt

### Required libraries
Script uses `dplyr` package. Make sure it is installed.

### Before Running Script
If not jet set, set your working direcotry to where `UCI HAR Dataset` resides. So if `UCI HAR Dataset` direcotry is in your home then:

    setwd("/home/<your user name>")
    
You don't have to load manually `dplyr` package. It is done in `run_analysis.R` script.

### Running Script    
Open `run_analysis.R` and submit it.

### Results
File named `Cleaned Sensory Data.txt` with results shoud be created in your working directory.