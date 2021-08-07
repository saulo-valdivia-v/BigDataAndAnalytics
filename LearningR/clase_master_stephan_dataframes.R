#################################################################################################################
# ATENCIÓN: ANTES DE EJECUTAR HAY QUE CAMBIAR EL ENCODING DEL SCRIPT PARA QUE NO HAYA PROBLEMAS CON LAS TILDES  #
# PARA ESO VAMOS A LA PESTAÑA FILE > REOPEN WITH ENCODING Y SELECCIONAMOS UTF-8                                 #
# CUANDO GUARDEMOS EL SCRIPT TAMBIÉN LO HAREMOS CON ESTE ENCODING                                               #
#################################################################################################################

# Vamos a instalar unos paquetes para ampliar las funciones que nos ofrece R
# Una vez instalados ya no tendréis que  volver que hacerlo

# install.packages("tidyverse")
# install.packages("haven")
# install.packages("GDAtools")

# Al iniciar R habrá que activar siempre las librerías instaladas que queramos utilizar.
# Para eso usamos la función library

library(tidyverse)
library(haven)
library(GDAtools)

# Recapitulamos

1+1

#Estructuras de datos

# OBJETOS

# Asignamos
nombre <- "Stephan"
edad <- 24

# Visualizamos
nombre
edad

# VECTORES: Un vector es una secuencia de elementos de datos. Los elementos de un vector se llaman componentes y tienen que ser todos del mismo tipo  
nombre <- c("Stephan", "Maria", "Pablo", "Carla", "Hector", "Sara")
edad <- c(24, 23, 26, 27, 26, 30)
nota <- c(6, 5, 9, 1, 8, 3)


# Funciones útiles para trabajar con vectores

#De ayuda
class(edad)
help(class)

#De análisis
sum(edad)

mean(edad)
sd(edad)
max(edad)
min(edad)

table(edad)

summary(edad)

# DATAFRAMES: Un data frame es una lista de vectores de igual longitud (mismo número de filas)
# http://www.r-tutor.com/r-introduction/data-frame

#Creamos un data frame a partir de vectores
data <- data.frame(nombre, edad, nota)
data

#borramos los vectores creados anteriormente par quedarnos solo con nuestro dataframe
rm(edad, nombre, nota)

# Como accedemos a las variables de dataframe?
data$edad

# Aplicar funciones a variables de un dataframe
sum(data$edad)

mean(data$edad)
sd(data$edad)
max(data$edad)
min(data$edad)

table(data$edad)

summary(data$edad)

# Y si queremos crear o recodificar una nueva variable?

# Ejemplo 1
data$año_nacimiento <- NA
data$año_nacimiento <- 2020 - data$edad

# Ejemplo 2 (factores)
data$aprobado_suspenso <- NA
data$aprobado_suspenso[data$nota < 5] <- 0
data$aprobado_suspenso[data$nota > 4] <- 1

data$aprobado_suspenso <- factor(x = data$aprobado_suspenso,
                                 levels = c(0,1),
                                 labels = c("Suspenso", "Aprobado"))


# Vemos las proporciones de nuestras variables (Función del paquete GDAtools)
wtable(data$aprobado_suspenso)
prop.wtable(data$aprobado_suspenso)


# Y si queremos filtrar el dataframe? (Quedarnos solo con los aprobados) (función del paquete tidyverse)
data_aprobados <- filter(data, 
                         aprobado_suspenso == "Aprobado")
data_aprobados


# Y si queremos quedarnos solo con unas variables concretas? (solo nos interesa el nombre y la nota) (función del paquete tidyverse)
data_aprobados <- select(data_aprobados, 
                         nombre, nota)
data_aprobados

# Ahora podemos analizar solo a los aprobados 
mean(data_aprobados$nota)



# ¿Podemos combinar estas operaciones?

#Para eso utilizamos los llamados "pipes" %>% (del paquete tidyverse)
#Las pipes nos permiten encadenar distintas funciones del paquete tidyverse como filter() o select()
#Estas 3 lineas de codigo hacen exactamente lo mismo que las lineas que van de la 102 a la 110

data_aprobados <- data %>% 
  filter(aprobado_suspenso == "Aprobado") %>% 
  select(nombre, nota)



  
  





