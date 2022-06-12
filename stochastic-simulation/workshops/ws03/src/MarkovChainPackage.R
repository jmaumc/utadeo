install.packages("expm")
install.packages("markovchain")

#----CREATING "markovchain" OBJECTS----

library("markovchain")

#-- Create a Markov Chain for weather --

mcWeather <- new("markovchain", states = c("A", "N", "T"),
		transitionMatrix = matrix(data = c(0.5, 0.4, 0.1, 0.3, 0.4, 0.3, 0.2, 0.3, 0.5),
		byrow = TRUE, nrow = 3), name = "Weather")

show(mcWeather)
print(mcWeather)

library("igraph")
plot(mcWeather)
#plot(mcWeather, package="diagram", box.size = 0.04)

states(mcWeather)
names(mcWeather)
dim(mcWeather)
name(mcWeather)

#-- Initial State = Cloudy with probability 1 --

initialState <- c(0, 1, 0)

#-- State after 2 days --

after2Days <- initialState * (mcWeather * mcWeather)
after2Days

#-- State after 7 days

after7Days <- initialState * (mcWeather ^ 7)
after7Days

transitionProbability(mcWeather, "cloudy", "rain")
mcWeather[2,3]

steadyStates(mcWeather)

summary(mcWeather)

#---Simulation---

weathersOfDays <- rmarkovchain(n = 365, object = mcWeather, t0 = "sunny")
weathersOfDays[1:365]

#---Fitting with MLE----

weatherFittedMLE <- markovchainFit(data = weathersOfDays, method = "mle", 
			name = "Weather MLE")
weatherFittedMLE$estimate
weatherFittedMLE$standardError

#----Fitting with Laplace smoothing---

weatherFittedLAPLACE <- markovchainFit(data = weathersOfDays,
  method = "laplace", laplacian = 0.01,name = "Weather LAPLACE")
weatherFittedLAPLACE$estimate
weatherFittedLAPLACE$standardError

#----Fitting with bootstrap---

weatherFittedBOOT <- markovchainFit(data = weathersOfDays,
			method = "bootstrap", nboot = 100)
weatherFittedBOOT$estimate
weatherFittedBOOT$standardError

#-----Assessing the Markov property of a Markov chain sequence----

verifyMarkovProperty(weathersOfDays)
assessOrder(weathersOfDays)
assessStationarity(weathersOfDays, 3)




#---using Alofi rainfall dataset

data(rain)
mysequence<-rain$rain
show(mysequence)

createSequenceMatrix(mysequence)
myFit<-markovchainFit(data=mysequence,method = "mle")
myFit$estimate
myFit$standardError

verifyMarkovProperty(mysequence)
assessOrder(mysequence)
assessStationarity(mysequence, 4)
