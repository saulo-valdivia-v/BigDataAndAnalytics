# MÓDULO VI - TEXT ANALYTICS-MARCELO MIGUEL CONTRERAS MUÑOZ

#En este ejercicio realizamos un análisis de la conversación en Twitter alrededor de la marca Zara.
#Realizaremos un análisis exploratorio utilizando las técnicas vistas en clase. Finalmente,
#aplicaremos un análisis de sentimiento y modelado de tópicos, que nos permitan profundizar
#en los documentos (tweets) extraídos y en la conversación alrededor de la marca.

#Para completar el ejercicio deberan cargar las siguientes librerías:

library(tidyverse)
library(stringr)
library(rtweet)
library(readtext)
library(tidytext)
library(udpipe)
library(quanteda)
library(syuzhet)
#install.packages("topicmodels")
library(topicmodels)


#PISTA: Las librerias fueron utilizadas en los ejercicios prácticos del módulo de Text Analytics 
#Pueden revisar esos script como referencia para esta tarea


#PASO 1
#Realizamos una búsqueda en Twitter utilizando la query de búsqueda "Zara". Fijamos los parámetros:
# n= 18000 (límite máximo permitido de descarga de registros, es posible que se crearan menos tweets en el intervalo temporal seleccionado)
# include_rts= FALSE
# lang= "es"

#PISTA: consulta la ayuda de la función search_tweets

Tweets_Zara <- search_tweets(q="Zara", n = 18000, include_rts = FALSE, lang= "es")

#Inspecciona el dataframe
#El dataset descargado contiene 90 columnas, pero no nos interesan todas. Selecciona las columnas:
library(dplyr)
Tweets_Zara<-Tweets_Zara %>% 
  select(created_at, screen_name, text, favorite_count, retweet_count, lang, status_url, name, location,description, followers_count, friends_count, statuses_count)

#Convierte el texto en minúsculas. PISTA: utiliza la librería stringr
Tweets_Zara<- Tweets_Zara %>% 
  mutate(text_min=str_to_lower(Tweets_Zara$text))

#Convierte la fecha de creación en Date

Tweets_Zara$created_at<- as.Date(Tweets_Zara$created_at, '%Y-%m-%d')

#Sustituye las letras acentuadas por letras sin acentuar. PISTA: utiliza la librería stringr

Tweets_Zara$text_min <- str_replace(Tweets_Zara$text_min,"á","a") 
Tweets_Zara$text_min <- str_replace(Tweets_Zara$text_min,"é","e") 
Tweets_Zara$text_min <- str_replace(Tweets_Zara$text_min,"í","i")
Tweets_Zara$text_min <- str_replace(Tweets_Zara$text_min,"ó","o")
Tweets_Zara$text_min <- str_replace(Tweets_Zara$text_min,"ú","u")

#Inspecciona de nuevo el dataset con summary, str y head.

summary(Tweets_Zara) # los muestras estadisticos basicos para las columnas numericas y contadores para las de texto
str(Tweets_Zara) #tipo de datos que contiene nuestra data
head(Tweets_Zara) #los primeros 6 registros del data

#Verifica que el texto se transformó en minúsculas y que las letras con acento se sustituyeron por letras sin acentuar
#¿Cuántos registros (tweets) contiene el dataset?

view(Tweets_Zara)

#antes de realizar los cambios miré alguna palabras acentuadas como por ejemplo:álbum y  no sé que, luego de aplicar 
#str_replace a través de view podemos apreciar que elimino las tildes 

dim(Tweets_Zara) # con esta fiuncion podemos verificar las dimensiones de la data en cuanto a sus filas y columnas
#el data set contiene 7103 tweets
length(Tweets_Zara$text_min)# con está función tambien podemos conocer la cantidad.

#Añade una nueva columna al dataset que unifique el volumen total de interacciones
#La columna se debe llamar "interacciones" y se calcula como la suma de favorite_count y retweet_count para cada registro

Tweets_Zara<- Tweets_Zara %>% 
  mutate(interacciones=favorite_count+retweet_count)

# PASO 2 
#Analizamos los datos extraídos y respondemos a preguntas sobre los datos

#Visualiza el número de tweets por día. ¿En qué día se crearon más tweets?

tweeds_dia<-Tweets_Zara %>%
  group_by(created_at) %>% 
  summarise(tweeds_por_dia=length(text))

#El día que se crearon la mayor cantidad de tweeds fue el 15 de diciembre con 883 tweeds

#GRAFICANDO LA CREACIÓN DE TWEEDS POR DÍAS
library(ggplot2)

