#Ejercicios Modulo IV

#Ej. 1. Con la base de datos encuesta.dat
setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
encuesta <- read.table("encuesta.dat", header=T, sep="\t",dec=',')

#1.1. Haz un análisis que ponga a prueba si la fluidez verbal en español
#puede predecir la fluidez verbal en ingles

summary(lm(encuesta$FluidezVerbalIngles~encuesta$FluidezVerbalEspanol))

#1.2.Interpreta y representa los resultados

plot(encuesta$FluidezVerbalIngles~encuesta$FluidezVerbalEspanol)
abline(lm(encuesta$FluidezVerbalIngles~encuesta$FluidezVerbalEspanol))
#*
library(ggplot2)
dispersion <-ggplot(encuesta, aes(FluidezVerbalEspanol, FluidezVerbalIngles))

dispersion+
  geom_point()+
  geom_smooth(method = "lm")+
  labs(x = "Fluidez Verbal en Español", y = "Fluidez Verbal en Ingles",
       title="Recta de regresion de fluidez verbal en inglés sobre 
       la fluidez verbal en español")

#1.3. Haz el pronostico de la fluidez verbal en inglés de una persona 
#con fluidez verbal en español = 12

#manualmente:
Y <- 1.09690 + 0.28931 * 12; Y

#con la funcion fitted
modelo <- lm(encuesta$FluidezVerbalIngles~encuesta$FluidezVerbalEspanol)

modelo$fitted.values #valores estimados de fluidez ingles para cada persona 
#en base a los valores de fluidez en español
modelo$residuals#diferencia entre los valores estimados en fluidez ingles
#y los observados

#MIRAR OBS 9 como ejemplo

#tambien podeis generar la recta de esta forma 
#(necesitareis indicarle los valores X)
B0<-modelo$coefficients[1]
B1<-modelo$coefficients[2]
y<- B0 + B1*X

#1.4. Comprueba los supuestos
##LINEALIDAD
plot(encuesta$FluidezVerbalIngles,encuesta$FluidezVerbalEspanol)
cor.test(encuesta$FluidezVerbalIngles,encuesta$FluidezVerbalEspanol)

##NORMALIDAD

hist(modelo$residuals)

boxplot(modelo$residuals)#mirar centro (mediana);
#dispersión (bigote); 
#casos atípicos o extremos

qqnorm(modelo$residuals, main="Q-Q plot de los residuos del modelo");qqline(modelo$residuals,distribution = qnorm)

library(psych)
describe(modelo$residuals)#asimetria <2 y curtosis <7

ks.test(modelo$residuals, "pnorm")
shapiro.test(modelo$residuals)#con muestras menores a 50

#aunque los test estadisticos nos indican que no siguen distribucion normal
#podria deberse a la leve desviacion que se aprecia en el QQ plot 
#o en el boxplot

##HOMOCEDASTICIDAD
plot(fitted(modelo),resid(modelo))
#dispersion de los pronosticos en base a los residuos
#la nube de puntos no queda aclaro que esté distribuida homogéneamente 
#en torno al valor cero del eje vertical 

##INDEPENDENCIA
plot(encuesta$FluidezVerbalIngles,resid(modelo))
#los residuos no estan aleatoriamente repartidos
library(lmtest)
dwtest(modelo)#Durbin-Watson debe estar entre 1.5-2.5


##PARA TODOS LOS GRAFICOS 
plot(modelo)
#grafico 1: Homocedasticidad, la linea tiene que ser mas o menos horizontal en 0
#grafico 2: Normalidad, los valores tienen que seguir aproximadamente la linea recta
#grafico 3: Homocedasticidad, los puntos deben estar igual de distribuidos por todo el grafico
#grafico 4: identifica valores extremos que podrian estar afectando al resultado
#los residuos estandarizados (residuos / su error estandar)
#se interpretan como el numero de errores estandar que estan alejados 
#de la linea de regresion. Las observaciones con |residuos estandarizados| > 3
#son posibles outliers (Valores extremos)
#la distancia de Cook indica la influencia (leverage) de cada uno de los casos
#en la estimacion de la regresion (se basa en la suma de los cambios que se producen
#en los coeficientes de regresión al ir eliminando cada caso del análisis)

#***Aclaracion Rcuadrado y Rcuadrado corregida
#R cuadrado (coeficiente de determinacion que nos habla del ajuste de nuestro modelo)
#un estimador positivamente sesgado (respecto a su correspondiente
#parámetro poblacional). Es decir, tiende a ofrecer estimaciones infladas
#Este sesgo depende del número de variables independientes (p) y del número de casos (n):
#Cuanto menor es la relación n:p, mayor es el sesgo.
# Por ello, se suele aplicar una correccion que es el valor
#que vemos en Adjusted R squared
#*********************************Fin aclaracion


###Alternativa si tenemos muchos outliers: regresion lineal robusta 
#funcion lmrob en paquete robustbase 
library(robustbase)
mrobusto<-lmrob(encuesta$FluidezVerbalIngles~encuesta$FluidezVerbalEspanol)
summary(mrobusto)
# si los resultados de ambos modelos es el mismo,
#tendremos mayor seguridad de que los outliers no estan
#perjudicando mis conclusiones

#Sin embargo, seguimos sin tener independencia:
plot(encuesta$FluidezVerbalIngles,mrobusto$residuals)
#como vemos que no hay independencia de los residuos (ni en el modelo lineal
#ni en el modelo robusto a casos extremos),
#en este caso, se aconseja usar el metodo de minimos cuadrados generalizados

library(nlme)
ing<-encuesta$FluidezVerbalIngles
esp<-encuesta$FluidezVerbalEspanol
modeloGLS<- gls(ing~esp)
summary(modeloGLS)
plot(ing,modeloGLS$residuals)
#sigue sin haber independencia:
#Cuando los errores están autocorrelacionados, las estimaciones de los coeficientes
#de regresión son insesgadas, pero sus varianzas tienden a tomar valores más pequeños de
#lo que deberían
#Consecuencia: las pruebas de significación y ICs tienden a detectar coeficientes 
#de regresión significativamente distintos de cero con demasiada frecuencia.