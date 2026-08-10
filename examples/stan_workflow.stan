// Beobachtete Daten (fest)
data {
  int<lower=0> N;            // Anzahl Würfe  (beobachtet) 
  int<lower=0> W;            // Anzahl Wasser (beobachtet)
}

// Parameter (flexibel) [hier nur ein Parameter da binomiales model]
parameters {
  real<lower=0, upper=1> p;  // Wasseranteil (unbekannt)
}

// Model (zu schätzen)
model {
  p ~ uniform(0, 1);         // Prior:      p(θ)
  W ~ binomial(N, p);        // Likelihood: p(D|θ)
}

