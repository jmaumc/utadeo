library(tidyverse)
library(raster)
library(gridExtra)

main_path <- "~/utadeo/statistics/workshops/ws0102/dat/"

diabetis_path <- paste(main_path, "diabetis.csv", sep = "")
diabetis <- read.csv(diabetis_path)

# Ejercicio 1
diabetis_summary <- diabetis %>%
  group_by(class) %>%
  summarise_if(is.numeric, list(media=mean, mediana=median, coevar=cv),
               na.rm=TRUE)

# Exporta tabla transpuesta para LaTeX
diabetis_summary_path <- paste(main_path, "table01.txt", sep = "")
write.table(t(diabetis), diabetis_summary_path, 
            quote = FALSE, 
            eol = "\\\\ \n", 
            sep = " & ")

# Convierte la variable class a variable factor (discretizacion).
diabetis$class = as.factor(diabetis$class)

# Ejercicio 2
# Gráfica de dispersión para skin y mass
pl.title = "Gráfico de dispersión\nskin contra mass"
ggplot(diabetis, aes(x=skin, y=mass, color=class)) + 
  geom_point() + coord_flip() +
  # Ajuste de etiquetas
  labs(title = pl.title, 
       x = "Indice de masa corporal (Kg/m2)",
       y = "Espesor de pliegue cutáneo (mm)",
       color = "Clase\n") +
  # Ajuste de etiquetas para la leyenda
  scale_color_manual(labels = c("Negativo para\ndiabetes", 
                                "Positivo para\ndiabetes"),
                   values = c("gray", "black")) +
  # Ajuste para centrar el título
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

diabetis_subset <- diabetis %>% 
  dplyr::select(skin, mass, class) %>%
  # Reorganizo la tabla de las variables 
  gather("Variable","valores", -class)

pl.title = "Diagrama de cajas y bigotes para skin y mass\nagrupadas por class"
ggplot(data = diabetis_subset, aes(x=Variable, y=valores)) + 
  # Definimos qué gráfica deseamos hacer 
  geom_boxplot(aes(fill=class)) + 
  labs(title = pl.title) +
  # Giramos la gráfica
  coord_flip() +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

barplot(table(diabetis$mass))
barplot(table(diabetis$skin))

# Ejercicio 3
p1 <- plot(density(table(diabetis$mass)), main = "Distribución del IMC")
p2 <- plot(density(table(diabetis$skin)), main = "Distribución del espesor cutáneo")

p1 <- ggplot(diabetis, aes(x=mass)) + 
  geom_density() +
  labs(title = "Gráfico de densidad para mass") +
  theme_classic()
p2 <- ggplot(diabetis, aes(x=skin)) + 
  geom_density() +
  labs(title = "Gráfico de densidad para skin") +
  theme_classic()

grid.arrange(p1, p2, nrow = 1)

cor.test(diabetis$mass, diabetis$skin, method = "kendall")

  
