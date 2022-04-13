

for (i in 1:6) {
  for (j in 1:6) {
   sprintf("$(%i, %i)$ &", i, j)
  }
}

pmf <- function(x) {
  if (x == 1) return(11/36)
  else if (x == 2) return(9/36)
  else if (x == 3) return(7/36)
  else if (x == 4) return(5/36)
  else if (x == 5) return(3/36)
  else if (x == 6) return(1/36)
}
pmf(3)


mu <- 0
for (x in 1:6) {
  mu <- mu + x * pmf(x)
}
print(mu)

sigma <- 0
for (x in 1:6) {
  sigma <- sigma + (x - mu)^2
}

sigma <- sigma/36
print(sigma)