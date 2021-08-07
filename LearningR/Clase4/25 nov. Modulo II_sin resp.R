################################MODULO II GRAFICOS

#Primero: importad la base de datos 'encuesta.dat, con la que vamos a trabajar hoy
encuesta <- read.table('encuesta.dat', header=T, sep = '\t', dec = ',')

#******************RECORDATORIO:Funciones utiles que hemos visto hasta ahora***************

###table para tabla de frecuencias con datos categoricos
univ <- c('UAM', 'UCM', 'UNED', NA, 'UCM', 'UCM', 'UAM')
univf <- factor(univ, levels = c("UAM", "UCM", "UNED"))
table(univf)

###tapply con variable numerica y variable categorica
edad <- c(21, 36, 19, 20, 20, 19,NA)
tapply(edad, univf, mean)#aplica la media a la variable edad segun los niveles de univf

###apply para matrices o arrays
m <- matrix(1:12, nrow = 3, ncol = 4);m
apply(m, MARGIN = 2, FUN = sum)
apply(m, MARGIN = 1, FUN = sum)

#********************************FIN RECORDATORIO***************

###FUNCION by() 
by()#equivalente a tapply, pero aplicado a data.frames
summary(encuesta["Edad"])
by(encuesta[,"Edad"], encuesta[,"Sexo"], summary) #me da el 'summary' 
#de la edad en cada uno de los grupos de la variable sexo

source('descriptivos.r') #esta funcion lee el codigo del archivo que le especifiquemos
#(ver funcion descriptivos)
res <- by(encuesta[,"Edad"], encuesta[,"CarnetConducir"], descriptivos) 

#### HISTOGRAMA
hist(encuesta$Nota_PAU)

#Dispone de diferentes argumentos para hacer el grafico mas 'amigable'
#Consejo: dar siempre nombre al gr?fico y a las variables
histograma <- hist(encuesta$Nota_PAU,
     xlab   = "Nota",
     ylab   = "Frecuencia",
     main   = "Notas obtenidas en la PAU",
     col    = "dodgerblue",
     border = "darkorange")

histograma

#argumento breaks() es especifico para histogramas y permite determinar el num
#de cortes que queremos
histograma <- hist(encuesta$Nota_PAU,
                   xlab   = "Nota",
                   ylab   = "Frecuencia",
                   main   = "Notas obtenidas en la PAU",
                   breaks = 5,
                   col    = "dodgerblue",
                   border = "darkorange")
histograma 
#$breaks   = cortes en el eje x
#$counts   = valores del eje y
#$density  = ?
#$mids     =punto medio de los valores del eje x

cortes <- histograma$breaks     
frecuencias <- histograma$counts
porcentajes <- histograma$density * 100
medio <- histograma$mids;
freq.dist<- cbind(cortes, frecuencias, porcentajes, medio);freq.dist

###GRAFICO DE BARRAS
#?que variale de nuestra base de datos es categorica para poner un ejemplo de barplot?
str(encuesta)
genero<-factor(encuesta$Sexo, levels = c(1,2), labels=c('Hombre', 'Mujer'))
str(genero)
table(genero)

barplot(table(genero))
barplot(table(genero),
        xlab = 'Genero',
        ylab = 'Frecuencia',
        main = 'Numero Hombres Mujeres',
        col = 'dodgerblue',
        border = 'darkorange')

barplot(table(genero,encuesta$Edad))
barplot(table(genero,encuesta$Edad), legend.text = levels(genero))
barplot(table(genero,encuesta$Edad), legend.text = levels(genero), beside = T)

#### BOXPLOT 

summary (encuesta$Nota_PAU)
boxplot(encuesta$Nota_PAU) #vemos que nos salen valores extremos
#los cuales se pueden eliminar para realizar un anlaisis
#CUIDADO: la eliminacion de valores extremos SIEMPRE tiene que estar justificada
#por ejemplo: la persona ha hecho la encuesta sin prestar atencion
#y ha puntuado en todo 0
#NUNCA eliminar porque los resultados no reflejan nuestra hipotesis inicial

encuesta$Nota_PAU [encuesta$Nota_PAU >=8] <- NA   # Elimina valor extremo
boxplot(encuesta$Nota_PAU)
table (encuesta$Nota_PAU)

#se puede ver la dispesion de una variable numerica en diferentes categorias de una variable categorica
boxplot(encuesta$Nota_PAU ~ genero, data = encuesta)
boxplot(encuesta$Nota_PAU ~ genero, data = encuesta,
        xlab   = "Genero",
        ylab   = "Notas PAU",
        main   = "Notas en la PAU en hombres y mujeres",
        pch    = 20,
        cex    = 2,
        col    = "darkorange",
        border = "dodgerblue")

plot(encuesta$Nota_PAU,
     type= "l",
     xlab = "Numero de alumnos",
     ylab = "Nota PAU",
     main = "Notas en la PAU",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")

plot(encuesta$Nota_PAU,
     type= "b",
     xlab = "Numero de alumnos",
     ylab = "Nota PAU",
     main = "Notas en la PAU",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")


###GRAFICOS DE DISPERSION
plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta)
plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta,
     xlab = "Edad",
     ylab = "Notas PAU",
     main = "Notas en la PAU por edad",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")

encuesta$Edad [encuesta$Edad >=30] <- NA
plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta,
     xlab = "Edad",
     ylab = "Notas PAU",
     main = "Notas en la PAU por edad",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")

plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta,
     type = 'b',
     xlab = "Edad",
     ylab = "Notas PAU",
     main = "Notas en la PAU por edad",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")


#dos variables
plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta) # Relacion. Mayor valor en los analisis
plot(encuesta$Nota_PAU , encuesta$Edad, data = encuesta) # Representacion. 

plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta,
     xlab = "Edad",
     ylab = "Notas PAU",
     main = "Notas en la PAU por edad",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")


encuesta$Edad [encuesta$Edad >=30] <- NA
plot(encuesta$Nota_PAU ~ encuesta$Edad, data = encuesta,
     xlab = "Edad",
     ylab = "Notas PAU",
     main = "Notas en la PAU por edad",
     pch  = 20,
     cex  = 2,
     col  = "dodgerblue")

