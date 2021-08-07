mean(X3_4_Standard_normal_distribution_exercise$...1)

sd(X3_4_Standard_normal_distribution_exercise$...1)

scaled <- scale(X3_4_Standard_normal_distribution_exercise$...1)

library(ggplot2)

ggplot(X3_4_Standard_normal_distribution_exercise, aes(x=...1)) + geom_histogram()


mi_df <- data.frame(s = scaled)

ggplot(mi_df, aes(x=s)) + geom_histogram()

sd(mi_df$s)
mean(mi_df$s)


