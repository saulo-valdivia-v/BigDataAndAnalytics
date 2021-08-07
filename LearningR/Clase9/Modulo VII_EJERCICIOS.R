#Ejercicio Modulo VII: RMarkdown

#Convierte en documento HTML los ejercicios del dia 10.12.2020 con RMarkdown
encuesta <- read.table("encuesta.dat", header=T, sep="\t",dec=',')


#A?ade funciones generales en el metadata
#1.1. Haz un an?lisis que ponga a prueba si la fluidez verbal en espa?ol
#puede predecir la fluidez verbal en ingles

#Crea chunks para cada uno de los apartados de los analisis
#Proporciona una interpretacion escrita de los resultados