mc_integral_cumsum <- function(ftn, a, b, n) {
  # Monte Carlo integral of ftn over [a, b] using a sample of size n
  U <- runif(n, a, b)
  Y <- sapply(U, ftn)
  I <- (cumsum(Y)/(1:n))*(b-a)
  plot( 1:n, I, type = "l")
  return(I) 
}

f <- function(x) x^3 - 7*x^2 + 1
n <- 200000

#Se define Int como el vector con todos lo valores de I obtenidos
Int <- mc_integral_cumsum(f, 0, 1, n)

lines(c(1, 200000), c(-13/12, -13/12), col="red")  

#Error absoluto normalizado
Error <- abs(((-13/12)-Int)/(-13/12))*100

Steps = 1:n

#Plotea error vs n
plot(Steps,type="lines",Error)

#Plotea los ultimos 10000 datos
plot(Steps[-(n-10000:n)],Error[-(n-10000:n)], type="lines")

logError <- log(Error)
logSteps <- log(Steps)

#Plotea los logaritmos
plot(logSteps,logError, type="lines")

#Realiza la regresión lineal
regr <- lm(logError ~ logSteps)

#La pendiente es el exponente del orden de convergencia
regr

