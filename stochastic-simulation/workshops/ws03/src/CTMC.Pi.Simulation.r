#### Programa para calcular el vector de probabilidades l�mite pi (Libro Jones) ####

P <- matrix(c(0.5, 0.4, 0.1, 0.3, 0.4, 0.3, 0.2, 0.3, 0.5), nrow = 3, ncol = 3, byrow = TRUE)
e <- c(1, 1, 1)
I <- diag(e)
E <- matrix(1, nrow = 3, ncol = 3)
solve(I + E - t(P), e)

# pi=[0.3387..., 0.3709677..., 0.2903226...]
# �C�mo describen el estado de �nimo de Juan en el largo plazo?, es decir
# �qu� proporci�n de d�as est� Alegre, Normal y Triste?
#  El 33% de los d�as Juan est� Alegre, el 37% est� Normal
#  y el 29% de los d�as est� Triste, en el largo plazo



# program spuRs/resources/scripts/MCSimulation.r
# loadable spuRs function
# Discrete time Markov Chain Simulation
# This function simulates a discrete MC with transition matrix P,
# state space {0,1,..,n}, and initial state i for nsteps transitions


MCSimulation <- function(P, i, nsteps) {
  n <- nrow(P) - 1
  statehist <- c(i, rep(0, nsteps))
  for (step in 2:(nsteps + 1)) {
    statehist[step] <- sample(0:n, 1, prob = P[1 + statehist[step - 1], ])
  }
  return(statehist)
}

P <- matrix(c(0.5, 0.4, 0.1, 0.3, 0.6, 0.1, 0.2, 0.5, 0.3), nrow = 3, ncol = 3, byrow = TRUE)
N <- 10000
sim <- MCSimulation(P, 0, N)

# Estimation of the proportion of time in each state in the long run #
sum(sim == 0) / N
sum(sim == 1) / N
sum(sim == 2) / N
