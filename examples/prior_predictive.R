#### Schleifenform (explizit, gut zum Verstehen)
N <- 1e6
prior_pred <- rep(NA, N)
for (n in 1:N){
  prior_mu    <- rnorm(1, mean = 178, sd = 20)                  # Schritt 1a: mu aus Prior
  prior_sigma <- runif(1, min = 0,   max = 50)                  # Schritt 1b: sigma aus Prior
  prior_pred[n] <- rnorm(1, mean = prior_mu, sd = prior_sigma)  # Schritt 2: y ziehen
}

#### Vektorisierte Kurzform (in der Praxis so verwendet)
sample_mu    <- rnorm(1e4, mean = 178, sd = 20)
sample_sigma <- runif(1e4, min = 0, max = 50)
prior_pred   <- rnorm(1e4, mean = sample_mu, sd = sample_sigma)

plot(density(prior_pred), main = "Prior Predictive Distribution",
     xlab = "Height", ylab = "Density")
