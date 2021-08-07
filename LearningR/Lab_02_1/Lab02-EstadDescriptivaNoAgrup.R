########################################################
# Laboratorio 02.  
# Plantilla de comandos R para Estadistica Descriptiva
# Una variable cuantitativa, datos no agrupados.
########################################################


# Para que los comandos funcionen es necesario establecer 
# el directorio de trabajo ./datos/ con el comando
setwd("./datos/")

# Leemos el fichero de datos, y lo guardamos en la variable vectorDatos.
# El fichero debe estar en la subcarpeta datos del directorio de trabajo.
vectorDatos = scan(file="./datos/")

# Calculamos máximo, minimo y rango.
( minimo = min(vectorDatos) )
( maximo = max(vectorDatos) )
( rango = range(vectorDatos) )

# Determinamos la longitud del vector de datos.
( n = length( vectorDatos ) )

# Hallamos las tablas de frecuencias: 
# (1) absoluta,  (2) relativa,
# (3) acumulada, (4) acumulada relativa.
( tablaFrecAbs = table(vectorDatos) )
( tablaFrecRel = tablaFrecAbs / n )
( tablaFrecAcu = cumsum(tablaFrecAbs)  )
( tablaFrecRelAcu = cumsum(tablaFrecRel) )

# Dibujamos un gráfico de barras de las frecuencias.
barplot(tablaFrecAbs, col = heat.colors(15))

# Y el diagrama de caja.
boxplot(vectorDatos)

# Calculo de la media aritmética,
( media = mean(vectorDatos))

# la cuasivarianza muestral,
( varMuestral = var(vectorDatos))

# y la cuasidesviación típica.
( desvTipMuestral = sd(vectorDatos))

# La varianza y desviación típica poblacionales
# se obtienen así:
( varPobl= ( (n-1) / n ) * varMuestral )
( desvTipPobl = sqrt( varPobl ) )

# Calculamos la mediana.
( mediana = median(vectorDatos))

# La función summmary muestra la media y varias
# medidas de posición (cuartiles).
summary(vectorDatos)

# El rango intercuartílico.
( rangoIntCuart= IQR(vectorDatos))

# Y algunos percentiles: 5%, 15%, 58% y 75%. 
# Si deseas otros percentiles, modifica los 
# valores del vector.

( percentiles = quantile(vectorDatos, c(0.05, 0.15, 0.58, 0.75)) )

# Fin del fichero


