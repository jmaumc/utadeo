expsim <- function(l,n){
  U = runif(n)
  return(log(1-U)/(-l))
}

n <- 100000
l <- 1
X <- expsim(l,n)

h = hist(X)
h$density = h$counts/(n*0.5)
plot(h,freq=FALSE)

x <- seq(0, 10, 0.05)
lines(x, l*exp(-l*x), col = 'red')
