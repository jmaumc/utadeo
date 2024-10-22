#--- Proceso de Wiener con drift y varianza (movimiento browniano con drift) ---

T=10   #Tiempo de la simulaci�n
N=1000 #Tama�o de la discretizaci�n temporal
mu=10  #Drift
sigma=5 #Desviaci�n est�ndar del movimiento browniano
dt=T/N  #Paso de tiempo

dW=rnorm(N, mean=0, sd=sqrt(dt))  #Incremento del proceso de Wiener
dX=mu*dt+sigma*dW

X=c(0,cumsum(dX))
t=seq(0,T,dt)
plot(t,X, type='l', ylim=c(0,1.5*mu*T), ylab="Xt", xlab="t")
par(new=TRUE)
plot(t,mu*t, type='l', col='red',ylim=c(0,1.5*mu*T), ylab="Xt", xlab="t")

X
