library(MASS)
library(Metrics)
library(ggplot2)
library(GGally)
library(stargazer)
library(lmtest)
library(faraway)
library(car)


# 0. Preparacion de los datos
datpath <- "~/utadeo/statistics/workshops/ws0201/"
trainpath <- paste(datpath, "dat/training_set.csv", sep = "")
validpath <- paste(datpath, "dat/validation_set.csv", sep = "")
tablespath <- paste(datpath, "doc/", sep = "")

skipped.cols = c(-1, -17) # no ID, no ZIPCODE
training.set <- read.csv(trainpath)[, skipped.cols]
validation.set <- read.csv(validpath)[, skipped.cols]

training.set$date <- as.Date(substr(training.set$date, 0, 10))
validation.set$date <- as.Date(substr(validation.set$date, 0, 10))

# Variables categoricas
training.set$waterfront <- factor(training.set$waterfront)
validation.set$waterfront <- factor(validation.set$waterfront)

training.set$view <- factor(training.set$view)
validation.set$view <- factor(validation.set$view)

training.set$condition <- factor(training.set$condition)
validation.set$condition <- factor(validation.set$condition)

training.set$grade <- factor(training.set$grade)
validation.set$grade <- factor(validation.set$grade)

catvars <- c("waterfront", 
             "view", 
             "condition", 
             "grade")
numvars <- c("price", 
             "bedrooms", 
             "bathrooms", 
             "sqft_living", 
             "sqft_lot", 
             "floors",
             "sqft_above",
             "sqft_basement", 
             "yr_built", 
             "yr_renovated", 
             "lat", 
             "long", 
             "sqft_living15",
             "sqft_lot15")

# 1. Exploracion de los datos
summary(training.set[,numvars])
table.1.file <- paste(tablespath, "summary.txt", sep = "")

stargazer(training.set[,numvars], 
          font.size = "small", 
          omit.summary.stat = c("n", "min", "mean", "max"))

stargazer(training.set[,numvars], 
          font.size = "small", 
          omit.summary.stat = c("n", "p25", "p75", "sd"))

stargazer(training.set[,catvars], 
          font.size = "small", 
          summary.stat = c("min", "median", "max", "p25", "p75"))

stargazer(training.set[,catvars], 
          font.size = "small", 
          summary.stat = c("p25", "p75"))

pl.title <- "Diagrama de cajas y bigotes para el precio de las viviendas"
ggplot(data = training.set, aes(x = price)) +
  geom_boxplot() +
  labs(title = pl.title) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data = training.set) +
  aes(x = price, y = sqft_lot15) +
  geom_point()

# 2. Primer modelo
training.set.1 <- training.set[, c(-1,-13,-15,-16,-17)]
validation.set.1 <- validation.set[, c(-1,-13,-15,-16,-17)]

M1 <- lm(price ~ ., data = training.set.1)
summary(M1)
stargazer(M1)

############# experimento
M1.ex1 <- lm(price ~  floors + view + sqft_lot + sqft_above, data = training.set.1)
summary(M1.ex1)
M1.ex2 <- lm(price ~ ., data = training.set.1[, numvars])
summary(M1.ex2)
############# fin experimento

# Matriz de correlacion
cormatrix <- round(cor(training.set.1), 2)
stargazer(cormatrix, summary = FALSE, digits = 2, font.size = "tiny")

# Grafica de los residuales
plot(predict(M1, data = training.set.1), 
     residuals(M1), 
     title(main = "Gráfica de residuales para el modelo M1"))

M2 <- lm(sqrt(price) ~ ., data = training.set.1)
summary(M2)
plot(predict(M2, data = training.set.1), 
     residuals(M2), 
     title(main = "Gráfica de residuales para el modelo M2"))
hist(M2$resid,main="Histograma of Residuale para M2")
qqnorm(M2$resid, main = "Q-Q Plot para M2")
qqline(M2$resid)

M3 <- lm (1/price ~ ., data = training.set.1)
summary(M3)
plot(predict(M3, data = training.set.1), 
     residuals(M3), 
     title(main = "Gráfica de residuales para el modelo M3"))

bc <- boxcox(price ~ ., data = training.set.1)

max.lambda <- bc$x[which.max(bc$y)]

M4 <- lm(price^max.lambda ~ ., data = training.set.1)
summary(M4)
plot(predict(M4, data = training.set.1), 
     residuals(M4), 
     title(main = "Gráfica de residuales para el modelo M4"))

# normalidad de los residuales 
hist(M4$resid,main="Histograma of Residuales para M4")
qqnorm(M4$resid, main = "Q-Q Plot para M4")
qqline(M4$resid)

# Sapiro.Wilk
shapiro.test(resid(M4))

# Durbin - Watson test 
dwtest(M4)

# Valores atipicos
stres <- rstudent(M4)
stres[which.max(abs(stres))]
outlierTest(M4)

# Casos con leverage
lev.M4 <- influence(M4)
sum(lev.M4$hat)

halfnorm(lev.M4$hat, labs = row.names(training.set.1))

# Observaciones influyentes
cook <- cooks.distance(M4)
plot(cook)
abline(h=4/(17290-13), lty=2)
halfnorm(cook, nlab = 3, 
         labs = row.names(training.set.1), 
         ylab = "Distancia de Cook")
abline(h = 4 / (nrow(training.set.1)-13), 
       lty = 2)
influencePlot(M4, id = list(n=2))

# Estructura del modelo
prp.1 <- prplot(M4, 1)
prp.2 <- prplot(M4, 2) 
prp.3 <- prplot(M4, 3)
prp.4 <- prplot(M4, 4)
prp.5 <- prplot(M4, 5)
prp.6 <- prplot(M4, 6)
prp.7 <- prplot(M4, 7)
prp.8 <- prplot(M4, 8)
prp.9 <- prplot(M4, 9)
prp.10 <- prplot(M4, 10)
prp.11 <- prplot(M4, 11)
prp.12 <- prplot(M4, 12)
prp.13 <- prplot(M4, 13)

prp.1

plot.list <- list(prplot(M4, 1),
                  prplot(M4, 2),
                  prplot(M4, 3),
                  prplot(M4, 4),
                  prplot(M4, 5),
                  prplot(M4, 6),
                  prplot(M4, 7),
                  prplot(M4, 8),
                  prplot(M4, 10),
                  prplot(M4, 11),
                  prplot(M4, 12),
                  prplot(M4, 13))

# Colinealindad
tab.vif <- vif(M4)
par(mar=c(5,6,4,1)+.1)
barplot(tab.vif, main = "VIF", horiz = TRUE, las=1)
abline(v = 5, lwd = 3, lty = 2)

# RMSE
RSS <- c(crossprod(M4$residuals))
MSE <- RSS / length(M4$residuals)
RMSE <- sqrt(MSE)

predicted <- predict(M4, newdata = validation.set.1)
rmse(training.set.1, predicted)






