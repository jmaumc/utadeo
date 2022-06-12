sigmae <- 1
nu <- 3 # freedom degrees
etstudent <- rt(n = 10^4, df = nu)
sd(etstudent) # Theoretical value for sd es sqrt(nu/(nu-2)), with nu>2
min(etstudent)
max(etstudent)
hist(etstudent,
    main = "Histograma ruido blanco t-student",
    breaks = c(min(etstudent), seq(-6, 6, 0.5), max(etstudent)),
    xlim = c(-10, 10), plot = TRUE
)

etstudent1 <- etstudent / sqrt(nu / (nu - 2))
sd(etstudent1)
print(min(etstudent1))
print(max(etstudent1))
# hist(etstudent1,
#    breaks = c(min(etstudent), seq(-6, 6, 0.5), max(etstudent)),
#    xlim = c(-10, 10)
# )

enorm <- rnorm(n = 10^4, mean = 0, sd = 1)
print(min(enorm))
print(max(enorm))
# hist(enorm,
#    breaks = c(min(etstudent), seq(-6, 6, 0.5), max(etstudent)),
#    xlim = c(-10, 10)
# )


# Varias simulaciones
Nsim <- 200
esim <- matrix(etstudent, nrow = Nsim)
Ysim <- apply(esim, 1, cumsum)
dim(Ysim)

for (i in (1:Nsim)) {
    if (i == 1) {
        plot(Ysim[, i],
            type = "l", ylim = c(
                -4 * sqrt(sigmae * T),
                4 * sqrt(sigmae * T)
            ), main = "Caminata aleatoria",
            xlab = "t", ylab = "Yt"
        )
    } else {
        par(new = TRUE)
    }
    lines(Ysim[, i], type = "l")
}
