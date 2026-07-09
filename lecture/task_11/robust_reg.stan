data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}

parameters {
  real a;               // Steigung
  real b;               // Achsenabschnitt
  real<lower=0> sigma;  // Streuung
}

model {
  // Priors
  a ~ normal(0, 10);
  b ~ normal(0, 10);
  sigma ~ normal(0, 10);  // -> Halbnormal, da sigma > 0

  // Likelihood
  y ~ normal(a * x + b, sigma);
}
