# VOLATILITY SPILLOVERS AND NONLINEAR REGIME-SHIFTS: A DCC-GARCH & TVAR APPROACH

🛠️ **Tech Stack**: R (rugarch, rmgarch, tsDyn, haven, zoo, pastecs)

---

## (i). Overview

This project explores the **dynamic co-movement** and **volatility spillovers** between **Ethereum (ETH)** and **Gold (XAU)** using two robust econometric frameworks: the **Dynamic Conditional Correlation GARCH (DCC-GARCH)** and **Threshold Vector Autoregression (TVAR)**. The aim is to evaluate how these digital and traditional assets interact over time—especially under different volatility regimes.

Key questions addressed:

- Does Ethereum act as a **volatility transmitter** or **receiver** relative to gold?
- How does the **conditional correlation** between ETH and XAU evolve during periods of **market stress**?
- Are there **nonlinear regime shifts** in their return behavior?

---

## (ii). Methodology

### 🔁 DCC-GARCH (Engle, 2002)

- Captures **time-varying volatilities** and **dynamic correlations**.
- ETH and XAU modeled under:
  - Univariate GARCH(1,1) → individual volatilities.
  - DCC component → dynamic correlation matrix.

### ⚡ TVAR Model (Tsay, 1998)

- Models **regime-dependent behavior** using ETH lag returns as the threshold variable.
- Allows separate **VAR(2)** structures across 3 regimes:
  - Regime 1: Low ETH returns
  - Regime 2: Medium ETH returns
  - Regime 3: High ETH returns
- Optimal thresholds chosen via **Likelihood Ratio test** and **grid search**.

---

## (iii). Modeling Pipeline

```text
STEP 1: Import daily ETH and XAU price data (2020–2025)  
→ STEP 2: Clean and convert to log returns (lnETH, lnXAU)  
→ STEP 3: Conduct descriptive stats & normality tests  
→ STEP 4: Estimate DCC-GARCH(1,1) model  
→ STEP 5: Visualize conditional mean, sigma, covariance, correlation  
→ STEP 6: Estimate equal-weighted (EW) portfolio with 1% VaR limits  
→ STEP 7: Perform TVAR threshold test (r = 3 regimes)  
→ STEP 8: Estimate TVAR(2) model for ETH–XAU  
→ STEP 9: Visualize regimes, transitions, and SSR plots  
```

---

## (iv). Key Findings

- **ETH exhibits higher volatility** than gold across all timeframes.
- **DCC-GARCH results**:
  - ETH β = 0.89, XAU β = 0.84 → strong **volatility persistence**.
  - Dynamic correlation spikes during **market crises** (e.g., COVID-19, inflation shocks).
- **TVAR estimation**:
  - Identifies **3 threshold regimes** (based on ETH returns).
  - Significant regime differences in **cross-lag effects** and **shock responses**.
- **Portfolio Implication**: Time-varying correlation and non-linear effects suggest combining ETH and XAU offers **dynamic diversification** that is **regime-sensitive**.

---

## (v). Application: Risk & Portfolio Implications

- ETH is a **volatility amplifier**—impacts gold more during **market shocks**.
- Gold maintains a **defensive role**, especially in Regime 1 (low ETH).
- Portfolio strategies must be **nonlinear-aware**:
  - Hedge ETH using gold in **high volatility regimes**.
  - Use TVAR thresholds to **signal regime switches** for dynamic allocation.

---

## (vi). Repository Contents

- `R Script.R`: Full modeling code (ETH-XAU volatility & TVAR)
- `Dataset.dta`: Cleaned dataset with daily ETH and XAU prices & returns
- `README.md`: Project documentation
- `Methods and Results.pdf`: Summary writeup of methods and results

