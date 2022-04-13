
# Inversa de la CDF para el punto 5
cdf.inv <- function(x) {
  return( ( (x/3) ^ (1/3) )- 1 )
}

# Simulador de n numeros aleatorios
cdf.sim <- function(n, CDF, ...) {
  rst <- 1:n
  for (i in 1:n) {
    rst[i] <- CDF(runif(1), ...)
  }
  return(rst)
}

pdf <- function(x) {
  if (1 < x && x <= 2) return(3*(x-1)^2)
  else return(0)
}

#hist(cdf.sim(10 ^ 4, cdf.inv), main = "Histograma para simulador de la CDF")
x <- seq(-1, 0, 0.01)

plot(cdf.sim(10 ^ 4, cdf.inv, type='h'), main = "PDF")
plot(x, pdf(x))