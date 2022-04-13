#Program to generate random numbers
#(Tomado de Sección 20.1, "Introduction to Scientific Programming with R, Owen Jones)

#If the seed is not given, it generates it from the clock
runif(2)
runif(2)

#You can set the seed
set.seed(42)
runif(2)

# The current state of the random number generator is kept in
# the vector .Random.seed.

RNG.state <- .Random.seed
runif(2)

set.seed(42)
runif(4)

.Random.seed <- RNG.state
runif(2)

#To clear the seed and generate it randomly from clock

set.seed(Sys.time())
runif(4)

#Plot the random numbers

x<-runif(1000)
plot(x)

