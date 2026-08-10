library(cmdstanr)

# 1: Modell kompilieren (aus der .stan-Datei)
model <- cmdstan_model('C:/Projects/MSI-DTAN/examples/stan_workflow.stan')

# Die echten Daten festlegen
data <- list(N = 9, W = 6)

# 2: Auf Daten konditionieren → aus dem Posterior samplen (MCMC)
samples <- model$sample(
  data          = data,
  chains        = 4,        # 4 unabhängige Ketten (für Diagnostik)
  iter_sampling = 10000,
  seed          = 123
)

# 3. Parameter extrahieren
samples_cmd = samples$draws('p')
