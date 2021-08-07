#Ej.1 Importa los datos de la base "agregados", especificando la coma decimal
setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
covid <- read.csv("agregados.csv", header = TRUE,dec = ",")

#Ej2. A partir de los datos de la base "Gasto_de_los_turistas_segun_destino_principal",
library(readxl)
gasto <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE, skip=1)

#Ej. Suma el gasto total (todos los años, todas las comunidades)
sum(gasto[,4:17])
# Suma el gasto total de cada comunidad y crea un objeto llamado "gastoporCCAA" con esos datos 
gastoporCCAA<-apply(gasto[,4:17], MARGIN = 1, FUN = sum);gastoporCCAA
#¿y el gasto total por año? Crea un objeto llamado "gastoporaño" con esos datos 
gastoporaño<-apply(gasto[,4:17], MARGIN = 2, FUN = sum);gastoporaño

#Ej.3 En este ejercicio tendréis que usar los operadores logicos
#  -¿es el gasto por CCAA menor a 100000?
gastoporCCAA < 100000
#   -¿en que comunidades autonomas?
which(gastoporCCAA< 100000)
gasto$CCAA [gastoporCCAA < 100000]

#***otras posibilidades:
#*1.
CCAA<-gasto[,3]
gastoporCCA<- apply(gasto[,4:17],1,sum)
df<- data.frame(CCAA,gastoporCCA);df
which(df<100000)
df$CCAA[gastoporCCA<100000]

#***2.
library(dplyr)
objeto<-filter(df,df$gastoporCCA<100000);objeto

#   -¿cuanto habria gastado cada una de ellas?
gastoporCCAA[gastoporCCAA< 100000]
#   -¿en que comunidades autonomas el gasto ha sido de entre 100000 y 120000?
gastoporCCAA >100000 & gastoporCCAA< 120000

#*otra opcion es con between del paquete dplyr
between(gastoporCCAA,100000,120000)
#   -¿cuanto habria gastado cada una de ellas?
gastoporCCAA[gastoporCCAA >100000 & gastoporCCAA< 120000]
#*otra opcion es con between del paquete dplyr
gastoporCCAA[between(gastoporCCAA,100000,120000)]

# Ej.4 De que clase es el objeto que has creado con los datos de gasto
class(gasto)
#   -Quédate con los datos de la comunidad autonoma de Andalucia

AND <- gasto[gasto$CCAA == "Andalucía",];AND
AND2 <- gasto[1,];AND2
#(tambien vale filter)

# Ej.5 Averigua si en alguna comunidad autonoma el gasto del 2006 ha sido igual que el gasto en 2007
gasto$Gasto_2006 == gasto$Gasto_2007
#   a) Encuenta el gasto maximo en el 2006
max(gasto$Gasto_2006)
#   b) ¿cual ha sido el gasto minimo en el 2006 y 2007?
min(gasto$Gasto_2006, gasto$Gasto_2007)

# Ej.6 Usando rep() y/o seq(), crea los siguientes vectores
#       - 0 0 0 0 0 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4
rep(seq(0,4),each=5)
rep(0:4,each=5)
#       - 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
rep(seq(1,5),times=5)
#       - 1 2 3 4 5 2 3 4 5 6 3 4 5 6 7 4 5 6 7 8 5 6 7 8 9
seq(1:5) + rep(0:4,each=5)

rep(1:5,times=5)+rep(0:4,each=5)

# Ej.7 Usa la función `paste()` para generar los codigos de un archivo con los 
# resultados de un cuestionario dividido en tres partes (A, B y C), cada una con 8 preguntas.
A <- paste("A",1:8, sep="");A#creamos los nombres de la parte A
B <- paste("B",1:8, sep="");B#creamos los nombres de la parte B
C <- paste("C",1:8, sep="");C#creamos los nombres de la parte C
cuestionario <- c(A,B,C); cuestionario#juntamos todos
# Inventa las puntuaciones obtenidas por un alumno en el cuestionario y crea un data.frame 
#donde se indique la puntuacion en cada pregunta
valores <- c(2,5,4,4,6,6,5,2,1,0,9,0,6,6,5,3,2,1,5,6,9,0,0,0)
data.frame(cuestionario,valores)

#Ej.8 Crea la logica de una respuesta Si o No a una pregunta, teniendo el no probabilidad de 0.9
respuesta <- sample(c("Yes", "No"), 100, replace = TRUE, prob = c(0.1, 0.9))
respuesta
# Comprueba que el no ha salido alrededor de 90 veces de 100 y el si alrededor de 10 veces de 100
table(respuesta)

# Ej.9 Crea un objeto que recoja los gastos en el 2008 divididos por comunidades.
g <-split(gasto$Gasto_2008, gasto$CCAA);g

library(dplyr)
gasto%>% select(3,8)

comunidades2008 <- select(gasto, CCAA, Gasto_2008);comunidades2008
