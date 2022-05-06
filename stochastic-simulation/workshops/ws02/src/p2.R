# Punto 2

n <- 1000
trials <- 30
tests.contained <- 1:trials
result <- sprintf("Number of trials: %d\n\n", trials)
result <- paste(result, "sample mean  lower bound   upper bound  contains mean?\n")
for (i in 1:trials) {
  X <- runif(n, min = -1, max = 1)
  S <- sd(X)
  sigmaXbar <- S/sqrt(n)
  Xbar <- mean(X)
  
  # CI of 95%
  low <- Xbar - 1.96 * sigmaXbar
  up <- Xbar + 1.96 * sigmaXbar
  
  contained.in.IC <- 0
  if (Xbar > low & Xbar < up)
    contained.in.IC <- 1
  tests.contained[i] <- contained.in.IC
  
  result <- paste(result, sprintf("%+.5f    %+.5f       %+.5f     %s\n", Xbar, low, up, contained.in.IC))
}
perc.contained <- sum(tests.contained == 1) / trials * 100
result <- paste(result, sprintf("\n%.f per cent of CI's contain the mean.\n", perc.contained))
print(cat(result))
