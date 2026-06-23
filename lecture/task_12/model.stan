data {
  int<lower=1> N;
  vector[N] W;
  array[N] int sex; 
}

parameters {
  real<lower=0> sigma;
  vector[2] a;
}

model {
  vector[N] mu_i;
  
  // Compute individual means based on group
  for (i in 1:N) {
    mu_i[i] = a[sex[i]];
  }

  // TODO: Prior for a
  a ~ normal(55, 20);           // Prior: mittleres Gewicht je Gruppe

  // TODO: Prior for sigma
  sigma ~ cauchy(0, 10);        // Prior: Streuung (Half-Cauchy)

  // TODO: Likelihood for W     // Likelihood
  W ~ normal(mu_i, sigma);
}
