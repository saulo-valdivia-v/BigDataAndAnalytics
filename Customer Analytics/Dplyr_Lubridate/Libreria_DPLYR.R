#Librería DPLYR

#Instalamos la librería
install.packages("dplyr")

#Llamamos la librería para poder acceder a sus funciones
library(dplyr)
library(readr)

#Las funciones más útiles son:
select() #para elegir ciertas columnas de todo un data frame.
filter() #filtrar los datos del data frame de acuerdo a los valores que me interesan incluir o excluir.
group_by() #me muestra datos agrupados por determinadas variables.
mutate() #permite realizar modificaciones sobre los datos. 
count() #permite contar filas.
arrange() #organizar las filas según un orden establecido.
summarise() #reducir múltiple valores / múltiples filas a una sola fila /valor.
rename() #renombrar una columna del data frame.

#Con estas funciones de dplyr podemos seleccionar las columnas que nos interesan, asignarle nuevo nombre en el dataframe,
#filtrar y excluir aquello que no queremos con el !, modificar tipos de datos como caracteres o fechas, agrupar datos,
#y ordenarlos de la forma que nos quede más comoda

##### USO FUNCIONES DPLYR #####
#Ejemplos utilizando 2 data frame que vienen incorporados en R para practicar: iris y mtcars
#Primero utilicemos ?iris y ?mtcars para que conozcan el origen de estos datasets y de qué tratan
Ejemplo_iris <- as.data.frame(iris)
Ejemplo_mtcars <- as.data.frame(mtcars)

#### FUNCIÓN SELECT
Ejemplo_mtcars2 <- Ejemplo_mtcars %>%
  #Este simbolo %>% me permite dividir el código en diferentes renglones, para ser más ordenado
  select(mpg,cyl,gear)

#### FUNCIÓN FILTER 
Ejemplo_mtcars %>%
  filter(gear > 4) #de esta forma sólo me interesan aquellos registros cuyo gear sea mayor a 4

dladad <- Ejemplo_mtcars %>%
  filter(gear > 4)

#también puedo aplicar múltiples filtros a la vez para reducir aún más los registros
Ejemplo_mtcars %>%
  filter(gear > 4 & carb < 5)

#También puedo seleccionar excluyendo lo que no me interese utilizando el ! de negación
Ejemplo_mtcars %>%
  filter(!gear < 0 & !carb < 3)

#Puedo utilizar la función filter para eliminar los NA, que es muy útil cuando trabajo con dataset reales
Ejemplo_mtcars %>%
  filter(!is.na(mpg)) #en este caso me devuelve todos los resultados porque no hay ningun NA

#También podría filtrar para evitar los duplicados
Ejemplo_mtcars %>%
  filter(!duplicated(carb))


#### FUNCIÓN GROUP BY
#La función group by tiene potencia la conjugarse con las otras funciones o tipos de datos donde tenga sentido agrupar
#En líneas generales el group by no modifica la forma en que la data se ve salvo que apliquemos las otras funciones
Ejemplo_mtcars_group <- Ejemplo_mtcars %>%
  select(mpg,qsec,gear,cyl) %>%
  group_by(cyl)

#### FUNCIÓN MUTATE
Ejemplo_iris2 <- Ejemplo_iris %>%
  mutate(dada = Sepal.Width * 2)

(Ejemplo_iris2)

#### FUNCIÓN COUNT
Ejemplo_iris %>% 
  group_by(Petal.Width) %>%
  count(Species) #Vemos que el ancho 0,2 es el que tiene más registros (29) en el dataset


#### FUNCIÓN ARRANGE
#Sirve para poder dar un orden a los datos, como puede ser orden descendiente
Ejemplo_iris %>%
  arrange(Sepal.Width)

Ejemplo_iris %>%
  arrange(desc(Sepal.Width))

#### FUNCIÓN SUMMARISE
#Summarise me permite reducir todos los valores de mi dataset a unos pocos de acuerdo a los parámetros que empleo
#Muchas veces se utiliza junto con el group by para poder establecer el criterio sobre el que se sintetizará la data
#summarise soporta muchas operaciones aritméticas y estadísticas, que pueden consulta con ?summarise
Ejemplo_iris %>% 
  group_by(Species) %>%
  summarise(mean(Sepal.Width)) #Vemos el ancho promedio del sépalo para cada especie de flor

#Si bien Dplyr cuenta con la función Count, summarise también puede realizar conteos. 
#Son dos alternativas válidas para trabajar este tipo de operación
Ejemplo_iris %>% 
  group_by(Species) %>%
  summarise(count = n()) #Vemos la cantidad de registros que existen para cada tipo de Especie, contando las filas


#### FUNCIÓN RENAME
#Me permite renombrar una columna, para ello primero escribo el nombre que quiero darle y luego el nombre actual
Ejemplo_iris %>%
  rename(Ancho_Sepalo = Sepal.Width) %>%
  head(5) #al ejecutar la linea, el resultado aparece en Console y vemos que el nombre de la anteúltima columna ha cambiado

#La realidad que en la práctica no suele emplearse mucho ya que cuando utilizo la función SELECT puedo indicar
#que nombres quiero que tengan las columnas del nuevo data frame:
iris_nuevo <- Ejemplo_iris %>%
  select(Largo_Sepalo = Sepal.Length, Ancho_Sepalo = Sepal.Width, 
         Largo_Petalo = Petal.Length, Ancho_Petalo = Petal.Width)


