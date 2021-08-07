#Manipulación de Fechas con las funciones base y la librería LUBRIDATE

#Instalamos la librería
install.packages("lubridate")

#Llamamos la librería para poder acceder a sus funciones
library(lubridate)


#Pero antes de hablar de Lubridate, hablaremos del tratamiento de las fechas en R
#Las fechas se guardan dentro de la clase Date y se guardan en la memoria activa como el número de días desde 01-01-1970,
#por eso es muy común que cuando formateamos fechas, aclaremos el origen como origin = "1900-01-01"


Sys.Date() #es una función que me permite obtener la fecha corriente
#si utilizamos unclass sobre Sys.Date() podemos averiguar cuántos días han pasado desde la fecha de origen
unclass(Sys.Date())

#Si no sólo queremos saber la fecha, sino también la hora utilizamos
Sys.time()
unclass(Sys.time()) #la diferencia desde origen, pero en segundos

#A su vez, existe una función para calcular diferencias entre dos fechas denominada difftime
#Por ejemplo si utilizara Sys.time como fecha inicial y comparo con Sys.time -4 días, en cantidad de días este sería el resultado
difftime(Sys.Date(), "2015-07-21", units = "days")
#Las units que puedo utilizar son: "auto", "secs", "mins", "hours","days", "weeks".
#Puedo aplicar también difftime sobre Sys.time, pero debo calcular los segundos
difftime(Sys.time(), Sys.time()-3600, units = "mins") #3600 segundos son 60 minutos

#Por último, muchas veces las fechas se importan como strings y necesitamos asignarle la clase correcta
#cuando trabajamos los formatos de fechas, debemos tener en cuenta cómo se representan los días, meses y años
#Por ejemplo, si yo quiero que las fechas se muestren así "2020-11-02" debo utilizar el format "%Y-%m-%d" 
#o "%Y/%m/%d" si quiero así "2020/11/02"
class(as.Date("2020-01-01","%Y-%m-%d", origin = "1970-01-01"))


#
#
##### FUNCIONES LIBRERÍA LUBRIDATE

#Las funciones más útiles son:
today() #me devuelve la fecha del día de hoy, igual que Sys.Date
now() #no solo devuelve fecha de hoy sino también la hora igual que Sys.time
wday() #Extrae el día de la semana en número. Si el argumento label le asigno TRUE muestra el nombre del día de la semana.
month() #me devuelve el mes
year() #me devuelve el año 

#Por ejemplo, podemos obtener la semana, el mes y el año de la fecha actual
wday(today(), label = TRUE, abbr = F) #recuerden que label permite que en vez del día de la semana en número, me muestre nombre
#También puedo agregar el argumento week_start para cambiar a lunes el inicio de la semana, ya que por default es domingo
wday(today(), label = TRUE, abbr = F, week_start = getOption("lubridate.week.start", 1))


month(today())
month(today(), label = TRUE, abbr = F) #al igual que en wday, puedo seleccionar si quiero que me muestre nombre del mes o numero

year(today())

#Finalmente, as_date permite que una fecha en formato string pase a tener formato fecha correcto
as_date("2020-11-02")

#Este es el link para acceder al cheatsheet de Lubridate con toda la información relevante
# https://rawgit.com/rstudio/cheatsheets/master/lubridate.pdf


##### Ejercicios
#Carguemos el archivo Dataset_VentasTienda.csv utilizando read_csv
Ejemplo_ventas <- read_csv(file.choose()) 

#Inspeccionemos con str para ver qué clase tiene la columna fecha y si está en formato caracter modificamos con as_date
#Prestemos atención al formato que tiene la fecha, porque si no respeto el formato puede convertir a todos en NA
summary()
Ejemplo_ventas$Date <- as.Date(Ejemplo_ventas$Date,"%d-%m-%Y", origin = "01-01-1900")
class(Ejemplo_ventas$Date) #comprobamos que ahora es clase Date

#Generamos una columna de mes y otra de año a partir de Ejemplo_ventas$Date, empleando las funciones month() y year()
#en el caso del mes, es importante que aparezca en formato nombre y sin abreviar
Ejemplo_ventas$Año <- year(Ejemplo_ventas$Date)

Ejemplo_ventas$Mes <- month(Ejemplo_ventas$Date)

Ejemplo_ventas$Recency <- (Sys.Date() - Ejemplo_ventas$Date) #al utilizar la operación de resta, identifica las fechas como numeros y realiza la operación con exito y por default hace un calculo de días
Ejemplo_ventas$Recency2 <- (difftime(Sys.Date(), Ejemplo_ventas$Date, units = "weeks")) #ahora, si yo quisiera hacer una diferencia por semanas, minutos, meses, entonces debería implementar la funcion de difftime para que el resultado sea el esperado.

#difftime no tiene la capacidad de hacer calculo por meses, pero podría obtener esa data realizando operaciones aritméticas sobre las fechas
#sabemos que en lineas generales los meses tienen 30 días, así que si divido el total de dias de diferencia por 30, me va a dar la cantidad estimada de meses
Ejemplo_ventas$Recency3 <- ((Sys.Date() - Ejemplo_ventas$Date) / 30)
  
#Por último, contamos todos los registros de ventas que se realizaron en el mes de octubre 2015
#Para ello empleo las funciones de dplyr que utilizamos previamente
Ejemplo_ventas %>%
  filter() %>% #debo realizar filtro conjunto para año y para mes
  count() #realizo un count de las filas de Mes que han quedado

#Cuántas ventas se realizaron en octubre de 2015?









