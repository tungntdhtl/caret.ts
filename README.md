
<!-- README.md is generated from README.Rmd. Please edit that file -->
caret.ts: time series models for the "caret" package
====================================================

[![Build Status](https://travis-ci.org/sfeuerriegel/caret.ts.svg?branch=master)](https://travis-ci.org/sfeuerriegel/caret.ts) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/caret.ts)](https://cran.r-project.org/package=caret.ts) [![Coverage Status](https://img.shields.io/codecov/c/github/sfeuerriegel/caret.ts/master.svg)](https://codecov.io/github/sfeuerriegel/caret.ts?branch=master)

**caret.ts** provides various functions for machine learning with time series data. While the "caret" package is common in various tasks related to machine learning; its naive version does yet ship dedicated time series models. This implementation thus extends the "caret" package and offers additional models, including ARMA or ARIMA. Additionally, it customizes the "train" function to accept time series data.

Overview
--------

The most important functions in **caret.ts** are:

-   TODO.

To see examples of these functions in use, check out the help pages, the demos and the vignette.

Installation
------------

Using the **devtools** package, you can easily install the latest development version of **caret.ts** with

``` r
install.packages("devtools")

# Option 1: download and install latest version from ‘GitHub’
devtools::install_github("sfeuerriegel/caret.ts")

# Option 2: install directly from bundled archive
# devtoos::install_local("caret.ts_0.1.0.tar.gz")
```

Notes:

-   In the case of option 2, you have to specify the path either to the directory of **caret.ts** or to the bundled archive **caret.ts\_0.1.0.tar.gz**

-   A CRAN version has not yet been released.

Usage
-----

This section shows the basic functionality of how to perform machine learning with time seris models inside **caret**. First, load the corresponding package **caret.ts**.

``` r
library(caret.ts)
```

The examples below how to insert the models inside the `train()` function from **caret**. Additionally, this package also implements an additional variant of the `train()` function that accepts time series objects.

### ARMA model

Auto-regressive moving-average (ARMA) models can be faciliated both with and without exogeneous variables. By using `arma_model(p, q)`, one can construct an ARMA model of a fixed, pre-defined order. Alternatively, one can let the `train()` function pick the order that fits the training data best. For the latter purpose, use `auto_arma_model()` (with optional arguments for the maximum order).

Example without exogenous variables:

Example with exogenous variables:

Predictions and testing:

### ARIMA model

Auto-regressive moving-average models with differneces (ARIMA) also support exogeneous variables if desired. By using `arima_model(p, q)`, one can construct an ARIMA model of a fixed, pre-defined order. Alternatively, one can let the `train()` function pick the order that fits the training data best. For the latter purpose, use `auto_arima_model()` (with optional arguments for the maximum order).

Example without exogenous variables:

``` r
library(forecast)
#> Warning: package 'forecast' was built under R version 3.3.1
#> Loading required package: zoo
#> 
#> Attaching package: 'zoo'
#> The following objects are masked from 'package:base':
#> 
#>     as.Date, as.Date.numeric
#> Loading required package: timeDate
#> This is forecast 7.1

data(WWWusage) # from package "forecast"
df <- data.frame(y = as.numeric(WWWusage))

library(caret)
#> Warning: package 'caret' was built under R version 3.3.1
#> Loading required package: lattice
#> Loading required package: ggplot2

arima1 <- train(y ~ 1, data = df, method = arima_model(1, 1, 1), trControl = trainDirectFit())
summary(arima1)
#> Series: y 
#> ARIMA(1,1,1)                    
#> 
#> Coefficients:
#>          ar1     ma1
#>       0.6504  0.5256
#> s.e.  0.0842  0.0896
#> 
#> sigma^2 estimated as 9.995:  log likelihood=-254.15
#> AIC=514.3   AICc=514.55   BIC=522.08
#> 
#> Training set error measures:
#>                     ME     RMSE      MAE       MPE     MAPE      MASE
#> Training set 0.3035616 3.113754 2.405275 0.2805566 1.917463 0.5315228
#>                     ACF1
#> Training set -0.01715517
RMSE(arima1$pred, df$y) # in-sample RMSE
#> [1] NaN

arima2 <- train(y ~ 1, data = df, method = arima_model(1, 2, 1), trControl = trainDirectFit())
summary(arima2)
#> Series: y 
#> ARIMA(1,2,1)                    
#> 
#> Coefficients:
#>           ar1     ma1
#>       -0.2662  0.6140
#> s.e.   0.1820  0.1369
#> 
#> sigma^2 estimated as 11.73:  log likelihood=-258.8
#> AIC=523.59   AICc=523.85   BIC=531.35
#> 
#> Training set error measures:
#>                      ME     RMSE      MAE       MPE     MAPE      MASE
#> Training set 0.01532745 3.356088 2.640365 0.1542981 2.078754 0.5834736
#>                     ACF1
#> Training set -0.05217069
RMSE(arima2$pred, df$y) # in-sample RMSE
#> [1] NaN

auto_arima <- train(y ~ 1, data = df, method = auto_arima_model(), trControl = trainDirectFit())
summary(auto_arima)
#> Series: y 
#> ARIMA(1,1,1)                    
#> 
#> Coefficients:
#>          ar1     ma1
#>       0.6504  0.5256
#> s.e.  0.0842  0.0896
#> 
#> sigma^2 estimated as 9.995:  log likelihood=-254.15
#> AIC=514.3   AICc=514.55   BIC=522.08
#> 
#> Training set error measures:
#>                     ME     RMSE      MAE       MPE     MAPE      MASE
#> Training set 0.3035616 3.113754 2.405275 0.2805566 1.917463 0.5315228
#>                     ACF1
#> Training set -0.01715517
RMSE(arima2$pred, df$y) # in-sample RMSE
#> [1] NaN
```

Example with exogenous variables:

Predictions and testing:

### Alternative interface for training with time series objects

`trainDirectFit()`

License
-------

**caret.ts** is released under the [MIT License](https://opensource.org/licenses/MIT)

Copyright (c) 2016 Stefan Feuerriegel
