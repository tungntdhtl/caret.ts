
<!-- README.md is generated from README.Rmd. Please edit that file -->
caret.ts: time series models for "caret" package
================================================

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

### Quick demonstration

This simple example shows how

License
-------

**caret.ts** is released under the [MIT License](https://opensource.org/licenses/MIT)

Copyright (c) 2016 Stefan Feuerriegel
