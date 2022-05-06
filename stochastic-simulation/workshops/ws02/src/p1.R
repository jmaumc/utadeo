# Punto 1

get.n <- function(d) {
  n.estimated <- 100
  sample <- rnorm(n=n.estimated, mean=0, sd=1)
  S.sample <- sd(sample) / sqrt(n.estimated)
  while(S.sample >= d) {
    sample <- c(sample, rnorm(n=1, mean=0, sd=1))
    n.estimated <- n.estimated + 1
    S.sample <- sd(sample) / sqrt(n.estimated)
  }
  print(c("mean", mean(sample)))
  print(c("var", var(sample)))
  return(n.estimated)
}

print(get.n(d=0.01))