ggplot(tweeds_dia)+
  geom_line(aes(created_at,tweeds_por_dia),color="black")+
  geom_point(aes(created_at,tweeds_por_dia,size=tweeds_por_dia),color=factor(tweeds_dia$tweeds_por_dia))+
  geom_text(aes(x = created_at,y=tweeds_por_dia, label = tweeds_por_dia), vjust = -1)+
  xlab('Días')+ ylab('Cantidad')+
  ylim(0, 1000)+
  ggtitle('Cantidad de Tweeds por días')+
  theme_classic()



#Calcula el número total (suma) de interacciones por día. Represéntalo gráficamente
#¿En qué día hubo más interacciones?

#primero creamos una variables para poder tener una tabla con el resumen y que despues me sirva para crear un grafico
#para hacer más visual la distribuión de los tweed por días.

interacciones_dia<-Tweets_Zara %>%
  group_by(created_at) %>% 
  summarise(interacciones_por_dia=sum(interacciones))

#GRAFICANDO LA CREACIÓN DE INTERACCIONES POR DÍAS
library(ggplot2)

ggplot(interacciones_dia)+
  geom_line(aes(created_at,interacciones_por_dia),color="black")+
  geom_point(aes(created_at,interacciones_por_dia,size=interacciones_por_dia),color=factor(interacciones_dia$interacciones_por_dia))+
  geom_text(aes(x = created_at,y=interacciones_por_dia, label = interacciones_por_dia), vjust = -1)+
  xlab('Días')+ ylab('Cantidad')+
  ylim(0, 7000)+
  ggtitle('Cantidad de Interacciones por días')+
  theme_classic()

#Podemos apreciar que el día que hubo más interacciones fue el 15-12-2020 con 5002 interacciones



#¿Qué cuentas (screen_name) tienen mayor (max) número de followers? Pista, necesito utilizar la columna followers_count

cuentas_mayor_seguidores<-Tweets_Zara %>%
  group_by(screen_name) %>% 
  summarise(Cantidad_de_Seguidores=max(followers_count)) %>% 
  arrange(desc(Cantidad_de_Seguidores)) %>% 
  head(3)

#Los Top 3 de las cuentas que tienen mayor cantidad de seguidores son:
#ElUniversal con 5079501, revisando es un canal de noticias Venezuela
#RevistaSemana con 4568409, periodismo colombia 
#biobio con 3271481, página noticias Chile

#¿Cuál fue el tuit con más retweets? Pista, necesito utilizar la columna retweet_count

tuit_max_retweeds<-Tweets_Zara %>%
  filter(retweet_count==max(retweet_count)) %>% 
  select(text,retweet_count)

#ESTE ES EL TWEED CON MÁS RETWEEDS: 
##ZARA (+ 10 AÑOS) CÁCERES Bienvenida abuelita de ojos tristes Es dulce, buena y tranquila. 
#Está desnutrida y herida de convivir con muchos más perros de caza... También tiene cataratas, 
#por lo que no ve bien. Necesita una familia ha tenido una vida dura huellassinvoz@gmail.com https://t.co/lPCxJEufiz

#ES SOBRE UN PERRO DE LA CALLE LLAMADO ZARA DE +10AÑOS QUE BUSCA FAMILIA ,POR LO QUE VEMOS NO NECESARIAMENTE EL QUE CONTENGA LA PALABRA ZARA VA A SIGNIFICAR QUE ESTAN HABLANDO DE LA TIENDA.

#¿Cuál fue el tuit con más likes? Pista, necesito utilizar la columna favorite_count

tuit_max_likes<-Tweets_Zara %>%
  filter(favorite_count==max(favorite_count)) %>% 
  select(text,favorite_count)

#el tweed con más like es: Viene Zara al shopping mi sueldo está llorando
#al parecer lo que quizo decir es: Vine a Zara de Shopping, mi sueldo está llorando, esto hace mucho más sentido
#que el tweed original.


#PASO 3
#Tokenizamos el texto, separándolo en palabras y contando el número de palabras.
#Utiliza la función unnest_tokens() de la librería tidytext para tokenizar el texto
#Cuenta el número de palabras y ordenálas en orden descendente según su frecuencia
#PISTA: utiliza el parámetro token= "tweets". Consulta la ayuda de la función unnest_tokens()


#declaro la columna que debe funcionar de input y el nombre de aquella que quiero que sea resultado


