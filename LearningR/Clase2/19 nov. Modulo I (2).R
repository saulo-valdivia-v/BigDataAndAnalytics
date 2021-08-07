################################MODULO I PRIMEROS PASOS CON R (II): manejo de datos y bases de datos

#***************************************Otros objetos de R

#FUNCIONES: objetos de R con los que podemos operar
###es posible crear funciones propias usando el lenguaje de programaci?n
###o utilizar funciones ya creadas
a <- -1:4
sqrt(a)     # Raiz cuadrada de cada numero de a

#PAQUETES
###?Donde podemos encontrar las funciones ya creadas?
###en la instalacion base de R o en PAQUETES
###los paquetes son conjuntos de funciones. Para su uso:

#1. descargar el paquete e instalarlo
install.packages("nombre del paquete")   
#2.cargar el paquete en la memoria
library("nombre del paquete")             

###O en Menu "packages"-> Install, escribir el paquete e instalarlo
#En la consola se muestra el progreso, cualquier error que pueda surgir
#o paquete que debe instalarse previamente para que el paquete que queremos funcione

###Algunos paquetes utiles:
install.packages("stats") #funciones estadisticas
install.packages("dplyr") #manipulaci?n y operaciones con data frames
install.packages("ggplot2") #creacion de graficos avanzados
install.packages("tidyverse") #conjunto de paquetes para manejar, transformar, and visualizar datos
#https://www.rdocumentation.org/packages/tidyverse/versions/1.3.0
library("stats")
library("dplyr")
library("ggplot2")
library("tidyverse")

#**********************************************************DIRECTORIO

###Es necesario saber en qu? directorio estamos trabajando (sobre todo para importar y exportar archivos)
getwd()#directorio de trabajo actual
#o simplemete mirar en la Consola

#para modificarlo
setwd("ruta del directorio")
#o poner un nuevo Default directory: "Tools" -> "Global Options"-> "General" ->"R Sessions" 

#Puedo listar todos los elementos que existen en el WD con las siguientes funciones
dir()#ver archivos del directorio
list.files()#ver archivos del directorio
#y la flecha de al lado de 'Console' nos da acceso a esos archivos

file.info("Gasto_de_los_turistas_segun_destino_principal.xlsx") #me permite obtener informacion de un archivo como su peso o fecha de creacion, por ejemplo
?file.info # para ver los detalles de que es cada columna

#***********************************************************IMPORTAR DATOS

### A la hora de trabajar con bases de datos en R es MUY imporante preparar los datos previamente
###Para importar: podemos usar los menus: Environment -> Import Dataset
read.csv(file.choose())
###o el codigo (permite mayor control)

###Existen paquetes especificos para cada tipo de archivo
## ver http://www.statmethods.net/input/importingdata.html
library(Hmisc)#SPSS
library(readxl)#Excel...
library(googlesheets)

#CONSEJO! antes de importar a R es mejor transformar los datos a un 
#archivo de datos separado por comas (.csv) o tabulador (.txt) y usar read.csv o read.delim para importar
#(si se usa la coma como dicimal: usar read.delim2 o read.csv2)
# ver http://cran.r-project.org/doc/manuals/r-release/R-data.html

#Leemos un archivo de datos
#si importo desde la web
datos.covid <-read.csv("https://cnecovid.isciii.es/covid19/resources/agregados.csv", header =T)
#si importo desde mi carpeta
Ejemplo_CSV <- read.csv("agregados.csv", header = TRUE)
Ejemplo_CSV <- as.data.frame(Ejemplo_CSV)
Ejemplo_CSV <- as.data.frame(read.csv("agregados.csv", header = TRUE))

library(readxl)
help(read_excel)#leer todas las opciones que nos da esta funcion
excel <- read_excel('nombrearchivo.xlsx',sheet = "puedo elegir una hoja especifica", range = cell_cols("tambien rango de celdas"), col_names = TRUE)
excel <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE)
#aparece en Console un texto en rojo de New Names
View(excel) #nos damos cuenta que la primera fila que deberia tener los nombres de las columnas estaba vacia
#Muchas veces sucede que al importar un archivo necesitamos excluir filas iniciales porque no tienen info de valor
#Para ello existe el parametro skip, que me permite excluir la cantidad de filas que desee

