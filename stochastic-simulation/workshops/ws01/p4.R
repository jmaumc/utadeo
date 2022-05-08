cdf.x <- function(x) {
  Fx <- 0
  if (x < 1) {
    return(0)
  }
  else if (1 <= x & x < 2) {
    return(0.1)
  }
  else if (2 <= x & x < 5) {
    return(0.4)
  }
  else {return(5)}
}

x.test <- seq(0,6,0.01)
Fx <- apply(as.array(x.test), 1, cdf.x)
plot(x.test, Fx, type = "stairs")

cdf.sim <- function(F, ...) {
  X <- 0
  U <- runif(1)
  while (F(X, ...) < U) {
    X <- X + 1
  }
  return(X)
}

cdf.sim(cdf.x)

Nsim <- 10 ^ 3
Xsim <- rep(0, Nsim)
for (i in (1:Nsim)) {
  Xsim[i] <- cdf.sim(cdf.x)
}

Fx <- apply(as.array(Xsim), 1, cdf.x)
plot(Xsim, Fx, type = "lines")

hist(Xsim)
