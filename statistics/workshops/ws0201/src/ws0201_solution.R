library(MASS)
library(Metrics)

# 1. Preparacion de los datos
datpath <- "E:/utadeo/statistics/workshops/ws0201/dat/"
trainpath <- paste(datpath, "training_set.csv", sep = "")
validpath <- paste(datpath, "validation_set.csv", sep = "")

skipped.cols = c(-1, -17)
training.set <- read.csv(trainpath)[, skipped.cols]
validation.set <- read.csv(validpath)[, skipped.cols]

training.set$date <- as.Date(substr(training.set$date, 0, 10))
validation.set$date <- as.Date(substr(validation.set$date, 0, 10))
training.set$waterfront <- factor(training.set$waterfront)
validation.set$waterfront <- factor(validation.set$waterfront)