Tokens_Zara<- Tweets_Zara %>%
  select(text_min) %>% 
  unnest_tokens(input = text_min, output = "palabra", token = "tweets", drop = F) %>% 
  count(palabra) %>%
  arrange(desc(n))
#Ahora el data frame solo tiene 2 columnas, la palabra, y la cantidad de n veces que se repite

#Filtramos menciones y visualizamos hashtags
#Excluye menciones del dataframe tokenizado Tweets_Zara_Token.
#PISTA: utiliza filter() junto con str_detect() con pattern = "@[:alnum:]", consulta el script 2_Libreria_RTWEET
#Crea un dataframe que contenga los hashtags. PISTA: consulta el script 2_Libreria_RTWEET
Hashtags_Zara <- Tokens_Zara %>%
  filter(str_detect(palabra, pattern = "#[:alnum:]")) #extraemos la lista de hashtags y su frecuencia

Menciones_Zara <- Tokens_Zara %>%
  filter(str_detect(palabra, pattern = "@[:alnum:]")) #extraemos todos los tweets donde usuarios son mencionados


#Representamos los hashtags como un wordcloud utilizando la librería wordcloud, que no fue introducida en las sesiones prácticas
#Puedes hacer pruebas y variar los parámetros max.words, min.freq, scale, etc para observar como varía el resultado
#install.packages("wordcloud")
library(wordcloud)
wordcloud(
  words = Hashtags_Zara$palabra, 
  freq = Hashtags_Zara$n, 
  max.words = 40,
  min.freq = 3,
  scale =c(3,0.60),
  random.order = T, 
  rot.per = 0.3, random.color = T,
  color = brewer.pal(4, "BrBG"))
#a través de esta grafica podemos ver que el # con más frecuencia es el de ZARA a simple vista

#PASO 4
#Realizamos un análisis de sentimiento utilizando la librería SYUZHET
#A diferencia del script 6_Libreria_SYUZHET, donde aplicamos un análisis de sentimiento por palabra (token),
#en este caso apliqueremos la función get_nrc_sentiment a cada tweet (documento)

#Como el dataset es relativamente grande, en esta sección trabajaremos con una muestra.
#Seleccionamos una muestra de 500 tweets de forma aleatoria utilizando la función sample.
Dataset_Zara_subset <- Tweets_Zara[sample(nrow(Tweets_Zara), size=500), ]

#La función get_nrc_sentiment de la librería Syuzhet permite visualizar las emociones y sentimiento
#Analiza 8 "emociones": anger, anticipation, disgust, fear, joy, sadness, surprise y trust
#Así como la polaridad positivo o negativo.

#Utilizamos la función get_nrc_sentiment() con el parámetro language= "spanish"
Analisis_NRC <- get_nrc_sentiment(char_v = Dataset_Zara_subset$text_min, language = "spanish")

#Inspecciona el resultado utilizando View()
view(Analisis_NRC)

#Unificamos el resultado y el dataframe de partida Dataset_Zara_subset, utilizando la función cbind()
Analisis_NRC_df <- cbind(Dataset_Zara_subset, Analisis_NRC)

#Inspecciona de nuevo el resultado utilizando summary

summary(Analisis_NRC_df)
# Observa los valores mínimo, máximo y medio para cada una de las 8 emociones y para las columnas negative/positive

#la media más alta corresponde al sentimiento positivo con un 0.69 por tweeds ,le sigue el negativo con un 0.5 de media
# pordriamos decir que el sample escogido hay una tendencia a contener más palabras positivas que  negativas.

# 1) Calcula la suma total de la columna positive

positivo<-Analisis_NRC_df %>% 
  summarise(positivo=sum(positive))

#la suma total de positios es 345 palabras

# 2) Calcula la suma total de la coluna negative.
negativo<-Analisis_NRC_df %>% 
  summarise(negativo=sum(negative))

#la suma total de positios es 250 palabras

# ¿La polaridad de la conversación es positiva o negativa?. PISTA: resta el total negativo al total positivo

positivo-negativo

#la polaridad es positiva lo que correponde con el analisis realizado en base a la media segun el summary
#por lo que los tweed hablan más de cosas positivas que negativas

#Finalmente podemos analizar el porcentaje de cada emoción en la conversación
#Solución: utilizamos la función prop.table y colSums para obtener el porcentaje de cada emoción
# La función prop.table divide el valor de cada celda entre la suma total de filas y columnas (% de la celda)
# La función colSums() suma el valor de todas las celdas de cada columna (% de la columna)
Analisis_NRC_emotions <- colSums(prop.table(Analisis_NRC_df[c("anger", "anticipation", "disgust", "fear",
                                                              "joy", "sadness", "surprise", "trust")]))
