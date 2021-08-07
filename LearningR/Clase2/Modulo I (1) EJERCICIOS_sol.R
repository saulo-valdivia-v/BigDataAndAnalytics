# Ej01. Construir manualmente un vector, v, de longitud 10 con valores entre 1 y 10.
v <- 1:10
#       - Mostrar el elemento 3
v[3]
#       - Mostrar los elemento 4 al 7
v[4:7]
#       - Mostrar los elemento 3, 4 y 9
v[c(3, 4, 9)]
#       - Mostrar todos los elementos menos el 5
v[-5]

# Ej02. Calcular la media del vector v
m <- sum(v)/length(v); m
mean(v)   # Comprobación

# Ej03. Calcular la varianza y dt del vector v
va <- sum((v - m) ^ 2)/(length(v) - 1); va
var(v)   # Comprobación
dt <- sqrt(va); dt
sd(v)   # Comprobación

# Ej04. Ejecuta estas lineas de codigo de matrices. Observa y explica que ocurre
ejemplo_matrix1 <- matrix(1:15, nrow = 3, ncol = 6) 
print(ejemplo_matrix1)
#si intento crear la matriz de esta forma me dara un warning porque no tengo suficientes datos y repite para completar
ejemplo_matrix2 <- matrix(1:15, nrow = 3, ncol = 5)
print(ejemplo_matrix2)
#hacer la matrix correcta es tan simple como multiplicar el valor de ncol y nrow
ejemplo_matrix5 <- matrix(1:21, nrow = 6, ncol = 3)
print(ejemplo_matrix5)
#en este caso me da error que tengo mÃ¡s datos que filas, por lo que omite los Ãºltimos


# Ej05. No sé qué hace la función 'split'. ¿Cómo pregunto?
?split

# # Ej06. Si quisieramos formar una base de datos con las puntuaciones academicas de 4 alumnos en 4 tareas
#¿que objeto construirias? Inténtalo
clase1 <- c(16,  3,  2, 13,
        5, 10, 11,  8,
        9,  6,  7, 12,
        4, 15, 14,  1)
C1  <- matrix(clase1, 4, 4, by = T,dimnames= list(c("alumno1", "alumno2", "alumno3", "alumno4"),
                                                  c("tarea1", "tarea2", "tarea3", "tarea4")))
C1

# Ej07. Si quisieramos recoger las puntuaciones anteriores y las puntuaciones de 
#otros 4 alumnos de otra clase en las mismas tareas academicas
#¿que objeto construiriais?

#ARRAY

clase2 <- c( 1, 14, 14,  4,
         11,  7,  6,  9,
         8, 10, 10,  5,
         13,  2,  3, 15)
C2 <- matrix(clase2, 4, 4, by = T)

CM.array <- array(0, c(4, 4, 2), dimnames= list(c("alumno1", "alumno2", "alumno3", "alumno4"),
                                                c("tarea1", "tarea2", "tarea3", "tarea4"),
                                                c("clase1","clase2"))) #creamos primero un array vacio

CM.array[, , 1] <- C1 #para asignarle despues los datos creados en sus dos dimensiones
CM.array[, , 2] <- C2 
CM.array
# También funciona:
CM.array2 <- array(c(C1, C2),c(4, 4, 2))
CM.array2

#Creando una lista, podriamos meter datos de diferente tipo
CM.lista <- list(C1, C2) 
#y nos mantiene los nombres de la matriz
CM.lista

#       - ¿Sabes seleccionar partes contiguas y discontiguas?

cuad.centr.arr <- CM.array[2:3, 2:3, ]; cuad.centr.arr

discont<- CM.array[c(1,4), c(2,4), ]; discont

# más cómodo el acceso mediante arrays que mediante lista:
cuad.centr.lis <- list(CM.lista[[1]][2:3, 2:3],
                       CM.lista[[2]][2:3, 2:3])
cuad.centr.lis
# No funciona:
cuad.centr.lis <- list(CM.lista[[1:2]][2:3, 2:3])

# Ej08. Queremos almacenar las notas textuales de un curso (SS, AP, NOT, SOB, MH).
#       ¿Qué objeto es el adecuado? Codifica 15 valores.
notas <- c("NOT", "SOB", "NOT", "SS", "SOB", "AP", "SS", "SOB", "AP", "SS", "AP", 
           "NOT", "SOB", "MH", "NOT")
notasf<-factor(notas)
notasf# los niveles por defecto se ordenan alfabeticamente
notasf <- factor(notas, levels = c("SS", "AP", "NOT", "SOB", "MH"))
notasf #en este caso coge el orden de los niveles que le hemos marcado nosotros/as
notasf <- factor(notas, levels = c("SS", "AP", "NOT", "SOB", "MH"), ordered = T)
notasf #la opcion ordered nos permite determinar si los niveles deben tener un orden asignado

# Ej09. Tenemos los datos de 3 sujetos, que comprenden: nombre, apellidos,
#       edad, nota media en bachillerato y nivel de inglés (a1, a2, ..., c2).
#       ¿Qué objeto es más apropiado? Constrúyelo.

#DATA.FRAME

nombre <- c("Ana", "Blas", "Carlos")
apelli <- c("Álvarez", "Blázquez", "Calvo")
edad   <- c(32, 24, 44)
notaMB <- c(8.4, 6.2, 8.8)
nivIng <- factor(c("c1", "a2", "b1"), ordered = T, 
                 levels = c("a1", "a2", "b1", "b2", "c1", "c2"))
datos <- data.frame(nombre, apelli, edad, notaMB, nivIng)
datos

# Ej10. Queremos almacenar en un mismo objeto datos referentes a un colegio.
#       La información incluye el listado de profesores, de aulas, capacidades,
#       alumnos, nota media por asignatura y grupo, etc. ¿Objeto ideal?

# Una lista porque no exige que los vectores tengan la misma longitud, mientras que los data.frame si
#por ejemplo:
notaMB <- c(8.4, 6.2, 8.8,NA)#añadimos un elemento mas en el ejemplo anterior
datos <- data.frame(nombre, apelli, edad, notaMB, nivIng)
datos#nos da error

