library(TSA)
data(wages)
View(wages)
# png(file="/home/mauricio/ws03/img/wages_plot.png")
plot(wages)
# dev.off()

w <- time(wages)

model1 <- lm(wages ~ w)
print(summary(model1))

png(file = "/home/mauricio/ws03/img/wages_linear.png")
plot(wages, main = "Serie de tiempo con tendencia lineal")
points(wages, predict.lm(model1), type = "l", col = "red")
dev.off()


model2 <- lm(wages ~ w + I(w^2)) # quadratic trend
print(summary(model2))

png(file = "/home/mauricio/ws03/img/wages_cuadr.png")
plot(wages, main = "Serie de tiempo con tendencia cuadratica")
points(wages, predict.lm(model2), type = "l", col = "red")
dev.off()

png(file = "/home/mauricio/ws03/img/qqnorm_linear.png")
qqnorm(model1$residuals)
dev.off()

png(file = "/home/mauricio/ws03/img/qqnorm_cuadr.png")
qqnorm(model2$residuals)
dev.off()

png(file = "/home/mauricio/ws03/img/res_linear.png")
plot(model1$fitted, model1$residuals, main = "Residuales vs Ajuste", xlab = "Ajuste", ylab = "Residuales")
dev.off()


png(file = "/home/mauricio/ws03/img/res_cuadr.png")
plot(model2$fitted, model2$residuals, main = "Residuales vs Ajuste", xlab = "Ajuste", ylab = "Residuales")
dev.off()
