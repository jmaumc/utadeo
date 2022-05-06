#El c?digo confidence.interval.integration.r  aproxima la integral de la funci?n h(x)
#sobre el intervalo [0,1], utilizando Monte Carlo. Grafica las estimaciones 
#y el intervalo de confianza al 95% del estimador en funci?n del n?mero n de simulaciones.

h=function(x){(cos(50*x)+sin(20*x))^2}

par(mar=c(2,2,2,1),mfrow=c(2,1))
curve(h,xlab="Function",ylab="",lwd=2)
integrate(h,0,1)

#number of simulations
n = 10^4
  
x=h(runif(n))
mean(x)
sd(x)
errmean=sd(x)/sqrt(n)
errmean

# vector con intervalo de confienza del 95%
c(mean(x)-1.96*sd(x)/sqrt(n), mean(x)+1.96*sd(x)/sqrt(n))

#estimation of the integral
estint=cumsum(x)/(1:n)

#estimation of the error
esterr=sqrt(cumsum((x-estint)^2))/(1:n)
esterr[length(esterr)]

plot(estint, xlab="Mean and error range", type="l",
     lwd=+2, ylim=mean(x)+20*c(-esterr[n],esterr[n]), ylab="")

#CI:95%
lines(estint+1.96*esterr,col="gold",lwd=2)
lines(estint-1.96*esterr,col="gold",lwd=2)

int=integrate(h,0,1)$value
int
lines(rep(int,n), col="red")
