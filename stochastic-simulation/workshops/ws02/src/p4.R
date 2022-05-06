# Punto 4
# Literal a
simulate.two.dices <- function() {
  return(floor(runif(n = 2, min = 1, max = 7)))
}

min.two.dices <- function() {
  trial <- simulate.two.dices()
  #print(sprintf("Trial: (%d, %d)", trial[1], trial[2]))
  return(min(trial))
}

min.two.dices.sim <- function(n) {
  trials <- 1:n
  for (i in 1:n) {
    trials[i] = min(simulate.two.dices())
  }
  #print(sprintf("Trial: (%d, %d)", trial[1], trial[2]))
  return(trials)
}

# Literal b
num.sim <- 10000
sample <- 1:num.sim
for (sim in 1:num.sim) {
  sample[sim] <- min.two.dices()
}

M.bar <- mean(sample)
S <- sd(sample)
var <- S^2

prob.at.least.3 <- sum(sample >= 3)/num.sim
print(c("P(M >= 3)", prob.at.least.3))
print(sprintf("x.bar = %.5f, var = %.5f", M.bar, var))

# Literal c
sigma.M.bar <- S/sqrt(num.sim)
lower <- M.bar - 1.96 * sigma.M.bar
upper <- M.bar + 1.96 * sigma.M.bar
print(sprintf("IC del 95 por ciento para la media [%.5f, %.5f]", lower, upper))

# Literal d
n = 10^5
M = min.two.dices.sim(n)
cummean <- cumsum(M)/(1:n)
esterr <- sqrt(cumsum(M-cummean)^2)/(1:n)
plot(cummean, xlab="Mean and error range", type="l", lwd=+2, ylim = mean(M)+20*c(-esterr[n], esterr[n]), ylab = "")
lines(cummean+1.96*esterr, col="gold", lwd=2)
lines(cummean-1.96*esterr, col="gold", lwd=2)



