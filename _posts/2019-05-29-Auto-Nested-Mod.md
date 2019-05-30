---
title: "Automatically Generating Two-Stage Nested Models"
layout: post
published: true
use_code: true
---

Statistical models are widely used in ecology to improve our understand of ecological dynamics and processes. At their foundation, these models quantify the relationships between a predictor variable and a suite of explanatory covariates, be it linear or non-linear. Such covariates can be observational or environmental. However, determining which covariates to include in a model can be a bit tricky. One of the most commmonly accepted methods to determine a model formula is through AIC model comparison and averaging of nested models within a global model. A global model is one that is fully-defined with the inclusion of all considered covariates, while nested models include only a subset of the considered covariates. While it might not sound intuitive, a nested model can (sometimes) perform better than it's global model, as predicted by the principle of parsimony. Also known as Occam's Razor, this principle states that the simplest explanation is often correct, supporting the case for a more parsimonious model. 

Generating a set of nested models from a global model is typically automated in the popular statistical softwares available, but this mostly applies to linear models. As many biological relationships are nonlinear, other forms of models have become increasingly used due to their ability to capture these more sophisiticated relationship. One of the most popular methods to model nonlinear relationships is the Generalized Addidtive Model ('GAM'). GAMs are a powerful tool throughout the field of data science, and have been used to predict things from the trajectory of stock markets to changes in species distributions under climate change emissions scenarios. 

In my undergrad thesis on avian populations and West Nile virus, I used a GAM to model citizen-science count data. It was a special type of model, though, known as a Zero Inflated Poisson Location-Scale Model ('ziplss'), as developed by the highly-regarded Dr. Simon Wood. This model is separated into two stages: the first stage models the probability of presence, while the second stage models the average abundance given presence. From a biological perspective, it allows us to ask: 1) Was a species present? and 2) if so, how many of them were there?

This is all well and good, but two-stage nature of the modelling process and respective formula makes it far more difficult to generate and test all nested models. However, this is a necessary part of the process, especially as step-wise model selection is becoming less accepted. Given this issue, I've written this tutorial on how to go about this process for the ziplss GAM, hoping it's useful to someone in the field.

### Setup

First, we'll load the required packages. The `mgcv` package is the leading package for fitting GAMs, `tidyr` greatly improves coding efficient by tapping into the tidyverse framework, `stringr` allows for better methods to manipulate strings, and `qpcR` provides some neat functionality for model averaging.

```r
library(mgcv)
library(tidyr)
library(stringr)
library(qpcR)
```
