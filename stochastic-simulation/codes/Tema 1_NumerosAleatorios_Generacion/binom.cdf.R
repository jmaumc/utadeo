binom.cdf <- function(x, n, p) {
Fx <- 0
for (i in 0:x) {
Fx <- Fx + choose(n, i)*p^i*(1-p)^(n-i)
}
return(Fx)
}

cdf.sim <- function(F, ...) {
X <- 0
U <- runif(1)
while (F(X, ...) < U) {
X <- X + 1
}
return(X)
}

n=10
p=1/6
cdf.sim(binom.cdf, n, p)
