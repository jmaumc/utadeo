# Taller 3

# Punto 1

P <- matrix(c(
    0.5, 0.5, 0, 0,
    0, 0.5, 0.5, 0,
    0, 0, 0.2, 0.8,
    0.5, 0, 0, 0.5
), nrow = 4, ncol = 4, byrow = TRUE)

e <- c(1, 1, 1, 1)

I <- diag(e)

E <- matrix(1, nrow = 4, ncol = 4)

sol <- solve(I + E - t(P), e)
print(sol)

# Using the package
library(markovchain)

mc_p1 <- new("markovchain",
    states = c("0", "1", "2", "3"),
    transitionMatrix = P, name = "CMDT_P1"
)

show(mc_p1)
print(mc_p1)

library(igraph)

plot(mc_p1)

summary(mc_p1)

# simulation
N <- 1000
mc_sim <- rmarkovchain(n = N, object = mc_p1, t0 = "0")
print(mc_sim)

print(sum(mc_sim == "0") / N)
print(sum(mc_sim == "1") / N)
print(sum(mc_sim == "2") / N)
print(sum(mc_sim == "3") / N)

print(steadyStates(mc_p1))
