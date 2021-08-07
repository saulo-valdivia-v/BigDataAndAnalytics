###################MODULO III (3)

#CUIDADO: antes de realizar cualquier analisis hay que comprobar los supuestos de dicho analisis

#***********************************************************T de Student para muestras independientes
#setwd("H:/CLASES DE R EN BUSINESS SCHOOL")
encuesta <- read.table("encuesta.dat", header=T, sep="\t",dec=',')
str(encuesta)


# Testeando variables de ingles y sexo
ingles <- encuesta$FluidezVerbalIngles
genero <- as.factor (encuesta$Sexo)
by(ingles,genero,mean) # vamos a poner a prueba que estas dos medias son iguales (H0)
# Las medias son iguales? Son distintas
# Hay diferencias significativas entre hombres y mujeres?

# T.Test de Ingles (dependiente) definida en base a Genero.
# var.equal asumiendo el supuesto de hocedasticidad (Varianzas iguales) Se revisa antes.
t.test(ingles ~ genero,var.equal=T)# la fluidez va a ser definida (~) a partir del genero

#t es el estad?stico de contraste calculado, 
#p-value es el nivel de significaci?n de mi estadistico. Mantenemos la hipotesis Nula. Las medias son iguales. No hay diferencia significativa.
## Regla de decision: si el p-valor de mi estadistico < al criterio establecido (0.05)
## entonces, rechazamos la H0 ( ya que la probabilidad de que mi 
## resultado caiga dentro del area de aceptacion en la distribucion teorica
## es demasiado peque?a )

# Por tanto, si p=0.3766 -> no rechazo H0: medias iguales 
# (= las medias no son significativamente distintas,
# o la media de fluidez en ingles de hombres y mujeres no es significativamente distinta)

#el intervalo de confianza nos mostraria el nivel de confianza (Complementa al resultado del P-value)
# = rango de valores en el que encontrar el verdadero valor en la poblacion con un 95% de probabilidad


#************************************************************T de Student para muestras relacionadas
#*Vamos a comparar una variable cuantitativa medida dos veces en el tiempo
#*Solo necesitamos el supuesto de normalidad
#*Por ejemplo, la nota esperada en la PAU antes y despu?s de realizar el examen
esperadapre <- encuesta$NotaEsperada
esperadapost <- sample(0:10,81,replace = T)
diferencias <- esperadapost- esperadapre; diferencias #los valores negativos
#nos indicarian que los estudiantes esperaban una nota mas alta en el pre que en 
#el post

# Paired T que las muestras son no independientes, estan relacionadas.
t.test(esperadapre, esperadapost, paired=T)
#p valor < 0.05, por tanto ??
#Si hay diferencias significativas.
# El cero no esta en el intervalo de confianza.

#***************************************(cont ma?ana...)
#************************************************************ANOVA de un factor

france <- c(80, 20)

pd <- data.frame(France = france)
pd