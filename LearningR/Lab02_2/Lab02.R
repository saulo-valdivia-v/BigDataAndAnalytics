# ESTADISTICA DESCRIPTIVA CON R

# R COMO CALCULADORA

# Ejercicio 1

2+3
15-7
4*6
13/5
3^2
13%/%5 #
13%%5 # 
1/3+1/5
(1/3)+(1/5)
sqrt(25)
sqrt(26)
sin(pi)
sin(3.14)

# Visitar http://es.wikipedia.org/wiki/Notacion_cientifica
# Utiliza parentesis para indicar la prioridad de los operdores 

# DETALLES DE LA INTERFACE RStudio 

3* # simbolo + para comandos incompletos y Esc para salir a simbolo > siguiente comando

# mensajes de error

4/*3 #unexpected
2/0 #Inf
3*(-5/(4-2^2)) #-Inf
log (0) #-Inf
sqrt(-4) #NaN 
(1/0)+log(0) #NaN

# Teclado 

# Editor ()
# Consola (Console, Terminal, Jobs)
# Entorno (Environment, History, Connections,Tutorial)
# Asistencia (Files, Plots, Help, Viewer)
# Probar teclas arriba y abajo, para sacar ultimos comandos 
# Probar Crtl + L para la limpieza de comandos de la consola, que permanecen en el historial

# VARIABLES

# Ejercicio 2

# Asignacion de valores a variables

# Variables cuantitativas, que guardan numeros
a = 2
b = 3
c = a + b
a = b * c
b = (c - a)^2
c = a * b
a;b;c

a <- 2
b <- 3
c <- a + b
a <- b * c
b <- (c - a)^2
c <- a * b
a;b;c

# Variables cualitativas, que guardan cadenas alfanumericas
pronostico = "Leve"
pronostico
pronostico2 <- "Grave"
pronostico2

# para ver los resultados directamente rodeamos con un parentesis las (asignaciones)
d = 5
(a = b * c^2 / d + 3)
#conviene utilizar nombres descriptivos, cortos y coherentes
espacio = 2
tiempo = 3
(velocidad = espacio / tiempo)

# VECTORES

# creaci贸n
edades = c(22, 21, 18, 19, 17, 21, 18, 20, 17, 18, 17, 22, 20, 19, 18, 19, 18, 22, 20, 19)
edades
(edades = c(22, 21, 18, 19, 17, 21, 18, 20, 17, 18, 17, 22, 20, 19, 18, 19, 18, 22, 20, 19))

# Concatenaci贸n
(edades2 = c(22, 18, 20, 21, 20))
(edades = c(edades, edades2) )

# Vectores desde ficheros CSV

# Ejercicio 3

# Localiza el fichero Lab02-Edades.csv y abrelo con el bloc de notas 
# Comprueba que el 铿乧hero contiene s贸lo una columna de datos
# Usa el men煤 Session, Set Working Directory, Choose Directory para escoges la carpeta donde esta el fichero
# En la consola aprecer谩 setwd("\directorio\carpeta") para indicar la ruta de la carpeta de trabajo
# Asegurate de que todos los ficheros de este laboratorio estan esta carpeta de trabajo

# Ejercicio 4
# Dos tipos de ficheros. Uno solo columna (read.table) y otro solo fila (scan)

# Lectura de un fichero CSV con una columna de datos
(vectorEdades = read.table("Lab02-Edades.csv", header = FALSE)[,1])

# Probar la asistencia Tab y la ayuda F1 de RStudio con la funcion scan
?scan ()

# Lectura de un fichero CSV con una fila de datos separados por comas
(vectorEdades2 = scan(file = "Lab02-Edades2.csv",sep=","))

# Ejercicio 5
# La escritura tb se da para filas y columnas. write.table escribe en columna

# Escritura de un vector en un fichero CSV con una fila de datos separados por comas
muestra = c(29, 17, 63, 31, 55, 9, 92, 61, 10, 16, 63, 6, 61, 59, 66, 41, 68, 6, 99, 21, 87, 68, 52, 83, 66, 98, 45, 50,
            24, 100, 83, 37, 44, 4, 97, 67, 56, 74, 75, 71, 55, 22, 86, 22, 93, 65, 38, 84, 54, 83, 100, 71, 99, 19,
            63, 11, 11, 62, 91, 20, 79, 42, 59, 95, 70, 74, 8, 25, 45, 58, 57, 75, 81, 34, 70, 68, 39, 12, 14, 21)
write.table (muestra,file = "Lab02-muestra.csv", col.names=FALSE, row.names=FALSE)
# Comprueba que se ha creado el fichero Lab02-muestra.csv, abrelo con el bloc de notas e inspeccionalo

# ARITMETICA VECTORIAL

# Ejercicio 6

vector1 = c(8, 5, 19, 9, 17, 2, 28, 18, 3, 4, 19, 1)
# Para cargar el vector2 asegurate de que esta en la carpeta de trabajo.
(vector2 = scan(file="Lab02-vector2.csv",sep=";") )
( vector1 + vector2 )
( vector1 * vector2 )
( vector1 + 5 )
( 2 * vector1 )
( log(vector1) )
( logVector1 = log(vector1) )

# Ejercicio 7

# Generando vectores de numeros enteros consecutivos
1:15
-7:13
1.5:7.5

# Generar un vector con los cuadrados de los numeros del 1 al 10 y asignarlo a la variable cuadrados
# Generar un vector con los cuadrados de los numeros del 2 al 11 y asignarlo a la variable cuadrados2.
# Resta los vectores cuadrados2 - cuadrados. 驴Observas algo interesante?
(cuadrados = (1:10)^2 )
(cuadrados2 = (2:11)^2 )
cuadrados2 - cuadrados

# Ejercicio 8

# Funciones vectoriales

# Numero de elementos de un vector 
length(-7:13)
length(vectorEdades)

# Suma de los elementos de un vector
sum (-7:13)
sum (vectorEdades)

# Suma de los cuadrados del numeros del 1 al 100 
sum((1:10)^2)


# Ejercicio 9

# Calculo de estad铆sticos con funciones vectoriales
# Lectura con scan de un fichero CSV con una columna de datos 
vectorEdades = scan(file="Lab02-Edades.csv")
# Asignar el tama駉 del vector
( n = length(vectorEdades))
# Asignar la media del vector
( mediaEdades = sum(vectorEdades) / n )
# Asignar la varianza poblacional del vector
( varEdades = sum( ( vectorEdades - mediaEdades )^2) / n )
# Asignar la desviaci贸n tipica poblacional del vector
( desvTipicaEdades = sqrt(varEdades))
# Asignar la varianza muestral del vector
( cuasiVarEdades = sum( ( vectorEdades - mediaEdades )^2) / (n - 1) )
# Asignar la desviaci贸n tipica muestral del vector
( cuasiDesvTipicaEdades = sqrt(cuasiVarEdades))


# ESTADISTICA DESCRIPTIVA CON COMANDOS DE R

# Ejercicio 10

# Para eliminar todos los objetos del entorno
rm(list=ls())
rm(cuadrados2)

# Comprueba que directorio de trabajo debe contener el fichero Lab02-var3.csv e investiga el contenido de este fichero
var3 = scan("Lab02-var3.csv")
var3

# Funciones minimo, maximo y rango de un vector
(minimo = min(var3)) 
(maximo = max(var3)) 
(rango = range(var3))

# Ejercicio 11 

# TABLAS

# Crear el objeto tabla de frecuencias absolutas
(tablaFrecAbs = table(var3))

# Comprobar los par谩metros del objeto
tablaFrecAbs
length(tablaFrecAbs)
sum(tablaFrecAbs)
min(tablaFrecAbs)
max(tablaFrecAbs)
range(tablaFrecAbs)


#Ejercicio 12

# Averiguar de que clase (vector, tabla, etc) es un objeto
class(var3) 
class(tablaFrecAbs)

# Crear el objeto tabla de frecuencias relativas
(n = length( var3 )) 
(tablaFrecRel = tablaFrecAbs / n )
sum(tablaFrecRel)

# Ejercicio 13

# Crear los objetos tablas de frecuencias acumuladas, absolutas y relativas
(tablaFrecAbsAcu = cumsum(tablaFrecAbs))
(tablaFrecRelAcu = cumsum(tablaFrecRel)) 
(tablaFrecRelAcu = (tablaFrecAcu / n))
(tablaFrecRelAcu2 = (tablaFrecAcu / n)*100)

# Ejercicio 14
# Los graficos se realizan usando Tablas
# Cada grafico en una ventana de Plots
pie(tablaFrecAbs) 

# Probar la funcion de graficos de barras de una tabla
barplot(tablaFrecAbs) # Funcion de Densidad
barplot(tablaFrecAbsAcu) # Funcion de Distribucion
barplot(tablaFrecAbs, col = heat.colors(15))

# Probar la funcion de histogramas de una variable
hist(var3, col = heat.colors(15))

# Probar la funcion de graficos de cajas con bigotes
boxplot(var3)
boxplot(var3, horizontal=TRUE)
boxplot(var3, outline = FALSE)

# Ejercicio 15

# Para ver los argumentos y posibles los valores de la funcion:
?boxplot() 
# Estos dos comandos dan el mismo resultado:
boxplot(var3, horizontal = TRUE, outline = FALSE)
boxplot(var3, outline = FALSE, horizontal = TRUE)
# Este comando aplica los valores de los argumentos por defecto:
boxplot(var3, TRUE, FALSE)
# Este comando adorna el ultimo gr谩fico realizado con un marco ancho:
box(lwd=5)
# Para ver los argumentos y posibles los valores de la funci贸n:
?box()
# Este comando comopone el grafico con lineas anchas:
boxplot(var3, horizontal = TRUE, outline = FALSE, lwd=5)

# Ejercicio 16

# Probar la funcion media aritmetica de un vector leido de un fichero del subdirectorio de trabajo
vectorEdades = scan(file="Lab02-Edades.csv")
(mediaEdades = mean(vectorEdades)) 
(mediaVar3 = mean(var3)) 
# Calcular la media sin la funcion, operando con vectores y ver que coincide
(mediaVar3 = sum(var3)/length(var3))

# Ejercicio 17
# Se realizan dos interpretaciones (estadistica y negocio)
# Probar las funciones desviacion tipica y varianza muestral 
(varMuestral = var(var3))
(desvTipMuestral = sd(var3))
# Comprobar que la varianza es el cuadrdo de la desviacion tipica  
sqrt(varMuestral)
# Calcular la varianza y desviacion tipica poblacional
(varPobl= ((n-1) / n) * varMuestral)
(desvTipPobl = sqrt( varPobl))

# Ejercicio 18
# 1er cuartil 25% < 4 anios y 75% > 4 anios
# 3er cuartil 
# Mediana = cuartil 50
# Para investigar la clase de objeto que genera una funcion
summary(var3)
class(summary(var3))
# funciones de medidas de posicion: mediana, cuartiles, rango intercuartilico
# y algunos percentiles, calculados con el metodo por defecto  
(mediana = median(var3))
quantile (var3)
(rangoIntCuart= IQR(var3))
(percentiles = quantile(var3, c(0.05, 0.15, 0.58, 0.75)))

# FICHEROS Y COMANDOS EN EL EDITOR, CONSOLA E HISTORIAL

# Ejercicio 19

# Localiza el editor en la ventana superior izquierda y carga el fichero Lab02-codigo01.R
# Pon el curso en una linea del fichero cargado y ejecutala con Ctrl+Enter o con el boton Run
# Hazlo tambien con varias l铆neas seguidas seleccionadas con el cursor

# Ejercicio 20

# Prueba los botones Run y Source del Editor
# Prueba los aumentadores y reductores de todas las ventanas (esquina superior derecha)


# Ejercicio 21

# Cambia las filas 1 y 3 por: 
(vector1 = 1:50 )
(vector2 = sample(1:50) )
# a帽ade en la fila 11: 
(varMuestral = var(vector3) )
# Salva el fichero con un nuevo nombre, utilizando los comandos File, Save as (o con el boton disco)
# Cierra el fichero con un nuevo nombre, utilizando los comandos File, Close (o con boton X)
# Prueba el boton Disquete de Environment (Save Workspace)
# Prueba el boton Escobilla de Environment (Clear Workspace)
# Prueba el boton Carpeta de Environment (Load Workspace)

# OPERACIONES CON VECTORES EN R

# Ejercicio 22

# Probar la funcion de generacion de vectores con numeros pseudaleatorios
(dado=sample(1:6, size=1)) # un dado, sin remplazamiento
(dado2=sample(1:6, size=2)) # dos dados sin remplazamiento
(dado2=sample(1:6, size=7)) # dos dados sin remplazamiento
(dado = sample(1:6, size=1000)) # da error, porque es imposible sin remplazamiento

(dado = sample(1:6, size=1000, replace = TRUE)) # 1000 dados, con remplazamiento
table(dado)
class(dado)

# Control de la funcion sample
edades = c(22, 21, 18, 19, 17, 21, 18, 20, 17, 18, 17, 22, 20, 19, 18, 19, 18, 22, 20, 19)
(edadesAlAzar = sample(edades, size=7, replace=FALSE)) # sin remplazamiento
(edadesAlAzar = sample(edades, size=7, replace=TRUE)) # con remplazamiento
length (edades) # permutaciones de todas las edades del vector
sample(1:20) # permutaciones de todas las edades del vector

# Probar la funcion unique, que crea un vector con los valores distintos que hay en otro
(edadesDistintas=unique(edades))
# Probar la funcion sort, que crea un vector con los valores de otro pero ordenados
(edadesOrdenadasA = sort(edades))
(edadesOrdenadasD = sort(edades, decreasing= TRUE))

# Ejercicio 23

# Probar los vectores mayusculas y mayusculas, que estan predefidos en R
letters
LETTERS

# Para extraer una clave aleatoria de 15 caracteres con numeros, mayusculas y minusculas 
(Clave = sample(c(LETTERS, letters, 0:9), size=15, replace=TRUE))
paste(Clave, collapse="")

# Ejercicio 24

# numeros pseudoaleatorios
sample(1:100, size=15, replace=TRUE)
sample(1:100, size=15, replace=TRUE)

# numeros pseudoaleatoriosn pero reproducibles
set.seed(2020)
sample(1:100, size=15, replace=TRUE)
set.seed(2020)
sample(1:100, size=15, replace=TRUE)

# Vectores a medida con seq y rep

(numerosSeguidos = c(1:100))

# Probar la funcion seq (secuencia)
(deTresEnTres = seq(from =1, to=100, by=3))
(deTresEnTres = seq(1, 100, 3)) # utilizando el defecto de la funcion
# Para dividir el intevalo 15, 27 en 19 subintervalos iguales
(nodos=seq(from=15 , to=27 , length.out=20))

# Probar la funcion rep (repeticion)
valores = c(1,2,3,4,5)
rep(valores, times=3)
length(rep(valores, times =3))

rep(valores, times=c(2, 9, 1, 4, 3))
length(rep(valores, times=c(2, 9, 1, 4, 3)))

# seleccion de elementos de vectores

set.seed(2020)
dado = sample(1:6, size=1000, replace = TRUE)
dado
table (dado)

dado [23] # la tirada numero 23
dado [1] # el primero
dado [length(dado)] # el ultimo

# valores del principio y del final de un vector
head (dado)  # solo los 6 primeros
tail (dado)  # solo ls 6 ultimos
head(dado, 1) # el primer elemento
tail(dado, 10) # los diez ultimos elementos

dado [12:27] # valoras de las posiciones de la 12 a la 27 
dado[c(3,8,21,43,56)] # valores de las posiciones 3,8,21,43,56

# intenta averiguar que vamos a conseguir con estos comandos 

datos=100:200
datos
datos[seq(1,length(datos),3)]


# Seleccion de elementos mediante condiciones. Valores booleanos. Funcion which.

dado > 3 # vector booleano
head( dado < 3, n=10)
head( dado , n=10)
mayoresQue3 = dado[ dado > 3 ]
mayoresQue3

which( dado > 3 ) # vector con las posiciones de los valores de dado mayores que 3
head( which( dado > 3 ), n=10)
head(dado, n=20)


# Ejercicio 25

dado[16] # valor de dado de la posicion 16
masoIgualQue2 = dado[dado>=2] # valores de dado mayores o iguales a 2
head(masoIgualQue2) # solo las 6 primeros valores anteriores
pares = dado[dado%%2==0] # valores de dado que son pares
head(pares) # solo los 6 primeros valores del vector anterior

# valores booleanos como unos y ceros. Operadores booleanos.

# operador AND 

TRUE & TRUE # (3 < 5) & (4 < 6)
TRUE & FALSE # (3 < 5) & (6 < 4)
FALSE & TRUE # (5 < 3) & (4 < 6)
FALSE & FALSE # (5 < 3) & (6 < 4)

# operador OR 

TRUE | TRUE # (3 < 5) | (4 < 6)
TRUE | FALSE # (3 < 5) | (6 < 4)
FALSE | TRUE # (5 < 3) | (4 < 6)
FALSE | FALSE # (5 < 3) | (6 < 4)

# R convierte TRUE en 1 y FALSE en 0
# R convierte 0 en FALSE y cualquier otro numero en 1

3 & 5
0 & 3
0 | 2
0 | 0
-2.5 & 0
-2.5 | 0

sum (dado>3)

# El operador "igual a" no es =, que se reserva para asignar, tambien con <-

3 == 5
3 == 3


# Ejercicio 26

(7 < 5) | (2 < 4)


# Ejercicio 27

# Tablas de datos a partir de vectores del mismo tama駉: la funcion data.frame
nombres=c("Io","Europa","Ganimedes","Calisto")
class(nombres)
diametrosKm=c(3643,3122,5262,4821)
class(diametrosKm)
(satelitesGalileanos=data.frame(nombres, diametrosKm) )


# Ejercicio 28

# A馻dir vectores a una taba de datos: la funcion cbind
periodoOrbital=c(1.77,3.55,7.16,16.69) 
(satelitesGalileanos=cbind(satelitesGalileanos, periodoOrbital) )

# Ejercicio 29

# Listar registros de una tabla de datos
satelitesGalileanos[3,2]
satelitesGalileanos[1, ]
satelitesGalileanos[,1]

satelitesGalileanos[c(1,4),c(1,3)]

# Ejercicio 30

# Seleccionar variables y registros de una tabla
satelitesGalileanos[ (satelitesGalileanos[ ,2]>4000) , ]
(satelitesGalileanos[ ,2]>4000)

# Guardar una tabla de datos en un fichero
write.table (satelitesGalileanos,file = "Lab02-satelitesGalineanos.csv", col.names=TRUE, row.names=FALSE)
