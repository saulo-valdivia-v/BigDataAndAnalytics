################################MODULO I PRIMEROS PASOS CON R (III): manejo de datos 

#*********************************************Funciones interesantes para factores

### Filtrar por tipo de dato
genero<- factor(c("h", "m"), levels = c("m","h"),labels=c("mujer","hombre"))
str(genero)
str(factor(c("h", "m"), levels = c("m", "h"),exclude = c("h")))

### Visualizar en tabla
univ <- c('UCM', 'UAM', 'UAM', NA, 'UCM', 'UCM','UNED')
univf <- factor(univ, levels = c("UAM", "UCM", "UNED"))
table(univ)
table(univf)# ver diferencia con el anterior
#?y el dato perdido?
univf2 <- addNA(univf)#a?ade un nivel al factor que contiene los datos perdidos
univf2
table(univf2)

prueba <- addNA(genero);prueba#?y si a?adimos e nivel NA a un factor que no tiene valores perdidos?
table(genero)

### Operar a partir de los niveles de una variable categorica
edad <- c(21, 36, 19, 20, 20, 19,NA)
mean(edad)
tapply(edad, univf, mean)#aplica la media a la variable edad segun los niveles de univf
tapply(edad, univf2, mean)


#***********************************COERCION
#*
#en caso de unir vectores no atomicos (con diferente tipo de datos)
#estos son coercionados (ver reglas en PPT):
help(letters)
v <- c(1,2,3)
ch <- c(letters[1:length(v)]);ch
rb <- rbind(v, ch); rb
class(rb)
typeof(rb) #ha cambiado el formato de v de n?meros a tipo character

#la forma de que cada elemento mantenga su tipo original es usar data.frame:
df <- data.frame(v, ch); df
class(df)#como es clase data.frame (objeto no atomico) puede contener datos de diferente tipo

#*Funciones de coercion (Explicita/voluntaria)
as.data.frame(rb)

n <- c(-Inf, -4.33, NaN, 0, NA, 1, Inf)#ejemplo: vector numerico con diferentes tipos de datos
as.integer(n)#nos sale un warning porque los inf no tienen representacion de numero entero
as.complex(n)
as.logical(n)#al pasar de numeros a logicos T y F pasan a ser 1 y 0
as.character(n)
as.factor(n)
as.matrix(n)

#**************************************** Comportamiento de las operaciones 
#****************************************(ver OPERADORES en PPT)
v1 <- c(1, 2)
v2 <- c(10, 20)
v1 + v2 #suma numero a numero porque las variables tienen la misma longitud

x <- c(1, 2, 3)
y <- c(10, 20)
z <- 100
x+z
x + y + z #como z es de diferente longitud, 
#se comporta diferente y genera un aviso (RECICLADO)
#ya hemos visto en sesiones anteriores ejemplos de reciclado: tener en cuenta

m <- matrix(1:12, nrow = 3, ncol = 4);m
m*2 #multiplica cada numero de la matriz
sum(m)
apply(m, MARGIN = 2, FUN = sum)#esta funcion nos permite especificar las dimensiones
#de la matriz a las que aplicar la funcion
apply(m, MARGIN = 1, FUN = sum)

#ejemplos de operadores aritmeticos
2 ^ 8 #exponenciaci?n
2 ** 8 #exponenciaci?n

19/7 #division
19 %/% 7 #devuelve la parte entera del cociente
19 %% 7 #devuelve el resto de la division

#ejemplos de operadores logicos
x <- 0:5; x
x < 3 #menor
which(x > 2) #nos dice los elementos de la variable que cumplen esa condicion
x >= 3 #mayor o igual
y <- c(1, 1, 2, 4, 4, 4)
x != y #diferente de 
x == y #igual que
y[y < 3] #devuelve los que cumplen la condicion
which(y <3)


l1 <- c(TRUE, TRUE, FALSE, FALSE)
l2 <- c(TRUE, FALSE, TRUE, FALSE)
l1 & l2 #devuelve TRUE solo cuando los ejementos de ambas variables son T
l1 | l2#devuelve FALSE solo cuando los ejementos de ambas variables son F
!l1 #invierte los valores logicos

#********************************************Tratamiento de decimales (PPT)

#************************************Manipulacion de vectores: paste, seq,rep
#*
###FUNCION PASTE
v1<-c("A","B"); v2<-2:3
codigos <- paste(v1,v2); codigos#para unir vectores en formato character (crear codigos)
class(codigos)
codigos <- paste(v1,v2, sep = "");codigos #separar en varios elementos
codigos <- paste(v1,v2, sep = ".");codigos
codigos <- paste(v1,v2, collapse="");codigos #juntar en un solo elemento

# Algunos vectores de cadena de caracteres predefinidos en R
LETTERS
x <- paste(LETTERS[1:5]);x
x <- paste(LETTERS[1:5], collapse="");x

letters
month.name
month.abb
fechas<- paste(1:12, month.abb, 1990:2002, sep=".");fechas

juntar <- paste(c("Una ", "frase ", "cualquiera"), 
                collapse ="");print(juntar)

