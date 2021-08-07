################################MODULO III EJERCICIOS

#Ej.1. Importa la base de datos "agregados.csv" y averigua que variables categoricas contiene
library(dplyr)
datosCovid <- read.csv("agregados.csv", header = TRUE)

### Muestra las frecuencias de la variable CCAA en una tabla 
table(datosCovid$CCAA)

### Muestra las frecuencias de la variable CCAA en un grafico apropiado para este tipo de datos
library(ggplot2)

datosCovid %>% 
  group_by(CCAA) %>% 
  summarise(frequency = n()) %>% 
  ggplot() +
  geom_bar(aes(x = CCAA, y = frequency), stat = 'identity')

#Ej 2. Representa la variable Hospitalizados en un histograma
h <- datosCovid %>%
  filter(!is.na(Hospitalizados)) %>%
  group_by(CCAA)

histograma <-ggplot(h, aes(Hospitalizados))
histograma + geom_histogram()
#y comparala con la distribucion normal esperada
# dibujar la curva normal

#Ej. 3. Con la base de datos "encuesta.dat", contesta a las siguientes preguntas:
encuesta <- read.table("encuesta.dat", header=T, sep="\t",dec=',')

### Observa las puntuaciones de las variables de Edad y Unidades de alcohol e intenta hacer comparaciones entre ellas
ea <-encuesta %>% 
  group_by(Edad) %>% 
  summarise(Alcohol = sum(UnidadesAlcohol))

plot <- ggplot(ea, aes(Edad, Alcohol))
plot <- plot + geom_bar(stat = "identity", position = 'dodge')
plot

### Ahora fijate en la dispersion de las notas esperadas en la PAU y las notas obtenidas, ?que puedes comentar sobre ellas?
mean(encuesta$NotaEsperada)
mean(encuesta$Nota_PAU)

matrix(c(var(encuesta$NotaEsperada), sd(encuesta$NotaEsperada),var(encuesta$Nota_PAU),sd(encuesta$Nota_PAU)), 2,2,
       dimnames = list(c("NotaEsperada", "Nota_Pau"),
                       c("Varianza","Desviacion Tipica")),byrow=T)
# No existe una dispersion considerable en ninguna de las variables

### Haz un grafico adecuado que las represente
#install.packages("tidyr")
library(tidyr)
nep = gather(data = encuesta, key = "notak", value = "notav", 13:14)

plot <- ggplot(nep, aes(id, notav, fill=notak))
plot <- plot + geom_bar(stat = "identity", position = 'dodge')
plot

#Ej. 4. Estandariza las puntuaciones de las variables fluidez en espa?ol y fluidez en ingles
fluidez<- data.frame(FluidezVerbalEspanol= encuesta$FluidezVerbalEspanol,
                     FluidezVerbalIngles = encuesta$FluidezVerbalIngles)

fluidez2<- data.frame(media= c(mean(encuesta$FluidezVerbalEspanol),mean(encuesta$FluidezVerbalIngles)),
                        desviaciontipica= c(sd(encuesta$FluidezVerbalEspanol),sd(encuesta$FluidezVerbalIngles)))
fluidez2


E<-mutate(fluidez,zscore= (fluidez$FluidezVerbalEspanol-mean(FluidezVerbalEspanol))/sd(FluidezVerbalEspanol))
(4-mean(fluidez$FluidezVerbalEspanol))/sd(fluidez$FluidezVerbalEspanol)#COMPROBACION
I<-mutate(fluidez,zscore= (fluidez$FluidezVerbalIngles-mean(FluidezVerbalIngles))/sd(FluidezVerbalIngles))

cbind(E,I[,3])
### Comenta las puntuaciones estandarizadas obtenidas con respecto a las puntuaciones directas

# Se busca la equivalencia de tener una nota de fluidez en espanol al equivalente en una nota de fluidez en ingles.



# Distribucion Muestral = a la distribucion de probabilidad de un estadistico.
# Estadistico = Forma de representar datos (Media, desviacion, t, etc.) Serie de valores.
# Distribucion de la media = Distribucion de frecuencia