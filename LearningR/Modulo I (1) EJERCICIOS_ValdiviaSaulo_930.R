# Ej01. Construir manualmente un vector, v, de longitud 10 con valores entre 0 y 10.
v <- 1:10

#       - Mostrar el elemento 3
v[3]

#       - Mostrar los elemento 4 al 7
v[4:7]

#       - Mostrar los elemento 3, 4 y 9
v[c(3,4,9)]

#       - Mostrar todos los elementos menos el 5
v[c(1,2,3,4,6,7,8,9,10)]
v[-5]

# Ej02. Calcular la media del vector v
xm = mean(v); xm
xm <- sum(v)/length(v); xm

# Ej03. Calcular la varianza y dt del vector v
xv = var(v); xv
xs = sd(v); xs

# Ej04. Ejecuta estas lineas de codigo de matrices. Observa y explica que ocurre
# Esta linea produce un Warning debido a la inconsistencia entre los datos
# y los parametros nrow y ncol. Intentamos almacenar 15 elementos
# en una matriz de 18 elementos. Sin embargo el comando funciona rellenando
# el resto de elementos de la matriz con los valores iniciales de la data.
ejemplo_matrix1 <- matrix(1:15, nrow = 3, ncol = 6); ejemplo_matrix1

# Esta linea se ejecuta sin problemas debido a que tanto data como
# los parametros nrow y ncol son consistentes.
ejemplo_matrix2 <- matrix(1:15, nrow = 3, ncol = 5); ejemplo_matrix2

# Esta linea produce un Warning debido a la inconsistencia entre los datos
# y los parametros nrow y ncol. Intentamos almacenar 21 elementos
# en una matriz de 18 elementos. Sin embargo el comando funciona rellenando
# el solo los elementos disponibles de la matriz con los valores de la data.
ejemplo_matrix5 <- matrix(1:21, nrow = 6, ncol = 3); ejemplo_matrix5

# Ej05. No se que hace la funcion 'split'. ?Como lo averiguo?
# Puedo usar la documentacion de R Studio ejecutando ?split
?split

# Ej06. Si quisieramos recoger los datos con las puntuaciones academicas de 4 alumnos en 4 tareas
#?que objeto construiriais? Int?ntalo con datos inventados
puntuaciones <- data.frame(nombre=c('Alicia','Bruno','Carlos', 'Daniel'),nota=c(10,5,6,4),tarea=c('R', 'Phyton', 'C', 'R')); puntuaciones

# Ej07. Si quisieramos recoger las puntuaciones anteriores y las puntuaciones de 
#otros 4 alumnos de otra clase en las mismas tareas academicas
#?que objeto construiriais?
juan <- list(nombre='Juan',nota=7,tarea='R'); juan
pedro <- list(nombre='Pedro',nota=8,tarea='Phyton'); pedro
paola <- list(nombre='Paola',nota=9,tarea='C'); paola
jesus <- list(nombre='Jesus',nota=10,tarea='R'); jesus

puntuaciones = rbind(puntuaciones, juan, stringsAsFactors=FALSE); puntuaciones
puntuaciones = rbind(puntuaciones, pedro, stringsAsFactors=FALSE); puntuaciones
puntuaciones = rbind(puntuaciones, paola, stringsAsFactors=FALSE); puntuaciones
puntuaciones = rbind(puntuaciones, jesus, stringsAsFactors=FALSE); puntuaciones

# Array

#CM.array <- array(0, c(4,4,2), dimnames=(c'alumno1'), c('tarea1'))


CM.array2 <- array(c(C1, C2), c(4,4,2))

cuad.centr.arr <- CM.array[2:3, 2:3,]; cuad.centr.arr
discont <- CM.array[c(1,4), c(2,4),]; discont

#       - ?Sabes seleccionar partes contiguas y discontiguas?

# Ej08. Queremos almacenar las notas textuales de un curso (SS, AP, NOT, SOB, MH).
#       ?Que objeto es el adecuado? Codifica 15 valores y ordenalos de menor a mayor.
# Ordenar los niveles de menor a mayor para indicar el orden de los niveles. No ordenar el Factor.
# Los niveles del factor se aplican a manera de informacion al hacer un str. Tambien te ayuda con los graficos.
notas <- factor(c("SS", "AP", "SOB", "NOT", "MH", 
                  "SS", "AP", "SOB", "NOT", "MH", 
                  "SS", "AP", "SOB", "NOT", "MH"), 
                levels=c("SS", "AP", "NOT", "SOB", "MH"))
# ordered = T
sort(notas)

# Ej09. Tenemos los datos de 3 sujetos, que comprenden: nombre, apellidos,
#       edad, nota media en bachillerato y nivel de ingles (a1, a2, ..., c2).
#       ?Que objeto es mas apropiado? Construyelo.
bachillerato <- data.frame(nombre=c('Alicia','Bruno','Carlos'),
                           apellido=c('Smith','Mars','Teixeira'),
                           edad=c(26,35,40),
                           nota=c(10,5,6),
                           nivel=c('a1', 'b1', 'c1')); bachillerato

# Ej10. Queremos almacenar en un mismo objeto datos referentes a un colegio.
#       La informacion incluye el listado de profesores, de aulas, capacidades,
#       alumnos, nota media por asignatura y grupo, etc. ?Objeto ideal?
lp <- c('Andres','Teresa','Felipe'); lp
as <- c('A','B','C'); as
cp <- c(10,15,20); cp
al <- c('Alicia','Bruno','Carlos'); al
nm <- list(asignatura=c('A1', 'B1'), nota=c(10, 8)); nm
gp <- c('G1', 'G2'); gp

colegios <- list(id = c(1, 2, 6),
                 profesores=lp,
                 aulas=as,
                 capacidades=cp,
                 alumnos=al,
                 notaMedia=nm,
                 grupo=gp); colegios