#En el siguiente link pueden encontrar cheatsheet con las funciones de dplyr
#https://github.com/rstudio/cheatsheets/blob/master/data-transformation.pdf

#
#
#
##### EJERCICIOS PRÁCTICOS ####
#Ahora van a realizar un ejercicio con uno de los archivos de datos que tenemos en la carpeta del proyecto
#para poder practicar las funciones y fijar esos conocimientos

#Paso 1: cargamos el archivo Dataset_Compradores.csv
Ejercicio_Dplyr <- read_csv(file.choose())

#Paso 2: Inspeccionamos Ejercicio_Dplyr para entender sus datos
str(Ejercicio_Dplyr) #todas son columnas de numeros dobles excepto algunas de texto, no hay factores ni fechas
summary(Ejercicio_Dplyr) #gracias a este vemos que el salario promedio es 100.090 y la edad promedio 37
length(unique(Ejercicio_Dplyr$CustomerId)) #vemos que existen 100.000 uniques Id por lo que no hay repetidos
table(Ejercicio_Dplyr$Geography) #al aplicar table sobre Geography descubrimos cuántos usuarios pertenecen a cada país
table(Ejercicio_Dplyr$Surname) #también podemos aplicar la función a una columna tan variada como apellido

#Paso 3: Generamos un nuevo dataframe donde filtraremos por aquellos usuarios que tienen un salario más alto de la media
Ejercicio_Dplyr_sub <- Ejercicio_Dplyr %>%
  filter(EstimatedSalary > 100000) #al ejecutar nos quedamos con 5.010 filas

#Ahora hagan el ejercicio de filtrar por Gender == "Female"
Ejercicio_Dplyr_sub <- Ejercicio_Dplyr %>%
  filter(Gender == 'Female')


#Ahora hagan el ejercicio de filtrar por Gender == "Female" con un EstimatedSalary > 100000
Ejercicio_Dplyr_sub2 <- Ejercicio_Dplyr %>%
  filter(Gender == "Female" & EstimatedSalary > 100000)


#Paso 4: Agrupamos por país y vemos cual es la media de balance
Ejercicio_Dplyr_sub %>%
  group_by(Geography) %>%
  summarise(mean(Balance)) #Cual es el país que tiene el promedio de Balance más alto? Alemania


#Calcular la suma total de Balance agrupando por Geografía y utilizando la función sum dentro de summarise
#Cual es el país cuya suma de Balance es la más baja? españa
Ejercicio_Dplyr_sub %>%
  group_by(Geography) %>%
  summarise(sum(Balance)) 

#Calcular la mediana de CreditScore utilizando la función median dentro de summarise
#Cuál es el país que tiene el CreditScore más alto? Francia
Ejercicio_Dplyr_sub %>%
  group_by(Geography) %>%
  summarise(median(CreditScore)) 

#Paso 5: finalmente, creen un nuevo dataset donde solo contenga los registros (filas) con Geography Spain, 
#seleccionen la columna Gender y realicen un count de registros femenino y masculino. Completar los espacios
#Cuantas mujeres españolas existen en el dataset? 1089
Ejercicio_Dplyr_España <- Ejercicio_Dplyr %>%
  filter(Geography == "Spain") %>%
  group_by(Gender) %>%
  count(Gender)


#Ahora realicen el mismo ejercicio pero filtrando France
#Cuantos hombres franceses existen en el dataset? 2753
Ejercicio_Dplyr_Francia <- Ejercicio_Dplyr %>%
  filter(Geography == "France") %>%
  group_by(Gender) %>%
  count(Gender)
  #completar con las columnas correspondientes en cada función de dplyr


#Realicen un agrupamientos por apellidos y encuentren el apellido que más veces se repite. Smith
Ejercicio_Dplyr_Surname <- Ejercicio_Dplyr %>%
  #group_by(Surname, Gender) %>%
  group_by(Surname) %>%
  count(Surname) 

#Utilizando esta funcion puedo imprimir en consola rápidamente cuál es el apellido que más se repite
max(Ejercicio_Dplyr_Surname$n) #"n" es la columna que se genera por default al realizar counts


#Ahora repitan el ejercicio pero no sólo agrupen por Surname, sino también por Gender, qué sucede?
Ejercicio_Dplyr_Surname <- Ejercicio_Dplyr %>%
  group_by(Surname, Gender) %>%
  count() 

#Cuál es el apellido que más se repite en el caso de los mujeres y cuál en el caso de los hombres.
max(Ejercicio_Dplyr_Surname$n) #"n" es la columna que se genera por default al realizar counts

FemaleNames <- Ejercicio_Dplyr_Surname %>%
  filter(n == max(Ejercicio_Dplyr_Surname$n) & Gender == 'Female')

MaleNames <- Ejercicio_Dplyr_Surname %>%
  filter(n == max(Ejercicio_Dplyr_Surname$n) & Gender == 'Male')

MaleNames1 <- Ejercicio_Dplyr_Surname %>%
  filter(Gender == 'Male')
  summarise(n == max(n))

test2 <- Ejercicio_Dplyr %>%
  filter(Gender == 'Male') %>%
  group_by(Surname, Gender) %>%
  count()
  select(max(n))