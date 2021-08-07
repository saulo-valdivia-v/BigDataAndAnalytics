#Ejercicios Modulo III (3)


#Ej. 1. Calcula la probabilidad de
#*1) una variable que se distribuye normalmente es mayor a 3
# pnorm
1-pnorm(3) # probabilidad de obtener un 3 o menos en la distro de curva normal teorica tipificada es..

#*2) una variable que se distribute normalmente con media = 35 y DT = 6 es mayor a 42
1 - pnorm(42, mean=35, sd=6)

dnorm(42) # Valor muy extremo en la curva
pnorm(42)
dnorm(0)
pnorm(0)

#Ej 2.Abre la base de datos 'agregados.csv'
agregados <- read.csv("agregados.csv", header=T)
agg1 <- agregados[1:1729,]

str(agg1)

#2.1 Genera de manera aleatoria la variable categorica TestDico que contenga valores si,no 
# (como si la CCAA hizo tests o no)
library(dplyr)
cat <- sample(c(1,0), size=1729, replace=TRUE)
cat[cat=='1'] <- 'si'
cat[cat=='yes'] <- 'si'
agg1 <- agg1 %>% mutate(TestDico = cat)
agg1$Pruebas <- NULL

TestDico <- sample(c('si', 'no'), 1729, replace = T)
TestDico <- as.factor()

##2.2. haz un analisis estadistico que pruebe si la diferencia en hospitalizados es diferente
## entre aquellos casos que dieron positivo en el test y aquellos que no
agg2<-agg1[!is.na(agg1$Hospitalizados),]
agg2<-agg1

h <- agg2$Hospitalizados
td <- as.factor (agg2$TestDico)
by(h,td,mean)

t.test(h ~ td,var.equal=T)
##2.3. Comprueba los supuestos de normalidad e igualdad de varianzas. Para ello, ver:
#Graficar y ver si sigue la forma de campana

?var.test # Homocedasticidad
#graficos donde se vea la distribuci?n, graficos de normalidad, 
#indices de la forma de la distribucion...

#Ej 3. Haz un analisis estadistico que pruebe si la diferencia en hospitalizados es diferente
## en las comunidades autonomas de Madrid (CM) Extremadura (EX) y Andalucia (AN)

###3.1. Comprueba el supuesto de normalidad