#Probamos de nuevo
Archivo_excel <- read_excel("Gasto_de_los_turistas_segun_destino_principal.xlsx", col_names = TRUE, skip = 1)
#en Console no ha aparecido  mensaje de error
View(Archivo_excel)

#para inspeccionar los datos importados:
head(Archivo_excel)
tail(Archivo_excel)#no nos es muy util en este archivo
head(Ejemplo_CSV)
head(Ejemplo_CSV, n=10)# le podemos espepecificar el n? de lineas que queremos ver
tail(Ejemplo_CSV)

# casting a column from char to numeric
Archivo_excel$Shape__Area <- as.numeric(Archivo_excel$Shape__Area)

length(Archivo_excel)
length(Ejemplo_CSV)
dim(Archivo_excel)

str(Archivo_excel)#muestra todas las variables y de que tipo son
summary(Archivo_excel)#muestra los descriptivos basicos de todas las variables 
summary(Archivo_excel$Gasto_2011)
summary(Ejemplo_CSV) #?que ocurre con estos descriptivos en las variables categoricas?

#habria que mirar que cada variable la toma como debe (numerica, caracter...)
#Archivo_excel$
class(Archivo_excel$Gasto_2004)
str(Archivo_excel$Gasto_2004)
levels(Archivo_excel$Gasto_2004)   #es tan solo un vector con numeros por lo que no tiene niveles
#?que variable podria tener niveles??por que?

summary(Archivo_excel$Gasto_2004)

#?c?mo podemos saber si hay datos perdidos en mi base?
Ejemplo_CSV <-read.csv("https://cnecovid.isciii.es/covid19/resources/agregados.csv", header =T)
is.na(Ejemplo_CSV)
summary (Ejemplo_CSV)#mas comodo que el anterior porque nos lo 
#indica por variables

setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
library(readxl)
excel2 <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE,skip=1)
is.na(excel2)
summary(excel2)

is.na(excel2$Gasto_2005)
mean (excel2$Gasto_2005) #como la variable tiene un NA, no nos hace el calculo
mean (excel2$Gasto_2005, na.rm=T) #este comando lo podemos usar en muchas otras funciones
#para que no tenga en cuenta este tipo de valores


na.omit(excel2)#vemos que ha borrado las lineas con valores perdidos

excel2 <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE,skip=1)
excel2$Gasto_2005[is.na(excel2$Gasto_2005)]<-999; print(excel2)  # Sustitucion de valores perdidos

#Otra forma de importar datos es copiandolos desde el archivo original y usando la opcion 'clipboard'
my_data <- read.table(file = "clipboard")#nos da error porque no le hemos dicho como es la estructura de nuestros datos
my_data <- read.table(file = "clipboard", 
                      sep = "\t", header=TRUE)


#***********************************MODIFICAR Y EXPORTAR DATOS
###Hemos visto con tail() que al final de los datos del COVID hay comentarios que no nos interesan
tail(Ejemplo_CSV)

#asi que eliminamos esas filas
datoscovid<-Ejemplo_CSV[1:1729,]
# otra forma de hacerlo es esta:
datoscovid<-Ejemplo_CSV[-(1730:1738),]

### CREAMOS UN OBJETO solo CON LOS DATOS COVID DE LA COMUNIDAD DE MADRID
# DEBEMOS FILTRAR LAS FILAS CUYA VARIABLE CCAA SEA CM:
CM<-datoscovid[(datoscovid$CCAA=="CM"),] 
#(ver otro tipo de operadores logicos en PPT)

#GUARDAMOS EL RESULADO EN un nuevo ARCHIVO llamado "datoscovidCM.csv"
write.csv(CM, "datoscovidCM.csv")

CM2<-read.csv("datoscovidCM.csv", header=T,sep=',')#comprobamos que se importa bien
#CUIDADO: mirar en el global environment ?que ha pasado?

# vemos que tiene una variable m?s que CM y es porque est? tomando el n? de fila 
#como una columna mas. Para quitarla podemos hacer simplemente lo siguiente:
CM2<-CM2[,-1]

#------------------------------------
###Tenemos el Global environment demasiado lleno
ls()#ver los objetos del epacio de trabajo
rm(CM)#borrar un objeto que ya no quedamos

#rm(list=ls()) #borrar todos los objetos del espacio de trabajo

