#Estimating correctly the variance:
#1. By running several MC simulations in parallel
#2. By bootstrap

#(Robert and Casella, Example 4.1) If we repeat the simulations of Example 3.3, we can produce a
#matrix of converging estimators as in

h=function(x){(cos(50*x)+sin(20*x))^2}

x=matrix(h(runif(200*10^4)),ncol=200)
estint=apply(x,2,cumsum)/(1:10^4)

#and thus obtain a Monte Carlo evaluation of the Monte Carlo variation by

plot(estint[,2],ty="l",col=1,ylim=c(.8,1.2))
y=apply(estint,1,quantile,c(.025,.975))
lines(c(1:10^4,10^4:1),c(y[1,],rev(y[2,])),col="red")

#At any iteration, the band represented in Figure 4.1 contains 95% of the estimation
#sequences. Obviously, if we pick any of the convergence sequences thus produced,
#the CLT confidence band will fail to correspond to this overall band since
#it will reproduce the variations of the original sequence

#If we now consider the bootstrapped version of the overall confidence band, we start
#by producing bootstrapped replicas of the original sequence x[,1] using

boot=matrix(sample(x[,1],200*10^4,rep=T),nrow=10^4,ncol=200)

#and then reproduce the confidence band construction by

bootit=apply(boot,2,cumsum)/(1:10^4)
bootup=apply(bootit,1,quantile,.975)
bootdo=apply(bootit,1,quantile,.025)

#As shown in Figure, the band thus produced has a behavior that is quite
#similar to that of the band resulting from iid replications of the Monte Carlo
#sequence, except for a drift in its location. The gain in using the bootstrap version
#is obviously that only a single sequence needs to be produced.

sesgo = bootit - mean(x[,1])

#Exercise: Plot the confidence interval with bootstrap
lines(c(1:10^4),bootup-sesgo*rep(1,10^4), col="green")
lines(c(1:10^4),bootdo-sesgo, col="green")
