#Manipulación de cadenas de texto con la librería STRINGR

#Documentación y ejemplos: https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html
#Cheatsheet de Stringr: https://github.com/rstudio/cheatsheets/blob/master/strings.pdf

#Instalamos la librería
#install.packages("stringr")

#Llamamos la librería para poder acceder a sus funciones
library(stringr)
library(dplyr)
library(readr)

#Carga de datasets
Ejemplo_ventas <- read_csv("datasets/Dataset_VentasTienda.csv")
Ejemplo_TripAdvisor <- read_csv("datasets/Tripadvisor_Reviews.csv")

#Las funciones más útiles son:
str_to_lower()
str_to_upper()
str_count()
str_detect()
str_extract()
str_replace()
str_replace_all()
str_replace_na()


##### ESTAS FUNCIONES ME PERMITEN PONER TODAS LAS PALABRAS EN MINÚSCULA O MAYÚSCULA
str_to_lower()
str_to_upper()

#normalmente suelen utilizarse en conjunción con mutate
iris %>%
  mutate(Especie = str_to_lower(Species))

iris %>%
  mutate(Especie = str_to_upper(Species))


###### FUNCIONES PARA BUSCAR DETERMINADAS PALABRAS DENTRO DE TODOS LOS TEXTOS
#str_detect detecta la presencia o ausencia de determinado patrón dentro del texto
str_detect(iris$Species, "ir")
str_detect(iris$Species, "tos")


#Puedo crear vectores de palabras relevantes y utilizar str_detect para detectarlas a todas
productos_comprados <- c("vegetables", "fruit", "berries")
Ejemplo_ventas %>%
  filter(str_detect(itemDescription, paste(productos_comprados, collapse = '|')))



###### FUNCIONES PARA EXTRAER DETERMINADAS PALABRAS O CARACTERES DENTRO DE TODOS LOS TEXTOS
#str_extract extrae la primera palabra de un string que hace match con el pattern
head(
  str_extract_all(Ejemplo_TripAdvisor$Review, pattern = "\\d")
)



###### FUNCIONES PARA REEMPLAZAR DETERMINADAS PALABRAS O CARACTERES DENTRO DE TODOS LOS TEXTOS
#cuando necesito corregir datos str_replace es una función muy útil para organizar mis dataset

#Utilizando los bloques de regex, puedo limpiar mis datos de caracteres que no me interesan
Ejemplo_TripAdvisor_replace <- str_replace_all(Ejemplo_TripAdvisor$Review,"[[:punct:]]", " ")

#Puedo eliminar todos los numeros
Ejemplo_TripAdvisor_replace2 <- str_replace_all(Ejemplo_TripAdvisor$Review,"[[:digit:]]", " ")

#O eliminar palabras en concreto
Ejemplo_TripAdvisor_replace3 <- str_replace_all(Ejemplo_TripAdvisor$Review,"\\bhotel", "")


#A su vez podemos utilizarlo con las funciones de Dplyr para acelerar el desarrollo de nuestra limpieza
Ejemplo_TripAdvisor_replace4 <- Ejemplo_TripAdvisor %>%
  select(Review) %>%
  mutate(Review = str_replace_all(Review, '[[:digit:]]', ' ')) %>%
  mutate(Review = str_replace_all(Review, '[[:punct:]]', ' ')) 

Ejemplo_TripAdvisor_replace5 <- Ejemplo_TripAdvisor %>%
  select(Review) %>%
  mutate(Review = str_replace_all(Review, '[[:digit:]]', ' ')) %>%
  mutate(Review = str_replace_all(Review, '[[:punct:]]', ' ')) %>%
  mutate(Review = str_replace_all(Review, '\\s', '')) #hay que tener mucho cuidado como utilizarlo


##### FIN. 

