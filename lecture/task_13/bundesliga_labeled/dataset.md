# Dataset: Bundesliga 2025/26 Match Results

## Overview

Real match results from the German **Bundesliga 2025/26 season** (1st division, 18 teams,
22 Aug 2025 – 16 May 2026). Each observation is a match between a home team and an away team
with the goals scored by each. The goal is to model team **attack** and **defense** strengths
and to predict goals in held-out (later-season) matches.

Source: [football-data.co.uk](https://www.football-data.co.uk/germanym.php) (free for academic
use). The raw download is kept as `../raw_D1_2526.csv`; `../prepare_data.R` reproduces the files
below.

## Files

**`teams.csv`** — lookup table:

- `team_id` — integer 1–18 (assigned alphabetically by short name, deterministic)
- `team_name` — official club name (use this for plot labels)

**`train.csv`** and **`protected/test.csv`** columns:

- `home_team_id` — integer, home team id (1–18)
- `away_team_id` — integer, away team id (1–18)
- `home_goals` — non-negative integer, goals scored by the home team
- `away_goals` — non-negative integer, goals scored by the away team

**207 training matches, 99 test matches.** The split is **temporal**: matches are sorted by date,
the first 207 (≈ matchdays 1–23) are training, the last 99 (≈ matchdays 24–34) are the held-out
test set. All 18 teams appear in both splits.

## Data Interface

The fitting script passes the following to Stan (see `../bundesliga_hier.stan`):

```stan
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
```

## Model & outputs

`bundesliga_hier.stan` is a hierarchical Poisson model with partially-pooled `attack[j]` /
`defense[j]`, a shared `home_adv`, and baseline `mu`. Its `generated quantities` block returns:

- `log_lik` — vector of length `2 * N_test` (first `N_test` = home-goal log-likelihoods, second
  `N_test` = away-goal log-likelihoods); used for the **NLPD/NLL** and `loo`.
- `goals_home_rep`, `goals_away_rep` — posterior-predictive simulated goals per test fixture; used
  for score-distribution plots and the **P(team A beats team B)** task.
