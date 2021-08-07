################################MODULO I PRIMEROS PASOS CON R

#******************************El ecosistema R
#Script, Consola, Environment, Menus

#uso de la almohadilla
#como usar la ayuda
?
#otros menus
#Cntl+Enter

#los espacios no son necesarios pero ayudan a tener un entorno mas claro; 
#importancia de la limpieza
  
#CALCULADORA
2 + 3
2 * 3
sqrt(7 * (4 - 6.5))
sqrt(abs(7 * (4 - 6.5))) 

#ASIGNACION DE OBJETOS: 
###anteriormente R ha calculado los valores que le hemos pedido, pero estos
###no se han quedado guardados para utilizarlos posteriormente. Para ello, usamos la Asignacion

a <- 2 * 3 #para asignar usamos el operador <-
#automaticamente se crea una nueva variable con el valor del calculo
#podemos ver las variables que se van creando a la derecha ('Global Environment')
a #para mostrar el contenido del objeto basta con poner su nombre
print(a)#tambien sirve la funcion print

A <- 2 #R es sensible a las mayusculas, por lo que esta seria una nueva variable distinta a la anterior
a * A
objects()#te devuelve los nombres de los objetos creados hasta el momento


#******************************Objetos de R
###todos los objetos que almacenan datos en R se denominan vectores 
###= conjunto ordenado de elementos a los que se accede a traves de un indice unico; 
###el [1] que aparece siempre en la consola es un indice (el primero de cada linea)
a

#Hasta ahora hemos creado vectores de longitud 1; si queremos vectores 
# de mayor longitud debemos usar el operador ':' (para valores consecutivos) o c() (=concatenar)
v <- 11:15 
w <- c(2, 3, 7, 10, 11)

#el indice de la consola tan solo es util con vectores de gran longitud
1:100

#los indices tambien nos permiten acceder a elementos especificos del vector;
#si queremos acceder a varios elementos, de nuevo usar : o c()
#Esto puede ser util en archivos de datos masivos para visualizar 
#elementos concretos que nos interesen
v[2]
v[3:5]
v[c(3,5,20)]


#TIPOS DE DATOS (ver PPT)

ejemplo_entero <- 1L #si quiero crear un integer debo explicitarlo a través de la letra L, sino es considerado numérico
ejemplo_numerico <- 3.14 #es importante saber que R al estar en inglés utiliza el punto para los decimales
ejemplo_numerico2 <- c(1, 2, 3)

class(ejemplo_entero)
class(ejemplo_numerico)
class(ejemplo_numerico2)

ejemplo_caracter <- "palabra" #importantes las comillas 

ejemplo_logico <- c(T, FALSE)    
ejemplo_vacio <- c() 

ejemplo_NA <- NA
#representan un espacio, tienen importancia y ocupan memoria activa
#aparecer constantemente en los dataset si hay celdas vacías
is.na(ejemplo_NA)# ?qu? hace esta funciona?

#TIPOS DE OBJETOS

###MATRICES: vectores atomicos con dos dimensiones (filas y columnas)
m <- matrix(1:12, nrow = 3, ncol = 4); m #por defecto, coloca los n?s por columnas
m <- matrix(1:12, nrow = 3, ncol = 4, byrow = T); m

is.matrix(m) #para comprobar si un objeto es matriz o no
as.matrix(c(1, 2)) #para formar matriz directamente con los datos PERO
as.matrix (c(1, 2),nrow=1,ncol=2) #no admite los argumentos de fila y columna

m[2, 3] #para acceder al elemento de la fila 2, columna 3
m[2,]#para acceder a la fila 2
m[,3] #para acceder a la columna 3

m <- matrix(1:12, nrow = 3, ncol = 4, byrow = T,
            dimnames = list(c("Suj1", "Suj2","Suj3"), 
                            c("A","B", "C", "D"))) #para nombrar las dimensiones
m

v <- c(1:8)
Q<- matrix(v, nrow = 2, ncol = 4, byrow = T); Q
rownames(Q) <- c("Suj1", "Suj2")
colnames(Q) <- c("A", "B", "C", "D"); Q
Q["Suj1", c("B", "D")]#tambien se pueden usar estos nombres para acceder a los datos
Q["Suj1", c("B", "D"), drop=F]#si queremos mantener las dimensiones

#otras formas de construir matrices
dim(v) <- c(2, 4); v #hemos transformado v en matriz dandole dimensiones 

