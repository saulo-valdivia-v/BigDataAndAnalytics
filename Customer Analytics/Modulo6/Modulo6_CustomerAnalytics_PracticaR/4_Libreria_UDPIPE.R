#Librería udipipe

#Documentación y ejemplos: https://cran.r-project.org/web/packages/udpipe/index.html
#Vignettes de udpipe:
# https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-annotation.html
# https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-usecase-postagging-lemmatisation.html

#Instalamos la librería
#install.packages("udpipe")

#Llamamos la librería para poder acceder a sus funciones
library(udpipe)
library(readtext)

#Cargamos el fichero de reseñas de Trip Advisor
##reviews_tripadvisor <- read_csv("datasets/Tripadvisor_Reviews.csv") 
reviews_tripadvisor <- readtext("datasets/Tripadvisor_Reviews.csv",
                                text_field= "Review", docvarnames= "Rating")

# Descargamos y cargamos en memoria el modelo de lenguaje en inglés
#ud_model <- udpipe_download_model(language = "spanish")
ud_model <- udpipe_download_model(language = "english")

#ud_model <- udpipe_load_model(ud_model$file)
ud_model <- udpipe_load_model(file= "english-ewt-ud-2.4-190531.udpipe")


# Tokenising, Lemmatising, Tagging and Dependency Parsing Annotation of raw text
reviews_tripadvisor_reduced <- head(reviews_tripadvisor, 300)
reviews_tripadvisor_ud <- udpipe_annotate(ud_model,
                                          x = reviews_tripadvisor_reduced$text,
                                          doc_id = reviews_tripadvisor_reduced$doc_id,
                                          parallel.cores = 2)

# Convertimos en data frame
reviews_tripadvisor_ud <- as.data.frame(reviews_tripadvisor_ud)
View(reviews_tripadvisor_ud)


##### FIN. 