sort(Analisis_NRC_emotions*100, decreasing= TRUE)

#Inspeccionamos ejemplos
angry_items <- which(Analisis_NRC_df$anger > 0)
Analisis_NRC_df[angry_items, "text"]

joy_items <- which(Analisis_NRC_df$joy > 0)
Analisis_NRC_df[joy_items, "text"]

#Nota: este ejercicio es un ejemplo de cómo trabajar con la librería Syuzhet y realizar un análisis de sentimiento
# En un caso real, se debe analizar y limpiar en profundidad el conjunto de documentos (tuits en este caso),
# por ejemplo eliminando menciones, urls y documentos (tuits) no relevantes del análisis de sentimiento.


#PASO 5
#Analizamos el dataset utilizando la libería udpipe.

#Descargamos y cargamos el modelo para español. 
ud_model <- udpipe_download_model(language = "spanish")
ud_model <- udpipe_load_model(ud_model$file) #Esta línea no se ejecuta correctamente si existe más de un modelo en el directorio de nuestro ordenador
ud_model <- udpipe_load_model(file= "spanish-gsd-ud-2.5-191206.udpipe") #Al especificar el nombre del modelo a cargar, aseguramos que sí cargue el modelo correctamente

#Lo aplicamos sobre la columna del texto de tuits, generando 14 variables
Dataset_Zara_ud <- udpipe_annotate(ud_model,
                                   x = Tweets_Zara$text_min,
                                   parallel.cores = 2)

#Convertimos en data frame. Inspecciona el resultado, revisa las variables generadas por la función udpipe_annotate()
Dataset_Zara_ud <- as.data.frame(Dataset_Zara_ud)

#Observa que los signos de puntuación no han sido eliminados
#Utilizando la columna "token", elimina los signos de puntuación y las menciones
#PISTA: para eliminar signos de puntuación utiliza el patrón "[:punct:]". Revisa la cheatsheet de stringr vista en clase.

Dataset_Zara_ud_replace <- Dataset_Zara_ud %>%
  mutate(token = str_replace_all(token, '[[:digit:]]','')) %>%
  mutate(token = str_replace_all(token, '[[:punct:]]','')) %>% 
  mutate(token = str_replace_all(token,"\\@", "")) 



#Analicemos los adjetivos
Adjetivos_Zara <- Dataset_Zara_ud_replace %>%
  filter(upos == "ADJ") %>%
  count(token) %>%
  arrange(desc(n))

wordcloud(
  words = Adjetivos_Zara$token, 
  freq = Adjetivos_Zara$n, 
  max.words = 80,
  min.freq = 5,
  scale =c(4.8,0.4),
  random.order = T, 
  rot.per = 0.3, random.color = T,
  color = brewer.pal(4, "BrBG"))

#podemos apreciar que los adjetivos que más se encuentran son las palabras: bueno, elegante,hermosa,barato,perfecto.
#lo que indica que son más bien adjetivos positivos

#Analiza los verbos y representa un wordcloud como hemos hecho en el caso de los adjetivos
#PISTA: utiliza la condición de filtrado upos == "VERB"

Verbos_Zara <- Dataset_Zara_ud_replace %>%
  filter(upos == "VERB") %>%
  count(token) %>%
  arrange(desc(n))

wordcloud(
  words = Verbos_Zara$token, 
  freq = Verbos_Zara$n, 
  max.words = 80,
  min.freq = 5,
  scale =c(4.8,0.4),
  random.order = T, 
  rot.per = 0.3, random.color = T,
  color = brewer.pal(4, "BrBG"))

#vemos que el algoritmo no es bueno en los verbos solo encuentra algunos como: comprar, hacer, revisar
# por lo tanto su clasificacion no es bueno, coloca más sustantivos.

#Nota: observa que "Zara" ha sido incorrectamente clasificado como Adjetivo y como Verbo. OK CONFIRMADO
#De la misma forma, otros tokens no fueron clasificados correctamente. DE ACUERDO
#En un caso real, sería necesario corregir estos defectos en la anotación del dataframe.

#Leemos el resultados de los pasos anteriores
Dataset_Zara_ud_2 <- read.csv("datasets/Dataset_Zara_ud.csv")


#PASO 6
#Realizamos un modelado de tópicos utilizando la librería topicmodels
#El objetivo es identificar temas en la conversación en Twitter sobre la marca Zara

