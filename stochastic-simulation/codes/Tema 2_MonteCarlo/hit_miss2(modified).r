#Hit and miss2 (modificado)
#Versión modificada del código que aparece en la presentación:
#imprime todos los valores de I obtenidos de cada iteración 
#plotea en color rojo el valor real

hit_miss2 <- function(ftn, a, b, c, d, n) {
 # Monte-Carlo integration using the hit & miss method
 # partially vectorised version
 X <- runif(n, a, b)
 Y <- runif(n, c, d)
 Z <- (Y <= sapply(X, ftn))
 I <- (b - a)*c + (cumsum(Z)/(1:n))*(b - a)*(d - c)
 plot( 1:n, I[1:n], type = "l")
 return(I) }

f <- function(x) x^3 - 7*x^2 + 1
n <- 1000000

#Se define Int como el vector con todos lo valores de I obtenidos
Int <- hit_miss2(f, 0, 1, -6, 2, n)

#El valor real de I es -13/12
lines(c(1, 100000), c(-13/12, -13/12), col="red")  

x = 1:n
y = abs((Int-(-13/12))/(-13/12))

plot(x, y)
plot(x,y, log = "xy", type = "l", main = "Log-log Plot")

plot(log(x),log(y), type="l", main = "Log-log Plot")
reg=lm(log(y) ~ log(x))
reg
abline(reg, untf=F, col="blue")


