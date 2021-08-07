#Ejercicios Modulo III (4)

#Ej 1. Comprueba los supuestos del ANOVA de un factor hecho en clase: 
#*Vamos a ver si existen diferencias en el gasto de las comunidades de 
#*Andalucia, Baleares y Canarias desde el 2004 hasta el 2017
library(readxl)
gasto <- read_excel('Gasto_de_los_turistas_segun_destino_principal.xlsx',
                    col_names = TRUE,skip=1)

#1.1. HOMOCEDASTICIDAD
library(tidyverse)
?bartlett.test
variablegrupo<-rep(c("AN","IB","CA"),each=14) # porque queremos revisar 14 anios
gastoAN<- as.data.frame(t(gasto[1,4:17]))
gastoIB<- as.data.frame(t(gasto[2,4:17])) 
gastoCA<- as.data.frame(t(gasto[3,4:17])) 
gastos<- c(gastoAN$V1,gastoIB$V1,gastoCA$V1)

variable <- c(gastoAN$V1,gastoIB$V1,gastoCA$V1)
categorias <- factor(c(rep("A",14),rep("I",14),rep("C",14)))
bartlett.test(variable,categorias)
#gastos1 <- data.frame(AN=gastoAN, CA=gastoCA, IB=gastoIB)


#bartlett.test(V1 ~ interaction(V1.1,V1.2), data=gastos1)
# aceptamos la hipotesis nula. Las muestras presentan varianzas iguales.

#1.2. NORMALIDAD
library(ggplot2)

ggplot(data = gastoAN, aes(x = V1)) +
  geom_histogram(aes(y = ..density.., fill = ..count..)) +
  scale_fill_gradient(low = "#DCDCDC", high = "#7C7C7C") +
  stat_function(fun = dnorm, colour = "firebrick",
                args = list(mean = mean(gastoAN$V1),
                            sd = sd(gastoAN$V1))) +
  ggtitle("Histograma con curva normal teórica") +
  theme_bw()

ggplot(data = gastoIB, aes(x = V1)) +
  geom_histogram(aes(y = ..density.., fill = ..count..)) +
  scale_fill_gradient(low = "#DCDCDC", high = "#7C7C7C") +
  stat_function(fun = dnorm, colour = "firebrick",
                args = list(mean = mean(gastoIB$V1),
                            sd = sd(gastoIB$V1))) +
  ggtitle("Histograma con curva normal teórica") +
  theme_bw()

ggplot(data = gastoCA, aes(x = V1)) +
  geom_histogram(aes(y = ..density.., fill = ..count..)) +
  scale_fill_gradient(low = "#DCDCDC", high = "#7C7C7C") +
  stat_function(fun = dnorm, colour = "firebrick",
                args = list(mean = mean(gastoCA$V1),
                            sd = sd(gastoCA$V1))) +
  ggtitle("Histograma con curva normal teórica") +
  theme_bw()
# No rechazamos la hipotesis nula. Son Normales
ks.test(x = gastoAN$V1,"pnorm", mean(gastoAN$V1), sd(gastoAN$V1))
ks.test(x = gastoIB$V1,"pnorm", mean(gastoIB$V1), sd(gastoIB$V1))
ks.test(x = gastoCA$V1,"pnorm", mean(gastoCA$V1), sd(gastoCA$V1))

shapiro.test(x = gastoIB$V1)

#Ej 2. Haz un analisis estadistico que pruebe si la diferencia de hospitalizados es significativa
##entre las comunidades autonomas de Madrid (CM) Extremadura (EX) y Andalucia (AN)
##en la base "agregados"
agregados <- read.csv('agregados.csv', header = TRUE)

ccaa <- filter(agregados, agregados$CCAA == 'CM' | agregados$CCAA == 'EX' | agregados$CCAA == 'AN')

cm <- filter(agregados, agregados$CCAA == 'CM')
ex <- filter(agregados, agregados$CCAA == 'EX')
an <- filter(agregados, agregados$CCAA == 'AN')

qqnorm(cm$Hospitalizados, main = 'CM');qqline(cm$Hospitalizados, distribution = qnorm)
qqnorm(ex$Hospitalizados, main = 'EX');qqline(ex$Hospitalizados, distribution = qnorm)
qqnorm(an$Hospitalizados, main = 'AN');qqline(an$Hospitalizados, distribution = qnorm)

ks.test(cm$Hospitalizados, 'pnorm')
shapiro.test(cm$Hospitalizados)
ks.test(unique(ex$Hospitalizados), 'pnorm')
shapiro.test(ex$Hospitalizados)
ks.test(unique(an$Hospitalizados), 'pnorm')
shapiro.test(an$Hospitalizados)

anova(lm(ccaa$Hospitalizados~ccaa$CCAA))
mean <- mean(agregados$Hospitalizados, na.rm=TRUE)
pairwise.t.test(ccaa$CCAA, ccaa$Hospitalizados, p.adj = 'bonferroni')

#2.1. ?Podrias representar las medias en un grafico?

stripchart(ccaa$Hospitalizados~ccaa$CCAA,pch=16, vert=T,method="jitter", jitter=0.05 )

#ccaaccaa %>% drop_na(col1)

xbar <- tapply(ccaa$Hospitalizados,ccaa$CCAA, mean, na.rm=TRUE)
s <- tapply(ccaa$Hospitalizados,ccaa$CCAA, sd, na.rm=TRUE)
n <- tapply(ccaa$Hospitalizados,ccaa$CCAA, length)
sem <- s/sqrt(n) 

arrows(1:3,xbar+sem,1:3,xbar-sem,angle=90, code=3,length=.1)
lines(1:3, xbar)
