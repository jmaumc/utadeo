
# Random walk (Caminata aleatoria) #

# Inputs:
# Definir el tipo de distribución 
# del ruido blanco et
# Definir su varianza sigmae^2
 
#------------ Ejemplo 1: Ruido blanco distribuido normal --------

sigmae <- 1 

# Simulación del ruido blanco et
T <- 100 # Número de pasos a simular
e <- rnorm(T, mean=0, sd=sigmae)

# Gráfica del ruido blanco
plot(e, main="Ruido blanco")

# Función de autocorrelación del ruido blanco
acf(e)

# Definición de la caminata aleatoria: Yt = e1 + e2 + ... + et
Y <- cumsum(e)
e
Y

# Gráfica de la caminata aleatoria
plot(Y, type="l", ylim=c(-4*sqrt(sigmae*T),4*sqrt(sigmae*T)), main = "Caminata aleatoria", xlab = "t", ylab ="Yt")

# Varias simulaciones
Nsim <- 200
esim <- matrix(rnorm(T*Nsim, mean=0, sd=sigmae), nrow = Nsim)
Ysim <- apply(esim, 1, cumsum)
dim(Ysim)

for (i in (1:Nsim)){
  if (i == 1)
    plot(Ysim[,i], type="l", ylim=c(-4*sqrt(sigmae*T),4*sqrt(sigmae*T)), main = "Caminata aleatoria", xlab = "t", ylab ="Yt")
  else 
    par(new=TRUE)
    lines(Ysim[,i], type="l")
}


# ----------- Ejemplo 2: Ruido blanco con distribución t-student ----------------------

nu <- 3 #grados de libertad
etstudent <- rt(n=10^4, df = nu)
sd(etstudent) # Valor teórico de la desviación estándar es sqrt(nu/(nu-2)), para nu>2
min(etstudent)
max(etstudent)
hist(etstudent, breaks=c(min(etstudent),seq(-6,6,0.5),max(etstudent)), xlim=c(-10,10))
#hist(etstudent, breaks=c(min(etstudent),seq(-6,6,1),max(etstudent)))

# Ajuste para que el ruido blanco t-student tenga desviación estándar igual a 1
etstudent1 <- etstudent/sqrt(nu/(nu-2)) 
sd(etstudent1)
min(etstudent1)
max(etstudent1)
hist(etstudent1, breaks=c(min(etstudent),seq(-6,6,0.5),max(etstudent)), xlim=c(-10,10))

#Comparación con el ruido blanco normal
enorm <- rnorm(n=10^4, mean=0, sd=1)
min(enorm)
max(enorm)
hist(enorm, breaks=c(min(etstudent),seq(-6,6,0.5),max(etstudent)), xlim=c(-10,10))

