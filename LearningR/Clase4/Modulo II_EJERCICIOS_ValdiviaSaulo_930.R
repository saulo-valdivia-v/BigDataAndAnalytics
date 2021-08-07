#Ej. Reproduce los ejemplos de histograma, grafico de barras, boxplot y grafico de dispersion que hemos visto
#en clase, pero esta vez usando el paquete de ggplot2

###1. Instalar y cargar el paquete
??ggplot2
library(ggplot2)


###2. Leer el capitulo 4 "Exploring data with graphs"

###3. Hacer un Histograma con las Notas de la PAU de la base de datos "encuesta"
encuesta <- read.table('encuesta.dat', header=T, sep = '\t', dec = ',')
ggplot(data = encuesta, mapping = aes(x = Nota_PAU)) + geom_histogram(bins = 9)

###4. Hacer un Grafico de barras con la variable Sexo de la base de datos "encuesta"
ggplot(data=encuesta, aes(x=Tratamiento, y=Plantas)) + geom_bar(stat="identity", position="stack")
genero<-factor(encuesta$Sexo, levels = c(1,2), labels=c('Hombre', 'Mujer'))

ggplot(data = encuesta,
       mapping = aes(x = factor(genero))) +
  geom_bar() +
  coord_flip()

###5. Hacer un Diagrama de caja y bigotes con la variable Notas de la PAU de la base de datos "encuesta"
ggplot(encuesta, aes(x=encuesta$Nota_PAU)) + geom_boxplot()

###5. Hacer un Grafico de dispersion con la variable Notas de la PAU y Edadde la base de datos "encuesta"
ggplot(encuesta, aes(x=Nota_PAU, y=Edad)) + geom_point()
