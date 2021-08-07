#Text Mining con librería Tidytext

#Documentación y ejemplos: https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
#Libro (corto) gratuito: https://www.tidytextmining.com/

#Instalamos la librería
#install.packages("tidytext")

#Llamamos la librería para poder acceder a sus funciones
library(tidytext)
library(dplyr)
library(readr)


#La función más útil es aquella que permite realizar una tokenización, que es el proceso de separar en palabras un texto
unnest_tokens() #me permite separar strings de acuerdo a parámetros que yo defina para cantidad de palabras

#Carga de datasets
Ejemplo_TripAdvisor <- read_csv("datasets/Tripadvisor_Reviews.csv")

#Separar oraciones en palabras sueltas
#declaro la columna que debe funcionar de input y el nombre de aquella que quiero que sea resultado
Tokens_TripAdvisor <- Ejemplo_TripAdvisor %>% 
  unnest_tokens(input = Review, output = "palabra", token = "words", drop = FALSE) 
#como resultado el data frame nuevo agrega una columna palabra y repite todas las demás de acuerdo a la cantidad de palabras

#Puede ser que solo me interese la lista de palabras, en todo caso puedo utilizar drop = TRUE
Tokens_TripAdvisor <- Ejemplo_TripAdvisor %>% 
  unnest_tokens(input = Review, output = "palabra", token = "words", drop = T) 
# de esta forma la columna Rating todavía exite, pero no Review


#Separar palabras en bigramas
Bigram_TripAdvisor <- Ejemplo_TripAdvisor %>% 
  unnest_tokens(input = Review, output = "bigrama", token = "ngrams", n = 2)

#Separar palabras en trigramas
Trigram_TripAdvisor <- Ejemplo_TripAdvisor %>% 
  unnest_tokens(input = Review, output = "trigrama", token = "ngrams", n = 3)




##### LA POTENCIA DE TIDYTEXT Y DPLYR JUNTOS #####
#Separar y contar
#Normalmente la tokenización se emplea, entre otras cosas, para comprender la frecuencia de palabras dentro del texto
#En ese caso solo me interesa seleccionar la columna de texto, aplicar la tokenización y contar la cantidad de veces de cada palabra
Tokens_TripAdvisor2 <- Ejemplo_TripAdvisor %>% 
  select(Review) %>%
  unnest_tokens(input = Review, output = "palabra", token = "words", drop = T) %>%
  count(palabra) %>%
  arrange(desc(n))
#De esta forma el data frame solo tiene 2 columnas, la palabra, y la cantidad de n veces que se repite


#Separar y filtrar
#También puede ser que me interese filtrar palabras porque no me interesa que figuren en la lista
#Para ello puedo crear previamente diccionarios de palabras que quiero excluir y guardarlos en vectores
Tokens_TripAdvisor3 <- Ejemplo_TripAdvisor %>% 
  select(Review) %>%
  unnest_tokens(input = Review, output = "palabra", token = "words", drop = T) %>%
  filter(!palabra %in% c("no", "not", "day", "like")) %>%
  count(palabra) %>%
  arrange(desc(n))
#comparen la cantidad de registros de Tokens_TripAdvisor3 vs Tokens_TripAdvisor2 en Environment, tiene 4 palabras menos


#### EJERCICIO
#Dado el dataset Ejemplo_TripAdvisor, se debe seleccionar la columna "Review" y aplicar tokenización para separarla
#en palabras. Cuenten el número de palabras obtenido y apliquen un filter para que el dataframe solo contenga
#aquellas palabras que se repiten como mínimo 1.000 veces.
#Pista, recuerden que la columna resultante del count se llama "n"
#Cuántas palabras me quedan?
Tokens_TripAdvisor4 <- Ejemplo_TripAdvisor %>% 
  # completa el código


##### FIN. 

