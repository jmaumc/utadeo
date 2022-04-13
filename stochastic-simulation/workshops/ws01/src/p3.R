
random_uniform_congruential <- function(n, x0, a, c, m) {
  x <- 1:n
  for (i in 1:n){
    
    if (i==1) {
      x[i] <- (a*x0+c) %% m
    }
    else {
      x[i] <- (a*x[(i-1)]+c) %% m
    }
    
  }
  return(x)
}

for (j in 0:10) {
  print(random_uniform_congruential(10, j, 8, 3, 11))  
}
