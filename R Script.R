##############################################
## DYNAMIC VOLATILITY AND REGIME ANALYSIS   ##
## ETH–XAU: DCC-GARCH & TVAR Implementation ##
##############################################

## ──────────────────────────────
## 1. Load Required Libraries
## ──────────────────────────────
library(haven)              # for importing .dta dataset
library(dplyr)              # for data wrangling
library(xts)                # for time-series object
library(zoo)                # for date-indexed series
library(pastecs)            # for descriptive statistics
library(quantmod)           # financial time series handling
library(PerformanceAnalytics) 
library(rugarch)            # univariate GARCH
library(rmgarch)            # DCC-GARCH
library(FinTS)              # financial diagnostics
library(car)                # additional test utilities
library(tseries)            # for ADF, PP tests
library(tsDyn)              # for TVAR model

## ──────────────────────────────
## 2. Import & Prepare Dataset
## ──────────────────────────────
data <- read_dta("/Users/thieu/Desktop/Dataset.dta")
data_clean <- na.omit(data)
data_clean$date <- as.Date(data_clean$date)

## Convert to time-series objects
lnETH <- ts(data_clean$lnETH, frequency = 365)
lnXAU <- ts(data_clean$lnXAU, frequency = 365)

## Construct XTS object for time-based modeling
combined <- xts(data_clean[, c("lnETH", "lnXAU")], order.by = data_clean$date)

## Base bivariate matrix
biv <- cbind(data_clean$lnETH, data_clean$lnXAU)
colnames(biv) <- c("lnETH", "lnXAU")

## ──────────────────────────────
## 3. Descriptive Analysis
## ──────────────────────────────
## Table 1: Raw price stats
stat.desc(data[, c("ETH", "XAU")], norm = TRUE)

## Table 2: Log return stats
stat.desc(data[, c("lnETH", "lnXAU")], norm = TRUE)

## Visualization of returns
plot(lnETH, main = "ETH Returns (Log)", col = "blue")
plot(lnXAU, main = "XAU Returns (Log)", col = "gold")

## ──────────────────────────────
## 4. DCC-GARCH Model Estimation
## ──────────────────────────────

## 4.1 Specify univariate GARCH(1,1) spec
garchSpec <- ugarchspec(
  mean.model = list(armaOrder = c(0, 0)),
  variance.model = list(garchOrder = c(1, 1), model = "sGARCH"),
  distribution.model = "norm"
)

## 4.2 Build DCC specification
dccSpec <- dccspec(
  uspec = multispec(replicate(2, garchSpec)),
  dccOrder = c(1, 1),
  distribution = "mvnorm"
)

## 4.3 Fit the DCC-GARCH model
dccFit <- dccfit(dccSpec, data = biv)
summary(dccFit)

## 4.4 Visual diagnostics
plot(dccFit, which = 4)  # Conditional volatility
ts.plot(rcor(dccFit)[1, 2, ], main = "Conditional Correlation (ETH vs XAU)")

## 4.5 Forecasting
dccFcst <- dccforecast(dccFit, n.ahead = 100)
plot(dccFcst)

## ──────────────────────────────
## 5. TVAR Model Estimation
## ──────────────────────────────

## 5.1 Threshold test: choose regime structure
TVAR.LRtest(biv, lag = 2, mTh = 1, thDelay = 1:2,
            nboot = 3, plot = FALSE, trim = 0.1, test = "1vs")
## ➤ Indicates r = 3 regimes

## 5.2 Estimate TVAR(2) with 3 regimes
tv3 <- TVAR(
  biv, lag = 2, nthresh = 3,
  thDelay = 1, trim = 0.1,
  mTh = 1, plot = FALSE
)

## 5.3 Summary and plots
summary(tv3)
plot(tv3)
