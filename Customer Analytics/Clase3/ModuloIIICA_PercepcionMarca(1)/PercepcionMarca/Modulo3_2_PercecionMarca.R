#Otro an?lisis fundamental para los equipos de Marketing es comprender la salud de marca,
#es decir, comprender la percepci?n de los usuarios sobre los atributos principales de marca
#que han sido definidos por el propio marketer y que suelen medirse en 4 olas anuales.
#Es importante comprender que en estas mediciones se realizan muchas preguntas a los usuarios
#y que muchas veces los dataset resultantes son bastante complejos y es necesario "reducir" la
#data a nuevas dimensiones que sigan expresando la misma informaci?n, pero de forma condensada

#En el caso de la medici?n de percepci?n de marca se suele emplear el PCA (Principal Component Analysis)
#como t?cnica para normalizar las variables ya que busca capturar la mayor variabilidad de data 
#a trav?s de la identificaci?n de 

library(tidyverse) #transformar y visualizar la data
#library(psych) #normalizar los datos
library(corrplot) #graficar correlaciones

#cargamos los datos, asegurando que se generan 10 columnas con los valores
Encuesta_Marcas <- read.csv("PercepcionMarca_dataset.csv", stringsAsFactors = F) %>%
  select(-1) %>% #la primera columna es el index de cada fila y no es relevante, la descarto
  mutate(brand = as.factor(brand))

head(Encuesta_Marcas)
summary(Encuesta_Marcas)
table(Encuesta_Marcas$brand)

#graficamos la correlaci?n entre los datos para ir explorando la relaci?n entre diferentes adjetivos
corrplot(cor(Encuesta_Marcas[ , 1:9]), order="hclust")


#Por ultimo, vemos rapidamente que caracteristicas esten asociadas con cada marca con un heatmap
#Para ello es necesario crear una matrix con la media de puntuacion
Encuesta_MarcasMedia <- aggregate(. ~ brand, Encuesta_Marcas, mean)
row.names(Encuesta_MarcasMedia) <- Encuesta_MarcasMedia$brand
Encuesta_MarcasMedia$brand <- NULL
#luego dibujamos el heatmap
heatmap(as.matrix(Encuesta_MarcasMedia)) 
# de esta forma comprendemos los principales atributos asociados a cada una de las marcas
#aspecto fundamental para los equipos de marketing



##### PRINCIPAL COMPONENT ANALYSIS #####
# Aplicando prcomp podemos analizar cuantos componentes son necesarios
#para explicar la variabilidad en la data de la encuesta de percepcion
EncuestaMarcas_PCA <- prcomp(Encuesta_Marcas[ , 1:9])
summary(EncuestaMarcas_PCA) #al ser una lista, con summary podemos entender qu? hay dentro
#en este caso se identiican los 9 adjetivos como componentes relevantes

plot(EncuestaMarcas_PCA, type="l") #type l indica gr?fico de linea

biplot(EncuestaMarcas_PCA)
biplot(EncuestaMarcas_PCA, choices = c(1,9), cex = c(0.3, 0.6))
biplot(EncuestaMarcas_PCA, choices = 3:4, cex = c(0.3, 0.6))

#Que sucede si trabajamos con los means?
Encuesta_MarcasMedia2 <- aggregate(. ~ brand, Encuesta_Marcas, mean)
EncuestaMarcas_PCAMean <- prcomp(Encuesta_MarcasMedia2[ , -1])
summary(EncuestaMarcas_PCAMean)
#Utiliza summary para ver cuantos componentes existen

#Realiza un biplot de los diferentes componentes
#Qu? relaciones se establecen? Similares al heatmap



##### DATA NORMALIZADA PARA PCA #####

#Utilizamos la funcion scale para "normalizar" los datos a traves de la media y la sd 
#por las dudas primero duplicamos el data frame para no perder la data inicial
describe(Encuesta_Marcas)
Encuesta_MarcasScale <- Encuesta_Marcas
Encuesta_MarcasScale[ , 1:9] <- (scale(Encuesta_Marcas[ , 1:9]))

#utilizamos describe de librer?a psych que es para psicologia, pero muy util
#vemos ahora que mean y kurtosis es 0, lo que ha dejado la data bastante uniforme
describe(Encuesta_MarcasScale) 
corrplot(cor(Encuesta_MarcasScale[ , 1:9]), order="hclust") #pero la correlacion se mantiene igual

Encuesta_MarcasScale_PCA <- prcomp(Encuesta_MarcasScale[ , 1:9])
summary(Encuesta_MarcasScale_PCA) #al ser una lista, con summary podemos entender qu? hay dentro
#en este caso se identiican los 9 adjetivos como componentes relevantes

plot(Encuesta_MarcasScale_PCA, type="l") 
#los primeros 4 componentes son los mas relevantes

#veamos como se organizan los datos teniendo en cuenta los 2 primeros componentes
biplot(Encuesta_MarcasScale_PCA, cex = c(0.3, 0.6))
#vemos que se forma los siguientes ejes: serious/fun y trendy/value

#Podriamos analizar todas las posibles combinaciones de los 4 primeros componentes
biplot(Encuesta_MarcasScale_PCA, choices = c(1,3), cex = c(0.3, 0.6))
biplot(Encuesta_MarcasScale_PCA, choices = c(1,4), cex = c(0.3, 0.6))
biplot(Encuesta_MarcasScale_PCA, choices = 3:4, cex = c(0.3, 0.6))

#pero vemos que la lógica correcta de ejes es el biplot de los 2 primeros componentes
#porque me define un eje claro

#Empleando medias de cada marca podemos entender donde se posicona cada marca
Encuesta_MarcasMedia_PCA <- prcomp(Encuesta_MarcasMedia2[ , -1], scale. = T)
summary(Encuesta_MarcasMedia_PCA) 

biplot(Encuesta_MarcasMedia_PCA, cex = c(0.9, 0.6))
#vemos que las marcas a y j son asociadas a fun
#c y d con leader/serious

biplot(Encuesta_MarcasMedia_PCA, main="Posicionamiento Percibido", cex=c(0.8, 0.5))


#Grafiquemos de forma armonica los resultados de PCA con otros paquetes
#que ayudar a generar contenidos más vistosos como es factoextra
install.packages("factoextra")
library("factoextra")
get_pca_var(EncuestaMarcas_PCA) #me permite identificar el nombre de las variables

fviz_pca_var(EncuestaMarcas_PCA, col.var = "blue")

fviz_pca_var(EncuestaMarcas_PCA, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # evita overlaping del texto
             )


fviz_pca_var(Encuesta_MarcasMedia_PCA, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)


fviz_pca_ind(Encuesta_MarcasMedia_PCA, col.ind = "cos2",
             col.var="contrib",
             habillage = Encuesta_MarcasMedia2$brand,
             repel = TRUE)
