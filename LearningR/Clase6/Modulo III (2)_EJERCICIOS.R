#Ejercicios MODULO III Estad?stica con R (II)

#1. Construye la distribuci?n muestral del estad?stico Media 
#para una poblaci?n de 5 valores: Yi = {1, 2, 3, 4, 5}
#en muestras de tama?o n=2

Yi = c(1, 2, 3, 4, 5)

y1 = sample(Yi, size=25, replace=TRUE)
y2 = sample(Yi, size=25, replace=TRUE)

df = data.frame(m1=y1, m2=y2)

dfm = mutate(df, media = (m1 + m2)/ 2)

table(dfm$media)

#2. Representa el resultado en un histograma
hist(dfm$media)

# Dataframe con:
# MediasObtenidas 1.5, 2, 2.5, ...
# Muestras
# Frecuencias 
# Proporciones

# En base a la distribucion se puede inferir cosas
# Hipotesis cientifica (Texto) Vs estadistica(formula o modelo estadistico) = Hipotesis Nula
# Hipotesis Nula => Principal H0, se pone a prueba
# Hipotesis Alternativa => H1, la negacion de H0
# Los datos son compatibles => estadistico de contraste
# La zona de rechazo y aceptacion estan en la campana normal
# Necesitamos un criterio para aceptar o rechazar => 0,5 rec  0,1 0,01
