#Ej.1 Importa los datos de la base "agregados", especificando la coma decimal
datoscovid <-read.csv("https://cnecovid.isciii.es/covid19/resources/agregados.csv", header =T, dec='.')

#Ej.2 A partir de los datos de la base "Gasto_de_los_turistas_segun_destino_principal",
# Suma el gasto total (todos los a?os, todas las comunidades)
library(readxl)
library(dplyr)
excel <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE,skip=1)

x <- rowSums(excel[,4:17])
Total = sum(x)

sum(excel[,4:17])

# Suma el gasto total de cada comunidad y crea un objeto llamado "gastoporCCAA" con esos datos 
# Usar Apply
GastosCA <- apply(excel[,4:17], MARGIN = 1, FUN = sum); GastosCA

excel <- mutate(excel, gastoporCCAA = Gasto_2004 + 
                  Gasto_2005 + 
                  Gasto_2006 + 
                  Gasto_2007 + 
                  Gasto_2008 +
                  Gasto_2009 +
                  Gasto_2010 +
                  Gasto_2011 +
                  Gasto_2012 +
                  Gasto_2013 +
                  Gasto_2014 +
                  Gasto_2015 + 
                  Gasto_2016 +
                  Gasto_2017)

#?y el gasto total por a?o? Crea un objeto llamado "gastopora?o" con esos datos 
gastoanual <- rowSums(excel[,4:17])
gastoanual2 <- apply(excel[,4:17], MARGIN = 2, FUN = sum)

#Ej.3 En este ejercicio tendr?is que usar los operadores logicos
#  -?es el gasto por CCAA menor a 100000?
ca <- which(excel$gastoporCCAA < 100000)
excel$CCAA[GastosCA < 100000]

CCAA<-excel[,3]
gastoporCCA<-apply(excel[,4:17],1,sum)
df<-data.frame(CCAA,gastoporCCA); df
#which((df<100000))
#df$CCAA[gastoporCCA<100000]

library(dplyr)
objeto<-filter(df, df$gastoporCCA<100000); objeto

#   -?en que comunidades autonomas?
excel[ca,'CCAA']

#   -?cuanto habria gastado cada una de ellas?
excel[ca, c(3,20)]

#   -?en que comunidades autonomas el gasto ha sido de entre 100000 y 120000?
ca <- which(excel$gastoporCCAA > 100000 & excel$gastoporCCAA < 120000)

#   -?cuanto habria gastado cada una de ellas?
gasto <- excel[ca, c(3,20)]

# Ej.4 De que clase es el objeto que has creado con los datos de gasto
#   -Qu?date con los datos de la comunidad autonoma de Andalucia
class(gasto)

# Ej.5 Averigua si en alguna comunidad autonoma el gasto del 2006 ha sido igual que el gasto en 2007
ca <- which(excel$Gasto_2006 == excel$Gasto_2007)
excel$Gasto_2006 == excel$Gasto_2007

#   a) Encuenta el gasto maximo en el 2006
max(excel$Gasto_2006)

#   b) ?cual ha sido el gasto minimo en el 2006 y 2007?
min(excel$Gasto_2006)
min(excel$Gasto_2007)

# Ej.6 Usando rep() y/o seq(), crea los siguientes vectores
#       - 0 0 0 0 0 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4
#       - 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
#       - 1 2 3 4 5 2 3 4 5 6 3 4 5 6 7 4 5 6 7 8 5 6 7 8 9
rep(c(0, 1, 2, 3, 4), each = 5)
rep(c(1, 2, 3, 4, 5), times = 5)
seq(1:5) + rep(0:4,each=5)

# Ej.7 Usa la funci?n `paste()` para generar los codigos de un archivo con los 
# resultados de un cuestionario dividido en tres partes (A, B y C), cada una con 8 preguntas.
v2<-1:8
A <- paste('A',v2); codigos
B <- paste('B',v2); codigos
C <- paste('C',v2); codigos

codigos <- c(A, B, C); codigos



# Inventa las puntuaciones obtenidas por un alumno en el cuestionario y crea un data.frame 
#donde se indique la puntuacion en cada pregunta
notas <- sample.int(10, 24, replace=TRUE)
puntuacion  <- data.frame(pregunta=codigos, puntaje=notas); puntuacion

#Ej.8 Crea la logica de una respuesta Si o No a una pregunta, teniendo el no probabilidad de 0.9
respuesta <- sample(c("Si", "No"), 100, replace = TRUE, prob = c(0.1, 0.9)); respuesta

# Comprueba que el no ha salido alrededor de 90 veces de 100 y el si alrededor de 10 veces de 100
length(which(respuesta == 'No'))
length(which(respuesta == 'Si'))

table(respuesta)

# Ej.9 Crea un objeto que recoja los gastos en el 2008 divididos por comunidades.
ccaa2008 <- excel[,c(3, 8)]; ccaa2008

g <- split(excel$Gasto_2008, excel$CCAA); g