x <- c(1, 2, 3)
y <- c(10, 20, 30)
rb <- rbind(x, y); rb#une por filas
cb <- cbind(x, y); cb#une por columnas

###ARRAY: son matrices multidimensionales
n <- array(1:12, dim = c(2, 3, 2)); n #array con los numeros del 1 al 12
#con 2 filas, 3 columnas y 2 capas
#no existe una funcion equivalente a byrow, asique hay que tener en cuenta 
#que se construyen por capas>columnas>filas

is.array(n)

n[2, 3, 1]
n[2, , ]#fila 2 de cada capa
n[, 3, ]#columna 3 de cada capa
n[, , 1]#capa 1

dimnames(n) <- list(c("fila1", "fila2"), c("col1",
                         "col2", "col3"), c("capa 1", "capa 2"))

#aunque las matrices y arrays son objetos con diferentes dimensiones, su estructura es 
#unidimensional, lo cual es importante a la hora de operar con ellos, p.ej.
Q["Suj1", c("B", "D"), drop=F]#aqui teniamos que usar drop si queremos mantener las dimensiones
length(m); length (v)
sum(m)
apply(m, MARGIN = 2, FUN = sum)#esta funcion nos permite especificar 

###FACTORES: vectores atomicos que almacenan variables categoricas
univ <- c("UCM", "UAM", "UAM", "UNED", "UCM", "UCM")
str(univ)

ejemplo_factor <- factor("femenino", "masculino", "transg?nero") #En el environment vemos Factor w/ 1 level
ejemplo_factor2 <- factor(c("femenino", "masculino", "transg?nero"), labels = "g?nero") 
#?que aparece en el environment?

#Cuidado con esto porque si no creamos una cadena con concatenacion, 
#no crea niveles y no puede podriamos generar etiquetas
str(ejemplo_factor) 
str(ejemplo_factor2) 

#?como asigna los niveles?
ejemplo_factor2[1]
ejemplo_factor2 [2]

#podemos darle nuestro propio orden de niveles
nse <- factor(c("medio", "bajo", "alto"))
str(nse)
nse <- factor(c("medio", "bajo", "alto"), levels=c("bajo","medio","alto"))
str(nse)


###LISTAS: vectores no atomicos que almacenan cualquier tipo de dato
L<-list(a=c(1,2,3),b=c('A','H'),d=T);print(L)
L[1]      # Primer objeto de la lista
L[[1]]    # Contenido completo del primer objeto de la lista
L$a       #    "

L[1][2]   # Error!
L[[1]][2] # Contenido particular [2] del primer objeto
L$a[2]    #    "

#Nuestros datos por ejemplo se almacenarian en listas ya que 
#pueden contener informacion cualitativa, coeficientes, correlaciones, etc

x <- seq(1.0, 2.0, 0.1);y <- 2:4 # Secuencia
mi.matriz <- matrix(1:12,3,4); mi.matriz
mis.caracteres <- paste(LETTERS[1:5]);mis.caracteres
mis.logicos <- x>1.2; mis.logicos
lista1 <- list(x, y, mi.matriz, mis.caracteres,mis.logicos); lista1
length(lista1)	# Devuelve el numero de objetos que componen la lista
lista1[1]
lista1[[1]]
lista1[[1,1]] # Error!
lista1$mi.matriz# Error proque no tiene ese nombre asignado

lista1 <- list(x, y, mi.matriz=mi.matriz, mis.caracteres,mis.logicos); lista1
lista1$mi.matriz
lista1$mi.matriz[2,3]

names(lista1)
nombres <- c("reales","enteros", "matriz", "caracteres", "logicos")
names(lista1)<- nombres   # Observese que la misma instruccion sirve para 
# obtener e imponer valores
lista1
lista1[["reales"]]
lista1[[1]]	
lista1[1]	
lista1$reales
str(lista1) 

###DATA.FRAMES: listas que permiten acceder a los datos de modo matricial. Tipo especial de listas
#Restriccion: sus vectores deben tener la misma longitud
df <- data.frame(Id = c(1, 2, 6), 
                 Grupo = c("Exptal", "Control", "Exptal"),
                 VD = c(12, 11, 9)); df
mode(df)#son un tipo especial de lista
class(df);str(df)


###AVISOS Y ERRORES
x <- c(-1, 4)
sum(x)        # Ejecutado sin incidencias
sqrt(x)      # Ejecutado CON aviso
x(2)          # No ejecutado POR error


#--------------------------------------------------------------------EJERCICIOS