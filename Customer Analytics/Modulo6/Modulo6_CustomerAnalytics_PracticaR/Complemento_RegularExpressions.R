#Regular Expressions: uso de quantifiers

#Documentación y ejemplos de stringr + regex (sección "pattern"): https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html
#Cheatsheet de stringr: https://github.com/rstudio/cheatsheets/blob/master/strings.pdf

library(stringr)
my_number <- "+7(903)-123-45-67"
my_words <- c("color", "colour")

#Recuerda que str_extract() extrae la primera aparición del pattern
#Mientras que str_extract_all() extrae todas las apariciones del pattern
str_extract(my_number, pattern = "\\d")
str_extract_all(my_number, pattern = "\\d")


#Quantity {n}

# The exact count: {3}
# \d{3} denotes exactly 3 digits, the same as \d\d\d.
str_extract(my_number, pattern = "\\d{3}")
str_extract_all(my_number, pattern = "\\d{3}")

# The range: {2,3}, match 2-3 times.
str_extract(my_number, pattern = "\\d{2,3}")
str_extract_all(my_number, pattern = "\\d{2,3}")


#Shorthand

# "?" means “zero or one”, the same as {0,1}. In other words, it makes the symbol optional.
str_extract(my_number, pattern = "\\d{0,1}")
str_extract(my_number, pattern = "\\d?")
str_extract_all(my_number, pattern = "\\d?")
str_extract_all(my_words, pattern = "colou?r") #the "u?" makes the letter u optional

# "*" Means “zero or more”, the same as {0,}. That is, the character may repeat any times or be absent.
str_extract(my_number, pattern = "\\d{0,}")
str_extract(my_number, pattern = "\\d*")
str_extract_all(my_number, pattern = "\\d*")
str_extract_all("1 10 100 18 $", pattern = "\\d0*") #searches for a digit followed by any number of zeroes (may be many or none)

# "+" means “one or more”, the same as {1,}
str_extract(my_number, pattern = "\\d{1,}")
str_extract(my_number, pattern = "\\d+")
str_extract_all(my_number, pattern = "\\d+")

#Ejemplo de aplicación: regex para detectar números decimales (números con "." en R)
str_extract_all("0 1 12.345 7890", pattern = "\\d+\\.\\d+")


# Para ver más ejemplos de Quantifiers y otros tipos de operadores (alternates, anchos, etc)
# Consultar los ejemplos y documentación de stringr

#Documentación y ejemplos: https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html
#Cheatsheet de Stringr: https://github.com/rstudio/cheatsheets/blob/master/strings.pdf
