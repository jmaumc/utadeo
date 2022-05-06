#-------Bootstrap example: Robert and Casella (page 24, 26)----

#The sample was in fact drawn from a gamma G(4, 1) distribution
y=c(4.313, 4.513, 5.489, 4.265, 3.641, 5.106, 8.006, 5.087)
mean(y)
plot(ecdf(y))
hist(y)

hist(sd(y))


#--- 1 Bootstrap ---
ystar=sample(y,replace=T)
ystar
mean(ystar)

#--- 2500 Bootstraps ---
ystar = matrix(sample(y,2500*8,replace=T),nrow=2500,ncol=8)

#--- Evaluate the mean for each bootstrap sample ---
meanystar = apply(ystar,1,mean)
hist(meanystar, freq = FALSE, xlab="Bootstrap Means",ylab="Relative Frequency")

#--- Normal distribution of the mean of y ----
lines(seq(-7,7,0.1), dnorm(seq(-7,7,0.1), mean=mean(y), sd=sd(y)/sqrt(length(y))))

mean(meanystar)
mean(y)

quantile(meanystar, 0.95)
quantile(meanystar, 0.05)

