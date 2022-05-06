# Punto 4
y=c(4.313, 4.513, 5.489, 4.265, 3.641, 5.106, 8.006, 5.087)


ystar=sample(y,replace=T)
ystar
S <- sd(y)

# Parte a
ystar = matrix(sample(y,2500*8,replace=T),nrow=2500,ncol=8)
sdystar = apply(ystar,1,sd)
hist(sdstar, freq = FALSE, xlab="Bootstrap Standard Deviations",ylab="Relative Frequency")

# Parte b
sd(sdystar)
mean(y)

# Parte c
quantile(sdystar, 0.5)
quantile(sdystar, 0.05)

# Parte d
var(sdystar)
