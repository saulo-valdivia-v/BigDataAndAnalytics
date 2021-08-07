# Contiene una funcion que devuelve los estadisticos descriptivos
# Requiere un unico argumento: el vector de datos brutos
# Devuelve una lista con todos los resultados

	descriptivos <- function(datos){
		maximo<-max(datos); minimo<-min(datos)
		media<-mean(datos)
		mediana<-median(datos)
		varianza<-var(datos)
		desv<-sd(datos)
		iqr<-IQR(datos)
		cat(" Maximo =",maximo, ", Minimo =",minimo, "\n",
		"Media =", media, ", Mediana =", mediana,"\n",
		"Desviacion tipica =",desv, ", Varianza =", varianza,"\n",
		"Amplitud intercuartil =", iqr, "\n")
		resultados <- as.list(data.frame(maximo, minimo,media,mediana,varianza,desv,iqr))
		return(resultados)
		}
