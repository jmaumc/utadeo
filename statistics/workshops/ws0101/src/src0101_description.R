# Cargo la liberia que voy a emplear en este caso tidyverse
# Nota: Si lo ha han descargado deber hacerlo desde la pestaña "packages"

library(tidyverse)

# Importo los datos con los que voy a trabajar, en este caso el apendice C
Systems<-read.csv("~/utadeo/statistics/workshops/ws0101/dat/appendix-c.csv")

# Es aconsejable verificar la correcta importación de la tabla de datos a R, recomiendo usar:
head(Systems, n=6) ### El encabezado de los datos, con n pueden modificar el numero de registros que quieren verificar
tail(Systems, n=6) ### Para ver el final "cola" de la tabla de datos 
View(Systems) ### Permite ver los primeros 1000 registros de la tabla de datos en una ventana independiente

# ----------------------------------------------------------------------------------------------------------- #
# Punto 1. Realizaremos un resumen de las variables numéricas por medio del calculo de la 
# media y la mediana para cada sistema de producción y método de recolección de la información

P1<-Systems %>% 
  group_by(Department, DataSource) %>% 
  summarise_if(is.numeric, list(Media=mean, Mediana=median), na.rm = TRUE) %>% data.frame

# ----------------------------------------------------------------------------------------------------------- #
# Punto 2. Ahora usaremos los datos del apéndice C para describir el nivel de variación 
# al interior del conjunto de datos, para poder establecer una comparación entre las diferentes 
# variables lo haremos por medio del coeficiente de variación.

# La librería raster tiene incorporada un función para hacer de manera directa el calculo del 
# coeficiente de varaición.

library(raster)

P2<-Systems %>% 
  group_by(Department, DataSource) %>% 
  summarise_if(is.numeric, cv) %>% data.frame

# ----------------------------------------------------------------------------------------------------------- #
# Punto 3. Elaboremos una gráfica en la cual podamos comparar el promedio del rendimiento en cada uno 
# de los municipios, pero teniendo en cuenta unas consideraciones:
  
#•	Primero, solo trabajaremos con los datos de rendimiento que provienen de los seguimientos 
#•	Segundo, excluiremos los datos del municipio de Valle de San José por tener 
#   muy pocas observaciones 
#•	Tercero, la medida de tendencia central que usaremos será media y la de 
#   dispersión será la desviación estándar.

Data<-Systems %>% 
  # Filtro los datos de los seguimientos
  filter(DataSource=="FollowUps") %>%
  # Seleccionamos solo las variables de interes: el departamento, la municipalidad y el rendimiento
  dplyr::select(Department, Municipality, Yield.kg.m2) %>%
  # Filtro los datos para excluir (!=) los que corresponden al municipio de Valle de San Jose
  filter(Municipality!="ValleSanJose") %>% 
  group_by(Department, Municipality) %>%
  # Calculo el promedio y la desviación estándar para cada municipalidad en cada departamento
  summarise_each(funs(Promedio=mean(Yield.kg.m2),
                      Desviacion=sd(Yield.kg.m2)))

## Ahora la gráfica
ggplot(Data,aes(x=Municipality, y=Promedio,fill=Department, group=Department)) + 
  theme_bw()+
  geom_bar(stat="identity",position=position_dodge())+
  geom_errorbar(aes(ymin=Promedio-Desviacion,ymax=Promedio+Desviacion),width=.2,position=position_dodge(.9))

# ----------------------------------------------------------------------------------------------------------- #
# P4. Hagamos un diagrama de cajas y bigotes para describir la manera como se distribuye 
# o agrupan los datos. En esta ocasión empleemos los datos del anexo A. Estos datos corresponden 
# a los resultados de análisis de suelos realizados en las dos áreas productoras de tomate: Santander 
# y Boyacá. En este caso estamos interesados en describir el comportamiento de las variables: acidez (pH), 
# conductividad eléctrica (EC.dSm) contenido de nitrógeno amoniacal (NH4.ppm) y nítrico (NO3.ppm), potasio 
# (K2O.ppm), fósforo (P2O5.ppm), carbono orgánico (SOC.pct) y contenido de arenas (Sand.pct); por 
# departamento o zona de producción. Ver código en R.

# Importo los datos del anexo A
Soil0<-read.csv("~/utadeo/statistics/workshops/ws0101/dat/appendix-a.csv")

# Selecciono las variables en las cuales tengo interés 
Soil<-Soil0 %>% dplyr::select(Department, pH:Sand.pct, Slope.pct) %>%
  # Reorganizo la tabla de las variables 
  gather("Variable","value", -Department)

# Pasamos al elaboración de la gráfica
ggplot(data = Soil, aes(x=Variable, y=value)) + 
  # Definimos qué gráfica deseamos hacer 
  geom_boxplot(aes(fill=Department)) + 
  # Giramos la gráfica
  coord_flip()+
  # Repetimos la misma gráfica para cada una de las variables
  facet_wrap( ~ Variable, scales="free", ncol =3)


