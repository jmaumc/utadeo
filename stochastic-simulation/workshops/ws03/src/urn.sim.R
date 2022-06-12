# Simulate the states of the DTMC modeling the Ehrenfest urn model

# N: Number of steps
# m: Number of balls
# pi0: Initial probability vector
# P: Transition probability matrix

urn.sim <- function(N, m, pi0, P) {

  #vector of states
  X = rep(0,N+1)
  
  #initial condition
  X[1] = sample(rep(0:m), 1, replace = TRUE, prob = pi0)

  for (i in 2:(N+1)) {
    X[i] = sample(rep(0:m), 1, replace = TRUE, prob = P[X[i-1]+1,])
  }
  
  return(X)
  
}

N=100
m=3
pi0=c(0.1,0.3,0.2,0.4)
P=matrix(c(0,1,0,0,1/3,0,2/3,0,0,2/3,0,1/3,0,0,1,0),nrow = 4, byrow=4)

X<-urn.sim(N,m,pi0,P)
X