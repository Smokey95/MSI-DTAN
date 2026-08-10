# =====================================================================
#  Was kann man aus Posterior-Samples ableiten?  (Block 4, VL 08)
#  Modell: Globe Tossing / Wasseranteil aus Vorlesung 7
#  p ~ Uniform(0,1),  W ~ Binomial(N, p)
# =====================================================================

library(cmdstanr)
N <- 9     # z.B. 9 Wuerfe
W <- 6     # davon 6 mal Wasser  (klassisches McElreath-Beispiel)

# ---------------------------------------------------------------------
# 1. Stan-Modell laden
# ---------------------------------------------------------------------
model <- cmdstan_model('C:/Projects/MSI-DTAN/examples/stan_workflow.stan')

# ---------------------------------------------------------------------
# 2. Modell kompilieren und Posterior samplen
# ---------------------------------------------------------------------
fit <- model$sample(
  data    = list(N = N, W = W),
  seed    = 123,
  chains  = 4,
  iter_warmup   = 1000,
  iter_sampling = 4000    # -> 16000 Samples insgesamt
)

# Samples des Parameters p als Vektor extrahieren
samples <- fit$draws("p")    # samples = theta_i
cat("Anzahl Posterior-Samples:", length(samples), "\n\n")


# =====================================================================
#  DING 1: Posterior visualisieren  (Histogramm + Density)
# =====================================================================
hist(samples, freq = FALSE, breaks = 40,
     main = "Posterior p(p | D)",
     xlab = "p (Wasseranteil)", col = "grey85", border = "white")
lines(density(samples), col = "blue", lwd=2)

# Analytische Loesung zum Vergleich (hier bekannt: Beta-Posterior)
#   Prior Uniform(0,1) = Beta(1,1)  ->  Posterior = Beta(W+1, N-W+1)
curve(dbeta(x, W + 1, N - W + 1), add = TRUE,
      col = "red", lwd = 2, lty = 2)
legend("topleft", bty = "n",
       legend = c("Density (Samples)", "Beta(W+1, N-W+1) exakt"),
       col = c("blue", "red"), lwd = 2, lty = c(1, 2))


# =====================================================================
#  DING 2: Punktschaetzer  (Mean / Median)
# =====================================================================
post_mean   <- mean(samples)
post_median <- median(samples)

cat("Punktschaetzer\n")
cat("  Posterior-Mean  :", round(post_mean,   4), "\n")
cat("  Posterior-Median:", round(post_median, 4), "\n\n")

# In den Plot einzeichnen
abline(v = post_mean,   col = "darkgreen", lwd = 2)
abline(v = post_median, col = "orange",    lwd = 2, lty = 3)


# =====================================================================
#  DING 3: Kredibilitaetsintervall  (Quantile)
# =====================================================================
ci_90 <- quantile(samples, c(0.05, 0.95))   # 90%-Intervall
ci_95 <- quantile(samples, c(0.025, 0.975)) # 95%-Intervall

cat("Kredibilitaetsintervalle (quantile-basiert)\n")
cat("  90% CI: [", round(ci_90[1], 4), ",", round(ci_90[2], 4), "]\n")
cat("  95% CI: [", round(ci_95[1], 4), ",", round(ci_95[2], 4), "]\n\n")

# 90%-Intervall im Plot markieren
abline(v = ci_90, col = "purple", lwd = 2, lty = 2)


# =====================================================================
#  BONUS: Monte-Carlo-Integration -- der eigentliche Trick
#  Beliebige abgeleitete Groessen direkt aus den Samples schaetzen,
#  ohne ein Integral loesen zu muessen.
# =====================================================================

# P(p > 0.5) = Anteil der Samples, die die Bedingung erfuellen
#   entspricht  E[ 1{p > 0.5} ]  =  (1/T) * sum( 1{p_t > 0.5} )
prob_gt_05 <- mean(samples > 0.5)
cat("Monte-Carlo-Integration\n")
cat("  P(p > 0.5 | D) =", round(prob_gt_05, 4), "\n")

# Erwartungswert einer beliebigen Funktion, z.B. E[p^2]
cat("  E[p^2 | D]     =", round(mean(samples^2), 4), "\n")
