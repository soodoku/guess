### guess: Adjust Estimates of Learning for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)
[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/guess)

Over informative processes, naive estimator of learning -- difference between post and pre process scores-- underestimates actual learning. A heuristic account for why the naive estimator is negatively biased is as follows: people know as much or more after exposed to an informative process than before it. The less people know, the larger the number of items they don't know. And greater the opportunity to guess. Guessing - even when random - only increases the proportion correct. Thus bias due to guessing for naive measures of knowledge is always positive. On average, thus, there is more positive bias in the pre-process scores than post-process. And subtracting pre-process scores from post-process thus provides an attenuated estimate of actual learning. For a more complete treatment of the issue, read [this paper](http://gsood.com/research/papers/guess.pdf) by Gaurav Sood and Ken Cor.

We provide a few different ways to adjust estimates of learning for guessing. For now, we limit our attention to cases where the same battery of knowledge questions has been asked in both the pre- and the post-process wave. And to cases where closed-ended questions have been asked. (Guessing is not a serious issue on open-ended items. See more evidence for that in [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Robert Luskin and John Bullock.)  More generally, the package implements the methods to adjust learning for guessing discussed in [this paper](http://gsood.com/research/papers/guess.pdf).

### Measuring Learning:

#### Estimand

Proportion of people who learned a particular piece of information over the course of an informative process. 

#### Other Issues
Measurement of knowledge is fundamentally reactive -- we must probe to learn. But probing is not without its problems. For instance, people who don't know the answer try to triangulate based on the cues in the question itself. For another, people are remarkably averse to confessing to their ignorance. So on a closed ended question, lots of people who don't know the right answer, guess. Here are some pertinent issues that relate to how we analyze the data:

1. **Dealing with Missing Data**  
If you assume that the data are missing completely at random, you can simply ignore them. Generally, however, respondents tend to skip items they don't know. So missing responses on knowledge questions typically indicate ignorance. (Of course, it is important to investigate other potential reasons behind missing data. And we encourage researchers to take all precautions.) In our treatment, however, for simplicity sake, we treat missing as indicators of ignorance. 

2. **Dealing with Don't Know**  
We now know a little bit about Don't Know. One generally strategy is to treat Don't Know responses as ignorance. But research suggests that on average there is approximately 3\% hidden knowledge behind Don't Know responses. See [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Robert Luskin and John Bullock. Thus one can also choose to replace Don't Know responses with .03.

3. **Related Knowledge**  
People either know a particular piece of information or they don't. On an open-ended question, they may struggle to remember it but those kinds of concerns don't apply to closed-ended questions where the task is simply to identify the correct answer. What does on occassion happen on closed-ended questions is that people have related cognitions. So for instance, asked to identify the prime minister of France, the respondents sometimes know that one of the options is the king of Sudan and may guess randomly between the remaining options. But that isn't the same as knowing the prime minister of France. 

#### Standard Correction for Guessing

The standard correction for guessing assumes that people guess randomly. And that people either know or don't know. Using this assumption, it then uses total number of incorrect answers to estimate the total number of items that the person guessed on. For instance, let us assume there are 4 options on a multiple choice question. Say we have data from 100 respondents. Say there are 70 incorrect answers and 30 correct. Incorrect answers reflect attempts of guessing. (We also assume that people aren't misinformed.) This means we can triangulat the total number of questions respondents guessed on -- 70*(4/3). This means that the proportion of people who know the piece of information is roughly .067. Do it for the pre and the post wave and you have estimate of learning adjusted for guessing using the standard correction.

#### Latent Class Correction for Guessing

### Installation

To get the current development version from github:


```r
# install.packages("devtools")
library(devtools)
#devtools::install_github("soodoku/guess")
```

### Usage

#### Standard Correction for Guessing

To adjust estimates of learning for standard correction of guessing, use `stndcor`. The function requires takes pre test and post test data frames containing responses to the items on the pre- and the post-test, and a `lucky` vector that contains the probability of getting an item correct when guessing randomly. Under standard guessing correction, it is taken to be inverse of total number of options. 

**Structure of the Input Data:**

1. For current purposes, we assume missing responses to indicate ignorance. Thus functions internally code missing responses as 0.
2. If the items offer an option to mark `Don't know`, code all `Don't Know` responses as 'd'.


```r
library(guess)
pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)) 
pst_test <-  pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
lucky <- rep(.25, 2)

# Unadjusted Effect
# Treating Don't Know as ignorance
colMeans(nona(pst_test) - nona(pre_test))
```

```
## item1 item2 
##   0.4   0.2
```

```r
# MCAR
colMeans(pst_test - pre_test, na.rm=T)
```

```
## item1 item2 
##  0.40  0.25
```

```r
# Adjusted Effect
stndcor(pre_test, pst_test, lucky)
```

```
## $pre
##     item1     item2 
## 0.2000000 0.2666667 
## 
## $pst
##     item1     item2 
## 0.7333333 0.5333333 
## 
## $learn
##     item1     item2 
## 0.5333333 0.2666667
```

#### Transition Matrix


```r
# Without Don't Know
pre_test_var <- c(1,0,0,1,0,1,0) 
pst_test_var <- c(1,0,1,1,0,1,1)
print(transmat(pre_test_var, pst_test_var))
```

```
##   0 1
## 0 2 0
## 1 2 3
## x00 x10 x01 x11 
##   2   2   0   3
```

```r
# With Don't Know
pre_test_var <- c(1,0,NA,1,"d","d",0,1,0)
pst_test_var <- c(1,0,1,"d",1,0,1,1,"d")
print(transmat(pre_test_var, pst_test_var))
```

```
##   0 1 d
## 0 1 0 1
## 1 2 2 1
## d 1 1 0
## x00 x10 xd0 x01 x11 xd1 xd0 x1d xdd 
##   1   2   1   0   2   1   1   1   0
```

#### Estimates from the Latent Class Model


```r
# load(file.path(system.file(package = "guess"), "data", "alldat.rda"))
load("data/alldat.rda")

# nitems
nitems <- length(alldat)/400

# Vectors of Names
t1 <- paste0("guess.t1", 1:nitems)
t2 <- paste0("guess.t2", 1:nitems)

# lucky
lucky <- rep(.25, (nitems+1))	

res <- guesstimate(alldat[,t1], alldat[,t2], lucky)
```

```
## 
##  Item 1 
##   0   1
## 0 8  11
## 1 8 473
## 
##  Item 2 
##    0   1
## 0 16   4
## 1 12 468
## 
##  Item 3 
##   0   1
## 0 5   5
## 1 9 481
## 
##  Item 4 
##   0   1
## 0 2   4
## 1 9 485
## 
##  Item 5 
##    0   1
## 0  7   5
## 1 14 474
## 
##  Item 6 
##    0   1
## 0 17   2
## 1  9 472
## 
##  Item 7 
##    0   1
## 0  9   4
## 1 13 474
## 
##  Item 8 
##    0   1
## 0 20   3
## 1 15 462
## 
##  Item 9 
##    0   1
## 0 17   5
## 1 18 460
## 
##  Item 10 
##    0   1
## 0 25   1
## 1 17 457
## 
##  Aggregate 
##        x00 x10 x01  x11
## item1    8   8  11  473
## item2   16  12   4  468
## item3    5   9   5  481
## item4    2   9   4  485
## item5    7  14   5  474
## item6   17   9   2  472
## item7    9  13   4  474
## item8   20  15   3  462
## item9   17  18   5  460
## item10 126 124  44 4706
## 
## 
## Iter: 1 fn: 134.6419	 Pars:  0.07656179909 0.00000002922 0.92343817140 0.54285573349
## Iter: 2 fn: 134.6419	 Pars:  0.076564035243 0.000000009896 0.923435954861 0.542859555980
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 150.0954	 Pars:  0.05000 0.02000 0.93000 0.20000
## Iter: 2 fn: 150.0954	 Pars:  0.05000 0.02000 0.93000 0.20000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 100.8425	 Pars:  0.04000 0.01600 0.94400 0.49999
## Iter: 2 fn: 100.8425	 Pars:  0.04000 0.01600 0.94400 0.50000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 81.2853	 Pars:  0.03600 0.03000 0.93400 0.66667
## Iter: 2 fn: 81.2853	 Pars:  0.03600 0.03000 0.93400 0.66667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 128.2764	 Pars:  0.04114 0.03086 0.92800 0.41667
## Iter: 2 fn: 128.2764	 Pars:  0.04114 0.03086 0.92800 0.41667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 131.8840	 Pars:  0.04247 0.01565 0.94188 0.10525
## Iter: 2 fn: 131.8840	 Pars:  0.04247 0.01565 0.94188 0.10527
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 128.2272	 Pars:  0.03756 0.02600 0.93644 0.30770
## Iter: 2 fn: 128.2272	 Pars:  0.03756 0.02600 0.93644 0.30769
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 168.8418	 Pars:  0.05290 0.02760 0.91950 0.13045
## Iter: 2 fn: 168.8418	 Pars:  0.05290 0.02760 0.91950 0.13043
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 178.7014	 Pars:  0.05694 0.03365 0.90941 0.22727
## Iter: 2 fn: 178.7014	 Pars:  0.05694 0.03365 0.90941 0.22727
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1415.6458	 Pars:  0.04587 0.02159 0.93254 0.25882
## Iter: 2 fn: 1415.6458	 Pars:  0.04587 0.02159 0.93254 0.25882
## solnp--> Completed in 2 iterations
```

```r
round(res[,1:4], 2)
```

```
##       [,1] [,2] [,3] [,4]
## lgg   0.08 0.05 0.04 0.04
## lgk   0.00 0.02 0.02 0.03
## lkk   0.92 0.93 0.94 0.93
## gamma 0.54 0.20 0.50 0.67
```

#### Standard Errors



#### Fit


```r
fit			<- fit_nodk(res[4,], res[1:3,], multi_transmat(alldat[,t1], alldat[,t2]), 100) 
```

```
## 
##  Item 1 
##   0   1
## 0 8  11
## 1 8 473
## 
##  Item 2 
##    0   1
## 0 16   4
## 1 12 468
## 
##  Item 3 
##   0   1
## 0 5   5
## 1 9 481
## 
##  Item 4 
##   0   1
## 0 2   4
## 1 9 485
## 
##  Item 5 
##    0   1
## 0  7   5
## 1 14 474
## 
##  Item 6 
##    0   1
## 0 17   2
## 1  9 472
## 
##  Item 7 
##    0   1
## 0  9   4
## 1 13 474
## 
##  Item 8 
##    0   1
## 0 20   3
## 1 15 462
## 
##  Item 9 
##    0   1
## 0 17   5
## 1 18 460
## 
##  Item 10 
##    0   1
## 0 25   1
## 1 17 457
## 
##  Aggregate 
##        x00 x10 x01  x11
## item1    8   8  11  473
## item2   16  12   4  468
## item3    5   9   5  481
## item4    2   9   4  485
## item5    7  14   5  474
## item6   17   9   2  472
## item7    9  13   4  474
## item8   20  15   3  462
## item9   17  18   5  460
## item10 126 124  44 4706
```

```r
print(fit[,1:4])
```

```
##           [,1]         [,2]      [,3]     [,4]
## [1,] 2.5791029 5.136378e+01 3.8689664 0.636025
## [2,] 0.4611649 4.092471e-11 0.2759655 0.888138
```

### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).

