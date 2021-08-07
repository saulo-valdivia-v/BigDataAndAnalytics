#Análisis explotatorio de campañas de E-mail Marketing

# AUTOR: Saulo Valdivia Valdivia

#PASO 1: Deben cargar las librerias:
#tidyverse, 
library(tidyverse)

#PASO 2: Generar un dataset llamado email_analysis cargando el archivo "dataset_email-mkt.csv" eliminando primera columna
email_analysis <- read.csv('dataset_email-mkt.csv')

#Modificar la columna de sendout_date para que sea fecha y no character
email_analysis$sendout_date <- as.Date(email_analysis$sendout_date, "%Y-%m-%d")

#PASO 3: Generar un segundo dataset email_campaign filtrando la columna
#email_scope == "Campaign"
email_campaign <- email_analysis %>% filter(email_scope == 'Campaign')


#Calculen los datos agregados de todas las columnas que comienzan con "total_"
#agrupando por journeys_id
#names(email_campaign)
journey <-  email_campaign %>%
            group_by(journeys_ids) %>%
            select(starts_with('total_')) %>%
            summarise_all(sum, na.rm = T)

#Realicen un plot de la cantidad de envios de mails para cada journeys_id
p<-ggplot(data=journey, aes(x=journeys_ids, y=total_email_sent)) +
   geom_bar(stat="identity", fill="steelblue") +
   labs(x = "Journeys", y = "Emails Sent") +
   theme_minimal()

p

#PASO 4: Realizar los cálculos de open_rate y ctor para cada journeys_id
#OR: el porcentaje de emails que fueron abiertos por los
#destinatarios sobre el total de emails enviados.
#Click to Open Rate (CTOR): El porcentaje de usuarios que
#recibieron el mail, lo abrieron y realizaron clic en el link deseado.

journey = mutate(journey, or=(total_email_open/total_email_delivered)*100)
journey = mutate(journey, ctor=(total_email_clicks/total_email_open)*100)

#Cual es el OR y CTOR promedio de todas las campañas realizadas?
mean(journey$or)
mean(journey$ctor, na.rm=TRUE)

#Cuales son las campañas que mejor han performado?
# RESPUESTA: Se considera que las mejores campañas tienen un OpenRante entre 
# el 12% y 60% y ademas un ClickOpenRate entre el 6% y 32%
j <- journey[journey$or > 12 & journey$or < 60, ]
j <- j[j$ctor > 6 & j$ctor < 32, ]

head(j$journeys_ids, n=5)

#Las campañas que peor performan son aquellas donde más "flag_unsubscribe"
#con valor TRUE existen?
email_campaign$flag_unsubscribe <- as.numeric(email_campaign$flag_unsubscribe)

journey2 <-  email_campaign %>%
  group_by(journeys_ids) %>%
  select(flag_unsubscribe) %>%
  summarise_all(sum, na.rm = T)

newdata <- journey2[order(-journey2$flag_unsubscribe),]

head(newdata, n=5)

#PASO 4: Realizar análisis de los usuarios según su género, realizando un nuevo
#dataset que agregue los datos según género
#Calcular métricas de OR y CTOR para cada género e identificar si se perciben
#diferencias de comportamiento en relación a la tasa de apertura y clics

# RESPUESTA: Los hombres tienen un promedio mayor y tambien un OR y CTOR 
# que es mayor que el de las mujeres. El ClickOpenRate es ligeramente
# superior en los hombres que las mujeres. Sin embargo el OpenRate es notablemente 
# superior ya que de acuerdo a los datos los Hombres tienen una mayor cantidad
# de mails abiertos respecto a la cantidad de mails enviados.

email_campaign_m <- email_campaign %>% filter(gender == 'm')

journeym <-  email_campaign_m %>%
             group_by(journeys_ids) %>%
             select(starts_with('total_')) %>%
             summarise_all(sum, na.rm = T)

journeym = mutate(journeym, or=(total_email_open/total_email_delivered)*100)
journeym = mutate(journeym, ctor=(total_email_clicks/total_email_open)*100)

# Promedio de las campañas para el genero masculino
mean(journeym$or)
mean(journeym$ctor, na.rm=TRUE)

jm <- journeym[journeym$or > 12 & journeym$or < 60, ]
jm <- jm[jm$ctor > 6 & jm$ctor < 32, ]

# Mejores campañas en para el genero masculino
jm$journeys_ids


email_campaign_f <- email_campaign %>% filter(gender == 'f')

journeyf <-  email_campaign_f %>%
  group_by(journeys_ids) %>%
  select(starts_with('total_')) %>%
  summarise_all(sum, na.rm = T)

journeyf = mutate(journeyf, or=(total_email_open/total_email_delivered)*100)
journeyf = mutate(journeyf, ctor=(total_email_clicks/total_email_open)*100)

# Promedio de las campañas para el genero femenino
mean(journeyf$or)
mean(journeyf$ctor, na.rm=TRUE)

jf <- journeyf[journeyf$or > 12 & journeyf$or < 60, ]
jf <- jf[jf$ctor > 6 & jf$ctor < 32, ]

# Mejores campañas en para el genero femenino
jf$journeys_ids

#Qué sucede con la cantidad promedio de páginas vistas por género?
#Los hombres o las mujeres exhiben un comportamiento diferencial?

# RESPUESTA: Los hombres tienen un promedio mayor de paginas vistas que respalda
# los resultados anteriores y esto indica que los Hombres en general responden
# mejor a las campañas de Email Marketing que las mujeres.
mean(journeym$total_pageviews)
mean(journeyf$total_pageviews)