#Para ello realizamos los siguientes pasos:
# - Seleccionamos nombres y adjetivos
# - Excluímos palabras muy frecuentes en los documentos pero sin significado relevante,
#   como el término de búsqueda de tuits "Zara" o palabras como "gracias", "por favor", etc.
# - Trabajamos con el id de documento (doc_id) y el lema (token lematizado)

#Nota: la libería topicmodels está construida utilizando objetos del paquete tm. Para poder ejecutar funciones
#de este paquete, debemos transformar en Document Term Matrix (dtm) utilizando la función cast_dtm()
Modelo_Zara <- Dataset_Zara_ud_2 %>% 
  filter(upos %in% c("NOUN", "ADJ")) %>% 
  filter(!token %in% c("zara", "gracias", "por", "favor", "vez")) %>%
  select(id = doc_id, word = lemma) %>%
  mutate(id = str_replace_all(id, "doc", "")) %>% 
  count(word, id) %>% 
  cast_dtm(id, word, n)

#Generamos varios modelos, variando el número de temas definido en cada modelo (parámetro k)
#Utilizamos la función LDA() del paquete topicmodels
set.seed(1234)
Modelo_Zara_LDA <- LDA(Modelo_Zara, k = 3, control = list(seed = 1234))
Modelo_Zara_LDA2 <- LDA(Modelo_Zara, k = 5, control = list(seed = 1234))
Modelo_Zara_LDA3 <- LDA(Modelo_Zara, k = 8, control = list(seed = 1234))

#Transformamos en formato tidy (tibble data.frame) utilizando la función tidy()
Zara_topics <- tidy(Modelo_Zara_LDA, matrix = "beta")
Zara_topics2 <- tidy(Modelo_Zara_LDA2, matrix = "beta")
Zara_topics3 <- tidy(Modelo_Zara_LDA3, matrix = "beta")

#Inspecciona los dataframes. Puedes realizar una primera inspección ordenando de forma descendente utilizando la columa beta

Zara_topics %>% 
  arrange(desc(beta))

Zara_topics2 %>% 
  arrange(desc(beta))

Zara_topics3  %>% 
  arrange(desc(beta))


#Seleccionamos los top terms de cada modelo y los visualizamos
## Modelo k=3
Zara_top_terms <- Zara_topics %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

library(ggplot2)
Zara_top_terms_facet <- Zara_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered();Zara_top_terms_facet

## Modelo k=5
Zara_top_terms2 <- Zara_topics2 %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

Zara_top_terms_facet2 <- Zara_top_terms2 %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered();Zara_top_terms_facet2

## Modelo k=8
Zara_top_terms3 <- Zara_topics3 %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

Zara_top_terms_facet3 <- Zara_top_terms3 %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  theme(axis.text=element_text(size=7)) +
  scale_x_reordered();Zara_top_terms_facet3 #reorder_within y scale_x_reordered permiten ordenar en cada facet (tema)


#Seleccionamos el modelo k=5
#Intenta describir cada uno de los 5 temas identificados, revisando las palabras con mayor probabilidad
#(beta) de pertenecer a cada tema
#PISTA: ejecuta el objeto Zara_top_terms_facet2 para realizar un análisis visual
Zara_top_terms_facet2

#tema1: nos habla sobre ropa,marca,año nuevo , navidad todo relacionado a este mes por lo tanto nos dice que la
#probabilidad (beta) para este periodo serán palabras de esta indole

#tema2: nos habla más sobre lo relacionado a los pedidos y la compra

#tema3: este tema tomo palabras envios pedios y hombre

#tema4: el mayor beta aparece la pabra cosa en general este tema no nos dice mucho sobre la tienda en los primeros betas

#tema 5: es un tema en donde la palabra que má lalma la atención es vestido y casa

#en general las palabras son relacionadas a la epoca de navidad y orientadas a la vestimenta, no se ven palabras negativas
#en los temas, tenemos mayor probabilidad en palabras como: ropa,tienda, pedido,gente,hola,regalo.


#Finalmente, utilizando un wordcloud visualizamos las palabras más relevantes por tópico.
#Por ejemplo, para el tópico número 2
Zara_wordcloud <- Zara_topics2 %>%
  filter(topic == "2") %>%
  arrange(topic, -beta) %>% 
  mutate(beta = beta * 1000)

wordcloud(
  words = Zara_wordcloud$term, 
  freq = Zara_wordcloud$beta, 
  max.words = 40,
  min.freq = 5,
  scale =c(3,0.2),
  random.order = F, 
  rot.per = 0.1, random.color = T,
  color = brewer.pal(4, "BrBG"))


