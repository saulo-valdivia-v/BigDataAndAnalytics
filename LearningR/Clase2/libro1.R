#install.packages("nycflights13")

library(nycflights13)
library(tidyverse)

nycflights13::flights
view(flights)

filter(flights, month == 1, day == 1)

filter(flights, arr_delay >= 120)

filter(flights, dest == 'IAH' | dest == 'HOU')

filter(flights, dest == 'IAH' | dest == 'HOU')

filter(flights, carrier == 'AA' | carrier == 'UA' | carrier == 'DL')

filter(flights, month %in% c(7,8,9))

filter(flights, arr_delay >= 120 & dep_delay == 0)

NA ^ 0
FALSE & NA

# Arrange
arrange(flights, year, month, day)

arrange(flights, desc(arr_delay))
arrange(flights, arr_delay)

df <- tibble(x = c(5, 2, NA))
arrange(df, !is.na(x), desc(x))

view(flights)


arrange(flights, desc(dep_delay), desc(arr_delay))
arrange(flights, dep_delay)

arrange(flights, (dep_delay + arr_delay))


distance <- arrange(flights, desc(distance))
distance <- arrange(flights, distance)


select(flights, year, month, day)
select(flights, year:day)

vars <- c(
  "year", "month", "day", "dep_delay", "arr_delay"
)
select(flights, year:day, one_of(vars))


flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)


mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)


y <- c(1, 2, 2, NA, 3, 4)
percent_rank(y)

time <- mutate(flights,
       air_time,
       time=arr_time-dep_time)

       
delay <- arrange(flights, desc(arr_delay + dep_delay))
delay <- mutate(delay,
       delay = dep_delay + arr_delay)

min_rank()