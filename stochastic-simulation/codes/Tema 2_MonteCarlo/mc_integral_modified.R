mc_integral_modified <- function(ftn, a, b, n) {

 # Monte Carlo integral of ftn over [a, b] using a sample of size n
 u <- runif(n, a, b)
 x <- sapply(u, ftn)
 return(mean(x)*(b-a))
}