// Hierarchical Poisson model for Bundesliga goals.
//
// Each team j has a latent attack[j] and defense[j] strength, partially pooled
// toward 0 through half-normal hyperpriors (sigma_att, sigma_def). This shrinkage
// also fixes the additive non-identifiability of attack/defense and regularizes
// the 18 teams toward the league mean. home_adv is a shared home-advantage term,
// mu the baseline log goal rate.
//
//   goals_home ~ Poisson(exp(mu + home_adv + attack[home] - defense[away]))
//   goals_away ~ Poisson(exp(mu +           attack[away] - defense[home]))

data {
  int<lower=0> N_train;
  int<lower=0> N_test;
  int<lower=0> J;
  array[N_train] int<lower=1,upper=J> home_train;
  array[N_train] int<lower=1,upper=J> away_train;
  array[N_train] int<lower=0> goals_home_train;
  array[N_train] int<lower=0> goals_away_train;
  array[N_test] int<lower=1,upper=J> home_test;
  array[N_test] int<lower=1,upper=J> away_test;
  array[N_test] int<lower=0> goals_home_test;
  array[N_test] int<lower=0> goals_away_test;
}

parameters {
  real home_adv;
  real mu;
  real<lower=0> sigma_att;
  real<lower=0> sigma_def;
  vector[J] attack;
  vector[J] defense;
}

model {
  home_adv ~ normal(0, 1);
  mu ~ normal(0, 1);
  sigma_att ~ normal(0, 0.5);
  sigma_def ~ normal(0, 0.5);
  attack ~ normal(0, sigma_att);
  defense ~ normal(0, sigma_def);

  for (n in 1:N_train) {
    real lambda_home = exp(mu + home_adv + attack[home_train[n]] - defense[away_train[n]]);
    real lambda_away = exp(mu + attack[away_train[n]] - defense[home_train[n]]);
    goals_home_train[n] ~ poisson(lambda_home);
    goals_away_train[n] ~ poisson(lambda_away);
  }
}

generated quantities {
  // Pointwise test log-likelihood for NLPD / LOO.
  // First N_test entries: home goals; second N_test entries: away goals.
  vector[2 * N_test] log_lik;

  // Posterior-predictive simulated goals for each test fixture (for PPC,
  // score-distribution plots and P(team A beats team B)).
  array[N_test] int goals_home_rep;
  array[N_test] int goals_away_rep;

  for (n in 1:N_test) {
    real lambda_home = exp(mu + home_adv + attack[home_test[n]] - defense[away_test[n]]);
    real lambda_away = exp(mu + attack[away_test[n]] - defense[home_test[n]]);

    log_lik[n]            = poisson_lpmf(goals_home_test[n] | lambda_home);
    log_lik[N_test + n]   = poisson_lpmf(goals_away_test[n] | lambda_away);

    goals_home_rep[n] = poisson_rng(lambda_home);
    goals_away_rep[n] = poisson_rng(lambda_away);
  }
}
