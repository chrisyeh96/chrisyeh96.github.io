---
title: "Automatically Generating Two-Stage Nested Models"
layout: post
published: true
use_code: true
---

Statistical models are widely used in ecology to improve our understand of ecological dynamics and processes. At their foundation, these models quantify the relationships between a predictor variable and a suite of explanatory covariates, be it linear or non-linear. Such covariates can be observational or environmental. However, determining which covariates to include in a model can be a bit tricky. One of the most commmonly accepted methods to determine a model formula is through AIC model comparison and averaging of nested models within a global model. A global model is one that is fully-defined with the inclusion of all considered covariates, while nested models include only a subset of the considered covariates. While it might not sound intuitive, a nested model can (sometimes) perform better than it's global model, as predicted by the principle of parsimony. Also known as Occam's Razor, this principle states that the simplest explanation is often correct, supporting the case for a more parsimonious model. 

Generating a set of nested models from a global model is typically automated in the popular statistical softwares available, but this mostly applies to linear models. As many biological relationships are nonlinear, other forms of models have become increasingly used due to their ability to capture these more sophisiticated relationship. One of the most popular methods to model nonlinear relationships is the Generalized Addidtive Model ('GAM'). GAMs are a powerful tool throughout the field of data science, and have been used to predict things from the trajectory of stock markets to changes in species distributions under climate change emissions scenarios. 

In my undergrad thesis on avian populations and West Nile virus, I used a GAM to model citizen-science count data. It was a special type of model, though, known as a Zero Inflated Poisson Location-Scale Model ('ziplss'), as developed by the highly-regarded Dr. Simon Wood. This model is separated into two stages: the first stage models the probability of presence, while the second stage models the average abundance given presence. From a biological perspective, it allows us to ask: 1) was a species present? and 2) if so, how many of them were there?

This is all well and good, but two-stage nature of the modelling process and respective formula makes it far more difficult to generate and test all nested models. However, this is a necessary part of the process, especially as step-wise model selection is becoming less accepted. Given this issue, I've written this tutorial on how to go about this process for the ziplss GAM, hoping it's useful to someone in the field. Additionally, I'll also include the model averaging process, which makes use of parallel computing. This is increasingly useful with more explanatory variables, as fitting GAMs is computationally intensive, and therefore, time-consuming. Parallelizing the process allows for each core in a cluster to run a model. On my computer, I have 16 cores, 15 of which I add to a cluster, allowing me to run 15 of these GAMs simultaneously. This reduces the run-time by over 93%.

### Setup

First, we'll load the required packages. The `mgcv` package is the leading package for fitting GAMs, `tidyr` greatly improves coding efficient by tapping into the tidyverse framework, `stringr` allows for better methods to manipulate strings, and `qpcR` provides some neat functionality for model averaging.

```r
library(mgcv)
library(tidyr)
library(stringr)
library(qpcR)
```

### Generating all possible covariate combinations

In a single function, we'll specify all of the explanatory variables for both stages of our full model and then generate all the possible combinations of those variables. This is possible through the use of the `expand.grid()`, which generates the cartesian product of the supplied values. Although our end goal is to create a model formula, `exapand.grid()` ouputs a `data.frame` object, where each row represents a nested model formula. We'll convert these rows to formulas in the next step.

It's important to note here that we assume the original data has a "dummy" column which is just filled with 1s. In this example from my thesis, `efforDays` and `effortHours` are categorical variable and should not be smoothed with the smoothing function `s()`, which `yr`, `lat`, and `lon` are continuons and should be smoothed to make use of the power of GAMs.

```r
count = expand.grid(
  count_days    = c("effortDays", "dummy"),
  count_hours   = c("effortHours", "dummy"),
  count_years   = c("s(yr, k=11)", "dummy"),
  count_latlon  = c("s(lat, long)", "dummy")
)

detect = expand.grid(
  detect_days    = c("effortDays", "dummy"),
  detect_hours   = c("effortHours", "dummy"),
  detect_years   = c("s(yr, k=11)", "dummy"),
  detect_latlon  = c("s(lat, long)", "dummy")
)

head(count, 3)
head(detect, 3)
```
This gives us the following output:
```r
>head(count, 3)
  count_days count_hours count_years count_latlon
1 effortDays effortHours s(yr, k=11) s(lat, long)
2      dummy effortHours s(yr, k=11) s(lat, long)
3 effortDays       dummy s(yr, k=11) s(lat, long)

>head(detect, 3)
  detect_days detect_hours detect_years detect_latlon
1  effortDays  effortHours  s(yr, k=11)  s(lat, long)
2       dummy  effortHours  s(yr, k=11)  s(lat, long)
3  effortDays        dummy  s(yr, k=11)  s(lat, long)
```


### Converting to model formulas

This next part is a little less straightforward. In the first line, we create a`list` vector with 256 blank elements, which is the total number of models (1 global + 255 nested). This is because there are 4 paramters with two option (variant vs invariant) in each of the 2 steps, so: $$2<sup>4</sup> * 2<sup>4</sup> = 256$$. The model formulas need to be saved in a list form as this is what the `mgcv::gam()` function expects. 

We set `k = 1` as the initial position for iteration through the nested loops. We then loop through both stages of the forumla, unlisting each row from the `data.frame` and converting it to a `character` vector. During this process, the selected parameters are concatenated with a `+` symbol as expected by the `mgcv::gam()` function. The final model uses `~` in concatenating both stages from the `i` and `j` loops, and again using `~` after specifiying the predictor (here, `maxFlock`).

Finally, `k = k + 1` increments the process through the 256 iterations.

```r
model.formulas = vector("list", 256)
k = 1
for (i in 1:length(count[, 1])) {
  a = as.character(unlist(count[i, ])) %>%
    str_flatten(collapse = " + ")
  
  for (j in 1:length(detect[, 1])) {
    b = as.character(unlist(detect[j, ])) %>%
      str_flatten(collapse = " + ")
    
    model.formulas[[k]] = list(formula(str_glue("maxFlock", " ~ ", a)),
                         formula(str_glue(" ~ ", b)))
    k = k + 1
  }
}

print(model.formulas[[1:3]])
```
And here we see the resulting, two-stage models:
```r
[[1]]
[[1]][[1]]
maxFlock ~ effortDays + effortHours + s(yr, k = 11) + s(lat, 
    long)

[[1]][[2]]
~effortDays + effortHours + s(yr, k = 11) + s(lat, long)


[[2]]
[[2]][[1]]
maxFlock ~ effortDays + effortHours + s(yr, k = 11) + s(lat, 
    long)

[[2]][[2]]
~dummy + effortHours + s(yr, k = 11) + s(lat, long)


[[3]]
[[3]][[1]]
maxFlock ~ effortDays + effortHours + s(yr, k = 11) + s(lat, 
    long)

[[3]][[2]]
~effortDays + dummy + s(yr, k = 11) + s(lat, long)
```


