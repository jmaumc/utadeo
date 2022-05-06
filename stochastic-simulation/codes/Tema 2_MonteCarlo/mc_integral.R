mc_integral <- function(ftn, a, b, n) {
 # Monte Carlo integral of ftn over [a, b] using a sample of size n
 u <- runif(n, a, b)
 x <- ftn(u)
 return(cumsum(x)/(1:n)*(b-a))
}

f <- function(x) x^3 - 7*x^2 + 1
a=0
b=1
n=100000

I = mc_integral(f,a,b,n)
plot(1:n, I, type = "l")
#plot((floor(n/100)):n, I[(floor(n/100)):n], type = "l")
lines(c(1,n), c(-13/12, -13/12),col="red")

Err = abs((I-(-13/12))/(-13/12))
logErr = log(Err)

plot(1:n, Err, type = "l")
plot( 1:n, Err, log="xy", type = "l", main = "Log-log Plot")
plot(log(1:n), logErr, type = "l", main = "Log-log Plot")

lmErr = lm(logErr ~ log(1:n))
lmErr
abline(lmErr, untf=F, col="blue")


