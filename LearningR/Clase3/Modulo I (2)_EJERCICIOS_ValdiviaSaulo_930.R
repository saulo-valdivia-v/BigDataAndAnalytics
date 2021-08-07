# Ej.1 Instalar el paquete ggplot2 con codigo
install.packages("ggplot2")

# Ej.2 Explorar el paquete dplyr con el siguiente codigo. ?Que nos permite hacer cada una de sus funciones?
library("dplyr")
?select
?filter
?arrange
?mutate
?summarise
?group_by

# Ej.3 Averigua tu directorio de trabajo. 
#       Despu?s crea una carpeta llamada B dentro de tu directorio. 
#       Situate en B (establecelo como directorio de trabajo)
getwd()
dir.create(paste(getwd(), "/B", sep=""))
setwd(paste(getwd(), "/B", sep=""))

# Ej.4?C?mo podemos acceder a los datos de la Comunidad Autonoma de Andalucia en la base 'agregados'?
datoscovid <-read.csv("https://cnecovid.isciii.es/covid19/resources/agregados.csv", header =T)
AN<-datoscovid[(datoscovid$CCAA=="AN"),]

# Ej5. Importar la base de datos Gasto de turistas (Excel) manteniendo el nombre de las variables.
#       Accede a alguna de las variables presentes en esa base de datos y explora sus cualidades
library(readxl)
excel <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE,skip=1)
summary(excel)

# Ej6.Averigua las caracteristicas de la variable PCR del archivo agregados
summary(datoscovid$PCR.)
head(datoscovid)
str(datoscovid)

#Accede al elemento 2 de la variable
datoscovid$PCR.[2]

#Mostrar los elemento 3, 4 y 9
datoscovid$PCR.[c(3:4,9)]

#Mostrar todos los elementos menos el 5
datoscovid$PCR.[-5]

#Calcula la proporcion de datos que pertenecen a la Comunidad de Madrid
datosCovid <- datoscovid[1:1729,]
Madrid <-datoscovid[(datoscovid$CCAA=="CM"),]

prop = (count(Madrid)*100) / 1729; prop
sum(comunidades=="CM")/lenght(comunidades)
prop.table(table(CCAA=="CM"))

# Ej.7 Observa el entorno de trabajo, 

#       - ?En que directorio estan situados los objetos presentes?
getwd()
ls()

#       - borra alguno de los objetos presentes.
rm(AN)