###FUNCION SEQ
i <- 2:6 #crea los numeros de ese rango
seq (from = 1, to = 100) #crea la secuencia especificada (de uno a uno por defecto)
seq (from = 1, to = 10, by=2) 

seq(along.with = c(3, 4, 5, 6, 7)) 
#crea una secuencia de longitud igual al vector del argumento along.with
seq(from = 10, to = 13, 
    along.with = c(3, 4, 5, 6, 7))
seq(from = 10, to = 13, 
    length.out = 5) #similar usar length.out

s <-seq (from = 1, to = 100)
sort(s)
sort(s, decreasing=T)#sirve para ordenar valores

n <- c(-Inf, -4.33, NaN, 0, NA, 1, Inf)
sort(n, decreasing=T)
rank(n)           #asigna un rango a los valores 
#y es util para tratar valores perdidos y valores repetidos
rank(n, na.last=F)
?rank

###FUNCION REP
rep(c(1, 2, 3), times = 2)#repite patrones tantas veces como indiquemos
rep(c(1, 2, 3), each = 3)
rep(c(1, 2, 3), times = 2, each = 3)# en caso de usar times e each juntos,
#primero se aplica each
r <-rep(c(1, 2, 3), length.out =5);r #tambien podemos indicarle una longitud dada

rank(r) #asigna un valor medio a cada valor repetido
rank (r, ties.method = "min")
rank (r, ties.method = "max")
?rank # para ver las opciones de ties.method

###FUNCION SAMPLE (generacion aleatoria de datos)
sample(1:6, 4, replace = T)

#puedo generar la logica de tirar una moneda al aire
moneda <- sample(c(0,1), 100, replace = TRUE); moneda

#o la logica de una respuesta Si o No a una pregunta, determinando la probabilidad de cada una
respuesta <- sample(c("Yes", "No"), 100, replace = TRUE, prob = c(0.3, 0.7))
respuesta


#****************************************Manipulacion de DATA.FRAMES
#*
barrios <- c('Arganzuela', 'Lavapies', 'Chueca', 'Moncloa', 'Villaverde', "Salamanca", "Tetuán")
edad <- c('18-24', '25-34', "35-44", "+45")
nacimiento <- c("1990-01-01", "1991-01-01","1992-01-01","1993-01-01","1994-01-01","1995-01-01")

sample_barrios <- sample(barrios, 100, replace = TRUE)
sample_edad <- sample(edad, 100, replace = TRUE)
sample_nacimiento <- sample(nacimiento, 100, replace = TRUE)
amigos <- sample(1:88, 100, replace = TRUE)

ejemplo_dataframe <- data.frame( barrios = sample_barrios,
                                 edad = sample_edad,
                                 nacimiento = sample_nacimiento,
                                 amigos = amigos,
                                 stringsAsFactors = F)

print(ejemplo_dataframe)#lo hemos podido crear gracias a que tenemos el mismo numero de datos
#en todas las variables (generadas por sample)

nrow(ejemplo_dataframe)
ncol(ejemplo_dataframe)
#?otra forma (que ya hemos visto) de obtener la misma info?
dim(ejemplo_dataframe)

names(ejemplo_dataframe) #nombres de las variables

#para cambiar los nombres de las filas:
A <- paste("pers",1:100, sep="")
row.names(ejemplo_dataframe) <- A
ejemplo_dataframe

library("dplyr")

?select
#permite seleccionar variables de un dataframe:
select(ejemplo_dataframe, barrios, amigos)

?filter
#permite filtrar los datos segun las condiciones que le digamos:
filter(ejemplo_dataframe, edad=='18-24')
filter(ejemplo_dataframe, edad=="+45"& amigos> 70)
#CUIDADO: cuando hay valores perdidos, filter descarta directamente 
#toda la fila. Ejemplo:
edadNA <- c('18-24', '25-34', "35-44", "+45",NA)
sample_edadNA <- sample(edadNA, 100, replace = TRUE)
ejemplo_dataframeNA <- data.frame( barrios = sample_barrios,
                                   edadNA = sample_edadNA,
                                   nacimiento = sample_nacimiento,
                                   amigos = amigos,
                                   stringsAsFactors = F)
filter(ejemplo_dataframeNA, amigos> 70)

?arrange
#permite ordenar los datos en base al criterio que le pongamos
arrange(ejemplo_dataframe, barrios)
arrange (ejemplo_dataframe, desc(amigos))

?mutate
#permite a?adir nuevas variables (util para mezclar bases, p.ej.)
mutate(ejemplo_dataframe, nuevavariable=NA)

?summarise
summarise(ejemplo_dataframe, max(amigos))
summarise(ejemplo_dataframe, mean(amigos))

?group_by
#esta funcion por si sola no cambia nada en los datos, solo muestra la agrupacion
group_by(ejemplo_dataframe)

###FUNCION SPLIT

trozos <- split (ejemplo_dataframe$amigos, ejemplo_dataframe$barrios); trozos	
# divide los datos de numero de amigos segun los valores de la variable barrios

is.list(trozos)#por tanto, la funcion split genera listas
is.data.frame(trozos)