###################MODULO III (4)

#CUIDADO: antes de realizar cualquier analisis hay que comprobar los supuestos de dicho analisis

#************************************************************ANOVA de un factor
#*Vamos a ver si existen diferencias en el gasto de las comunidades de 
#*Andalucia, Baleares y Canarias desde el 2004 hasta el 2017
setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
library(readxl)
gasto <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',col_names = TRUE,skip=1)

variablegrupo<-rep(c("AN","IB","CA"),each=14) # porque queremos revisar 14 anios
gastoAN<- as.data.frame(t(gasto[1,4:17]))
gastoIB<- as.data.frame(t(gasto[2,4:17])) 
gastoCA<- as.data.frame(t(gasto[3,4:17])) 
gastos<- c(gastoAN$V1,gastoIB$V1,gastoCA$V1)
datos<- data.frame(variablegrupo,gastos); str(datos)
by(gastos,variablegrupo,mean)#miramos las medias que queremos comparar

anova(lm(gastos~variablegrupo))
#lm lineal model es el modelo que se usa para calcular el ajuste de los datos
#la primera linea nos habla de la variacion entre grupos
#la segunda nos habla de la variacion dentro de los grupos
#teniendo en cuenta ambas, nos da el estadistico F y su p-valor
#?Conclusion? ?entre que grupos?

# Primera fila, variacion entre grupos
# Segunda fila, variacion dentro de los grupos
# Fvalue es el estadistico
# pvalor = 0.006
# rechazamos la hipotesis nula. Al menos una es diferente.

#*Comparacion por pares:
#*
summary(lm(gastos~variablegrupo))
#nos da una tabla con t-test de cada grupo,
#cogiendo como referencia el primero
# la diferencia importante esta entre andalucia y ca (0.00153)
#PERO ESTO NO ES CORRECTO:

# Necesitamos aplicar correcciones?
pairwise.t.test(gastos, variablegrupo, p.adj="bonferroni")
#cuando hacemos multiples comparaciones, se aumenta la probabilidad
#de encontrar que una de ellas es significativa (los p valores se exageran)
#por lo que es necesario hacer la correccion de Bonferroni:
#basado en que la probabilidad de observar al menos un evento de entre n
#(en nuestro caso, de que una de las 3 comparaciones sea significativa)
#es menor de la suma de las probabilidades de cada evento
#por lo que multiplica cada p-valor por n
#Aunque existen otras correcciones, esta es la mas usada


###################MODULO IV
encuesta<- read.table("encuesta.dat", header=T, dec = ",")
#*Correlacion
#*diagrama de dispersi?n 
#como primera aproximaci?n al estudio de la relaci?n entre dos variables
plot(encuesta$FluidezVerbalEspanol,encuesta$FluidezVerbalIngles)

cor(encuesta$FluidezVerbalEspanol,encuesta$FluidezVerbalIngles)
# correlacion debil, positiva 
#**NAs
encuesta[1,6]<- NA
cor(encuesta$FluidezVerbalEspanol,encuesta$FluidezVerbalIngles)#requiere que no haya NAs
#o, en todo caso, hay que indicarselo:
cor(encuesta$FluidezVerbalEspanol,encuesta$FluidezVerbalIngles,use="complete.obs")
#**
#* Entre varias variables
cor(encuesta[,6:9],use="complete.obs")#tambien se puede obtener una table
#?que tipo de relaciones vemos?
#?nos dicen algo de la poblacion?


cor.test(encuesta$FluidezVerbalEspanol,encuesta$FluidezVerbalIngles)
#?interpretacion?
#?causalidad?

