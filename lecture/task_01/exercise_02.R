# Exercise 2
a = rnorm(6, 42, 1)
mean_a = mean(a)
median_a = median(a)

b = rnorm(10000, 42, 1)
mean_b = mean(b)
median_b = median(b)

plot(density(rnorm(6, mean_a, 1)))
plot(density(rnorm(6, median_a, 1)))

