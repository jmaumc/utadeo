
#Aplicando un generador de números aleatorios

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
  return(x/m)
}


x=random_uniform_congruential(n=100, c=2, a=13, m=31, x0=1)

#Para buscar la longitud de periodo
x==x[1]

