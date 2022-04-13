
# Punto 7.a

g <- function(x) {
  return(x ^ 2)
}

n = 10000
lim.inf = -2
lim.sup = 2

sum = 0
for (i in 1:n) {
  sum <- sum + g(runif(n=1, min=lim.inf, max=lim.sup))
}

ans.1 <- ( (lim.sup-lim.inf) / n ) * sum
print(ans.1)

# Punto 7.b
a = 0
b = 1
c = 0
d = 2

f <- function(x, y) {
  return(exp((x+y)^2))
}

sum = 0
for (i in 1:n) {
  sum <- sum + f(runif(n=1, min=a, max=b), runif(n=1, min=c, max=d))
}

ans.2 <- ((b-a)*(d-c)/n) * sum
print(ans.2)