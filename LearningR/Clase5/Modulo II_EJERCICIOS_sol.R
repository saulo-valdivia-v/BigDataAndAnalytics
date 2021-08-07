#Ej. Reproduce los ejemplos de histograma, grafico de barras, boxplot y grafico de dispersion que hemos visto
#en clase, pero esta vez usando el paquete de ggplot2

###1. Instalar y cargar el paquete
??ggplot2
library(ggplot2)
setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
encuesta <- read.table("encuesta.dat", header=T, sep="\t",dec=',')

###2. Leer el capitulo 4 "Exploring data with graphs"

###3. Hacer un Histograma con las Notas de la PAU de la base de datos "encuesta"

histograma <-ggplot(encuesta, aes(Nota_PAU)) #crea el objeto pero no el grafico
#tenenmos que meter al objeto las capas del grafico que queremos:

histograma + geom_histogram() #por defecto nos da el numerode obs en el eje y (count)
histograma + geom_histogram(aes(y = ..density..),colour="cyan") #podemos pedirle la proporcion
histograma + geom_histogram(aes(y = ..ncount..))  #y escalar el eje y hasta max=1
histograma + geom_histogram(aes(y = ..ndensity..))

histograma + geom_histogram(binwidth = 0.06) #el aviso nos decia que eligieramos un
#valor diferente para el ancho de las barras para que se pudieran distinguir 
#mejor los valores de x

histograma + 
  geom_histogram(colour="cyan")+
  labs(x = "Nota en la PAU",y ="Numero de estudiantes",
       title = "Histograma")
histograma + 
  geom_histogram(colour="cyan",fill="red4")+
  labs(x = "Nota en la PAU",y ="Numero de estudiantes",
       title = "Histograma")

histograma + 
  geom_histogram(colour="cyan",fill="red4")+
  geom_vline (aes(xintercept=mean(Nota_PAU)),colour="blue",
              linetype="dashed",size=1)

  labs(x = "Nota en la PAU",y ="Numero de estudiantes",
       title = "Histograma")

#otras opciones
qplot(encuesta$Nota_PAU, geom = "histogram",
      binwidth=0.5,
      main = "Histograma con las notas de PAU",
      xlab = "Notas",
      ylab = "Frecuencia",
      fill = I("blue"),
      col = I("red"),
      alpha = I(.2), # Transparencia de las columnas.
      xlim = c(4,8)) # L?mites para el eje x. Esto hace que nos devuelva un warning explicando lo que nos ha 
# filtrado al meter el intervalo. El warning parece citar tambi?n los NA's

###4. Hacer un Grafico de barras con la variable Sexo de la base de datos "encuesta"
barras <-ggplot(encuesta, aes(Sexo))
genero<- factor(encuesta$Sexo, levels = c(1,2), labels = c("Hombre", "Mujer"))
barras <-ggplot(encuesta, aes(genero,fill= genero))

barras+ geom_bar()+
  labs(x = "Género",y ="Número de personas")

barras+ geom_bar()+
  labs(x = "Género",y ="Número de personas")+
  coord_flip()

barras2 <-ggplot(encuesta, aes(Edad,fill= genero))
barras2+ 
  geom_bar()+
  theme(panel.background = element_rect(fill="white"),
        axis.line.y=element_line(colour="black",size=0.2),
        axis.line.x=element_line(colour="black",size=0.2))+
  labs(x = "Edad",y ="Número de personas")

encuesta$Edad[encuesta$Edad > 30] <- NA #quitamos los valores extremos
barras2 <-ggplot(encuesta, aes(Edad,fill= genero))
barras2+ geom_bar()+
  labs(x = "Edad",y ="Número de personas")

barras2 <-ggplot(encuesta, aes(Edad,fill= genero))
barras2+ 
  geom_bar()+
  theme_classic()+
  labs(x = "Edad",y ="Número de personas")
  
library(ggthemes)#libreria para cambiar el fondo de los graficos

###5. Hacer un Diagrama de caja y bigotes con la variable Notas de la PAU de la base de datos "encuesta"
box <-ggplot(encuesta, aes(Sexo,Nota_PAU))#no podemos diferenciar 
#en genero porque no nos importa Sexo como character

genero<- factor(encuesta$Sexo, levels = c(1,2), labels = c("Hombre", "Mujer"))
box <-ggplot(encuesta, aes(genero,Nota_PAU)) #si la convertimos a factor, nos crea 
#un boxplot para cada valor de Sexo

box+
  geom_boxplot()+
  labs(x = "Género",y="Nota en la PAU")
#nos permite ver los cuartiles (primero, mediana y tercero)

box+
  geom_boxplot(outlier.shape = "*",outlier.size = 6)+
  labs(x = "Género",y="Nota en la PAU")

box+
  geom_boxplot(outlier.shape = "*",outlier.size = 6)+
  geom_jitter(width=0.1,colour="blue")+
  labs(x = "Género",y="Nota en la PAU") #nos muestra los valores concretos

ggsave("H:/CLASES DE R EN BUSINESS SCHOOL/Grupo1/boxplot.jpg")
#si solo metemos ruta+nombre del archivo, guarda el ultimo grafico que hemos hecho

ggsave("barras2.jpg",graficodebarras)
#aqui le espeficicamos el grafico que queremos guardar

###6. Hacer un Grafico de dispersion con la variable Notas de la PAU y  Edad de la base de datos "encuesta"
dispersion <-ggplot(encuesta, aes(Edad, Nota_PAU))

dispersion+
  geom_point()+
  labs(x = "Edad", y = "Nota en la PAU")

dispersion+
  geom_point(size=2.5)+
  labs(x = "Edad", y = "Nota en la PAU")

dispersion+
  geom_point(size=2.5,colour="Blue")+
  labs(x = "Edad", y = "Nota en la PAU")

#-----------DIFFERENCIAR GÉNERO POR COLORES-------
dispersion+
  geom_point(size=2.5,colour = encuesta$Sexo)+
  labs(x = "Edad", y = "Nota en la PAU")#como no lo he indicado en la linea principal
#en color le tengo que decir de donde vienen los datos de Sexo

dispersion+
  geom_point(size=2.5,
                      aes(colour = Sexo))+
  labs(x = "Edad", y = "Nota en la PAU")#con aes, no le tengo que indicar de donde coger los 
#datos y me crea una leyenda

dispersion2 <-ggplot(encuesta, aes(Edad, Nota_PAU,colour = Sexo))
dispersion2+
  geom_point()+
  labs(x = "Edad", y = "Nota en la PAU")

dispersion2 <-ggplot(encuesta, aes(Edad, Nota_PAU,colour = genero))
dispersion2+
  geom_point()+
  labs(x = "Edad", y = "Nota en la PAU")

#----------------------AÑADIR LINEA DE REGRESION-------------------------------

dispersion+
  geom_point()+
  geom_smooth(method = "lm")+
  labs(x = "Edad", y = "Nota en la PAU")# para crear una linea de regresion con el
#intervalo de confianza del 95% (ya lo veremos)

library(quantreg)
dispersion <-ggplot(encuesta, aes(Nota_PAU,Edad))
dispersion+
  geom_point()+
  geom_quantile()+
  labs(x = "Edad", y = "Nota en la PAU")

  
