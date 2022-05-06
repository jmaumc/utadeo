
# Taller 2
mu = 0
sigma = 1

#c = 1.96  --> Intervalo de confianza del 95%
c = 1.96

z <- pnorm(mu + c*sigma, mean = mu, sd = sigma) - pnorm(mu - c * sigma, mean = mu, sd = sigma)
#plot(z)

