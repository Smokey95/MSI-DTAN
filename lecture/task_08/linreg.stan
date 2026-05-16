data {
  int<lower=0> N;   // Anzahl Datenpunkte
  vector[N] x;      // Prädiktoren
  vector[N] y;      // Zielvariable
}

parameters {
  real a;           // Intercept
  real b;           // Steigung
  real<lower=0> sigma;  // Standardabweichung
}

model {
  // Sehr flache Priors
  a ~ uniform(-100, 100);
  b ~ uniform(-100, 100);
  sigma ~ uniform(0, 100);

  // Likelihood
  y ~ normal(a + b * x, sigma);
}
