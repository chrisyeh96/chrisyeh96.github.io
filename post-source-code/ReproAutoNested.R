# From: Automatically Generating Two-Stage Nested Models          #
# https://gatesdupont.github.io/2019/05/29/Auto-Nested-Mod.html   #
# By Gates Dupont                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set.seed(1)

"Borrowed from mgcv vignette"

## simulate some data...
f0 <- function(x) 2 * sin(pi * x); f1 <- function(x) exp(2 * x)
f2 <- function(x) 0.2 * x^11 * (10 * (1 - x))^6 + 10 * 
  (10 * x)^3 * (1 - x)^10
n <- 500;set.seed(5)
x0 <- runif(n); x1 <- runif(n)
x2 <- runif(n); x3 <- runif(n)

## Simulate probability of potential presence...
eta1 <- f0(x0) + f1(x1) - 3
p <- binomial()$linkinv(eta1) 
y <- as.numeric(runif(n)<p) ## 1 for presence, 0 for absence

## Simulate y given potentially present (not exactly model fitted!)...
ind <- y>0
eta2 <- f2(x2[ind])/3
y[ind] <- rpois(exp(eta2),exp(eta2))

## Fit ZIP model... 
b <- mgcv::gam(list(y
                    ~ s(x2) + s(x3),
                    ~ s(x0) + s(x1)),
               family = ziplss()
               )

"End borrowed code"

# # # # # # # # #
# Gates Dupont  #
# May 2019      #
# # # # # # # # #

library(mgcv)
library(dplyr)
library(stringr)
library(qpcR)

# Set up a data.frame, include invar
df = data.frame(
  y  = y,
  x0 = x0, # detect
  x1 = x1, # detect
  x2 = x2, # count
  x3 = x3, # count
  invar = 1) %>%
  mutate(invar = 1) # invariant term

#----Constrcut model formula----

# All covariate combinations by stage
count = expand.grid(
  count_x2  = c("s(x2)", "invar"),
  count_x3  = c("s(x3)", "invar")
)

detect = expand.grid(
  detect_x0  = c("s(x0)", "invar"),
  detect_x1  = c("s(x1)", "invar")
)

print(count)
print(detect)

# Looping to convert to formulas
model.formulas = vector("list", 16)
k = 1
for (i in 1:length(count[, 1])) {
  a = as.character(unlist(count[i, ])) %>%
    str_flatten(collapse = " + ")
  
  for (j in 1:length(detect[, 1])) {
    b = as.character(unlist(detect[j, ])) %>%
      str_flatten(collapse = " + ")
    
    model.formulas[[k]] = list(formula(str_glue("y", " ~ ", a)),
                               formula(str_glue(" ~ ", b)))
    k = k + 1
  }
}

print(model.formulas[[1]])

#----Construct model names----

# Similar to above
count.names = expand.grid(
  count_x2  = c("x2", "."),
  count_x3  = c("x3", ".")
)

detect.names = expand.grid(
  detect_x0  = c("x0", "."),
  detect_x1  = c("x1", ".")
)

model.names = vector("list", 16)
k = 1
for (i in 1:length(count.names[, 1])) {
  a = as.character(unlist(count.names[i, ]))
  a = paste(a, collapse = ",")
  
  for (j in 1:length(detect.names[, 1])) {
    b = as.character(unlist(detect.names[j, ]))
    b = paste(b, collapse = ",")
    
    model.names[[k]] = paste(str_glue("N(", a, ")", "Phi(", b, ")"))
    k = k + 1
  }
}

data.frame(models=(unlist(model.names)))

#----Running models in parallel----
library(doParallel)
cores = detectCores()
cl = makeCluster(cores[1] - 1) # Leave one for the machine
registerDoParallel(cl)

# count (2^2) * detect (2^2) = 16 = 1 global + 15 nested
model.fits = foreach(i = 1:16, .packages = c("mgcv")) %dopar% {
  assign(model.names[[i]],
         gam(
           formula = model.formulas[[i]],
           family = ziplss,
           gamma = 1.4,
           data = df
         ))
}
stopCluster(cl)

#----Assigning Names----
for (i in 1:16) {
  assign(model.names[[i]],
         model.fits[[i]])
}

#----AIC Model Comparison table----
aic.call = paste0("`", model.names, "`") %>%
  str_flatten(., ", ") %>%
  paste0("AIC(", ., ")") # Building AIC call
models.aic = eval(parse(text = aic.call))
models.weights = akaike.weights(models.aic$AIC) # Making AIC table
models.aictab = cbind(models.aic, models.weights)
models.aictab = models.aictab[order(models.aictab["deltaAIC"]), ]
models.aictab = round(models.aictab, 2)
View(models.aictab)

#----select = T----
testSelect = gam(list(y
                      ~ s(x2) + s(x3),
                      ~ s(x0) + s(x1)),
                 family = ziplss(),
                 gamma = 1.4,
                 select = T)
summary(testSelect)

data.frame(AIC(testSelect, `N(x2,.)Phi(x0,x1)`)) %>%
  mutate(model = rownames(.)) %>%
  mutate(deltaAIC = AIC-min(AIC)) %>%
  arrange(AIC) %>%
  select(3,1,2,4)
