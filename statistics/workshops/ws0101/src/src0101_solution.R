library(tidyverse)
library(raster)
  
main_path <- "~/utadeo/statistics/workshops/ws0101/dat/"

# 1. Medidas de tendencia central
soil_dat_path <- paste(main_path, "appendix-b.csv", sep = "")
soil_dat <- read.csv(soil_dat_path)

soil_summary <- soil_dat %>% 
  group_by(SamplePosition) %>% 
  summarise(across(is.numeric, list(Media=mean, Median=median))) 

# 2. Medidas de dispersion
tomato_dat_path <- paste(main_path, "appendix-c.csv", sep = "")
tomato_dat <- read.csv(tomato_dat_path)

tomato_summary <- tomato_dat %>% 
  group_by(Department, DataSource) %>% 
  summarise(across(is.numeric, list(cvar=cv))) 

tomato_summary.1 <- tomato_dat %>% 
  group_by(Department) %>% 
  summarise(across(is.numeric, list(cvar=cv))) 

tomato_summary.2 <- tomato_dat %>% 
  group_by(DataSource) %>% 
  summarise(across(is.numeric, list(cvar=cv))) 


# Exporta tabla transpuesta con formato LaTeX
write.table(t(tomato_summary), "./table00.txt", 
            quote = FALSE, 
            eol = "\\\\ \n", 
            sep = " & ")

write.table(t(tomato_summary.1), "table01.txt", 
            quote = FALSE, 
            eol = "\\\\ \n", 
            sep = " & ")

write.table(t(tomato_summary.2), "table02.txt", 
            quote = FALSE, 
            eol = "\\\\ \n", 
            sep = " & ")


  
