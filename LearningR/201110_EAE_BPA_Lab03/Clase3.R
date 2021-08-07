# Al ver datos realizamos lo siguiente:
# 1. Existe ausencia de informacion? N/A

print(iris)
plot(iris)
summary(iris)

iris[1:10,]
iris[,3:4]
iris[1:10, 3:4]
iris[,"Species"]
iris$Species

iris[iris$Species == "setosa",]

# Operaciones con Archivos
getwd()
write.table(iris, file = "iris.csv", col.names = TRUE, row.names = FALSE)

mi_iris = read.table("iris.csv", header = TRUE)
mi_iris2 = read.csv("iris.csv", header = TRUE, sep = " ")
summary(mi_iris)

# Nuevas Columnas
(mi_iris$Petal.Area <- mi_iris$Petal.Length * mi_iris$Petal.Width)


# Sorting
iris[order(iris$Petal.Length),]
iris[order(-iris$Petal.Length),]
iris[order(iris$Petal.Length, decreasing = TRUE),]
iris[order(iris$Petal.Length, iris$Sepal.Length),]

(mi_iris <- iris[order(iris$Petal.Length),])

# Analisis Estadisticos Descriptivos

# Tablas de Frecuencia (aplicar sobre frames, categorias)
# Frecuencia Discreta
(FrecDisSpecies = table(iris$Species))
# Frecuencia Acumulada
(FrecAcuSpecies = cumsum(FrecDisSpecies))


# Estadisticos de una Variable (aplicar sobre datos numericos)
(Max_S.L = max(iris$Sepal.Length))
(Min_S.L = min(iris$Sepal.Length))
(Ran_S.L = range(iris$Sepal.Length))
(Media_S.L = mean(iris$Sepal.Length))
(Mediana_S.L = median(iris$Sepal.Length))
(DesMues_S.L = sd(iris$Sepal.Length))
(VarMues_S.L = var(iris$Sepal.Length))
(Quartiles_S.L = quantile (iris$Sepal.Length))
(RIQ_S.L = IQR(iris$Sepal.Length))

(Max_S.L = max(iris$Sepal.Width))
(Min_S.L = min(iris$Sepal.Width))
(Ran_S.L = range(iris$Sepal.Width))
(Media_S.L = mean(iris$Sepal.Width))
(Mediana_S.L = median(iris$Sepal.Width))
(DesMues_S.L = sd(iris$Sepal.Width))
(VarMues_S.L = var(iris$Sepal.Width))
(Quartiles_S.L = quantile (iris$Sepal.Width))
(RIQ_S.L = IQR(iris$Sepal.Width))

(variables = c(mean(iris$Sepal.Length), mean(iris$Sepal.Width)))

(DDD = c(sd(iris$Sepal.Length), sd(iris$Sepal.Width)))


# Graficos

# Diagramas de Barras (Varibles Categoricas)
barplot(table(iris$Species))

# Histogramas (Variables numericas)
hist(iris$Sepal.Width)

# Cajas y Bigotes ()
boxplot(iris$Sepal.Width ~ iris$Species, col = "red", main = "Especies")

plot(cars$speed, cars$dist)
plot(airquality$Temp)
lines(airquality$Temp)

abline(h=mean(airquality$Temp), col="red")

boxplot(iris$Sepal.Width ~ iris$Species, col="gray", main="Especies anchura sepalo")


# Vectores 2
x = 1:10

z = 1:length(iris$Species)

c(1:5, 5:1)
rep(1:5)
seq(1:5)
seq(5:1)
seq(1, 2, by=0.1)

rep(1:4, each=2)
rep(1:4, c(2,2,2,2))
rep(1:4, each=2, times=3)

x=1:10
y = x^2
y[y>25]
y[(1:2)]
y[-(1:2)]
y[-length(y)]

z <- table(iris$Species)

(z <- 1:10)
(z[z<5] <- 100)
z

# Cambiar nombres de Tablas
mi_iris <- iris

colnames(mi_iris)

colnames(mi_iris)[5] <- "Especies"


# Cambiar los nombres de la tabla de frecuencias
z <- table(iris$Species)
names(z) #lista el vector
names(z)[1] <- "A"
