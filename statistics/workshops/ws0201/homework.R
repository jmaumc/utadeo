
library(MASS)
library(Metrics)

# Som data explorations
#pairs(training_set[, c(-1,-2)])
#ggpairs(training_set[, c(-1,-2)])

skipped.cols = c(-1, -17)
king.train <- read.csv("E:/utadeo/probability/training_set.csv")[, skipped.cols]
king.valid <- read.csv("E:/utadeo/probability/validation_set.csv")[, skipped.cols]

king.train$date <- as.Date(substr(king.train$date, 0, 10))
king.valid$date <- as.Date(substr(king.valid$date, 0, 10))
king.train$waterfront <- factor(king.train$waterfront)
king.valid$waterfront <- factor(king.valid$waterfront)

lmstart <- lm(price ~ ., data = king.train)
summary(lmstart)

names(king.train)
lmhouses.1 <- lm(price ~ ., data = king.train[, c(-7, -13)])
summary(lmhouses.1)

###### Analysis A: skip variables related with space and time ######
cormatrix <- round(cor(king.train[, c(-1, -7, -8, -13)], 2))

plot(predict(lmhouses.1, 
             data = king.valid[, c(-1, -7, -8, -13)]), 
     residuals(lmhouses.1))

trhouses <- boxcox(price ~ ., data = king.train[, c(-1, -7, -8, -13)])

max.lambda <- trhouses$x[which.max(trhouses$y)]
lmhouses.tr <- lm(price^max.lambda ~ ., 
                  data = king.train[, c(-1, -7, -8, -13)])
summary(lmhouses.tr)

plot(predict(lmhouses.tr, 
             data = king.valid[, c(-1, -7, -8, -13)]), 
     residuals(lmhouses.tr))

# 3. Diagnostics


qqnorm(resid(lmhouses.tr))
qqline(resid(lmhouses.tr))

shapiro.test(resid(lmking.bc))



# Valores alto leverage
infhouses <- influence(lmhouses.tr)
halfnorm(infhouses$hat, labs = row.names(lmhouses.tr))

# Valores atipicos
stres <- rstudent(lmhouses.tr)
stres[which.max(abs(stres))]

# Valores influyentes
cook <- cooks.distance(lmhouses.tr)
plot(cook)
abline(h=4/(17290-17), lty=2)

halfnorm(cook, nlab = 3, labs = row.names(lmhouses.tr), 
         ylab = "Distancia de Cook")
abline(h = 4/(nrow(kinghouses.t)-13), lty=2)

# Estructura del modelo
prp.1 <- prplot(lmking.bc, 1) # date, notok
prp.2 <- prplot(lmking.bc, 2) 
prp.3 <- prplot(lmking.bc, 3)
prp.4 <- prplot(lmking.bc, 4)
prp.5 <- prplot(lmking.bc, 5)
prp.6 <- prplot(lmking.bc, 6)
prp.7 <- prplot(lmking.bc, 7)
prp.8 <- prplot(lmking.bc, 8)
prp.9 <- prplot(lmking.bc, 9)
prp.10 <- prplot(lmking.bc, 10)
prp.11 <- prplot(lmking.bc, 11)
prp.12 <- prplot(lmking.bc, 12)
prp.13 <- prplot(lmking.bc, 13)
prp.14 <- prplot(lmking.bc, 14)



actual <- king.valid[, 2]
predic <- predict(lmhouses.tr, data = king.valid[, c(-1, -7, -8, -13)])

rmse <- sqrt(sum((predi-medid)^2)/4323)
rmse <- rmse(actual, predic)
rmse

kinghouses.t$waterfront <- factor(kinghouses.t$waterfront)


