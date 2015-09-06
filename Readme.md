### guess: Estimates of Learning Adjusted for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)

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
```

```
## 
## Attaching package: 'guess'
## 
## The following objects are masked _by_ '.GlobalEnv':
## 
##     multi_transmat, transmat
```

```r
pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)) 
pst_test <-  pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
lucky <- rep(.25, 2)

# Unadjusted Effect
# Treating Don't Know as ignorance
colMeans(nona(pst_test) - nona(pre_test))
```

```
## Error in nona(pst_test) - nona(pre_test): non-numeric argument to binary operator
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
##           [,1]
## [1,] 0.5333333
## [2,] 0.2666667
```

#### Transition Matrix


```r
# Without Don't Know
pre_test_var <- c(1,0,0,1,0,1,0) 
pst_test_var <- c(1,0,1,1,0,1,1)
transmat(pre_test_var, pst_test_var)
```

```
##   0 1
## 0 2 0
## 1 2 3
```

```r
# With Don't Know
pre_test_var <- c(1,0,NA,1,"d","d",0,1,0)
pst_test_var <- c(1,0,1,"d",1,0,1,1,"d")
transmat(pre_test_var, pst_test_var)
```

```
##   0 1 d
## 0 1 0 1
## 1 2 2 1
## d 1 1 0
```

#### Estimates from the Latent Class Model


```r
res <- guesstimate(pre_test, pst_test, lucky)
```

```
## 
##  Item 1 
##   0 1
## 0 1 0
## 1 2 2
## 
##  Item 2 
##   0 1
## 0 2 0
## 1 1 2
## 
##  Aggregate 
##       x00 x10 x01 x11
## item1   1   2   0   2
## item2   3   3   0   4
## 
## 
## Iter: 1 fn: 5.2746	 Pars:  0.199999982217 0.400000011406 0.400000006085 0.000000009794
## Iter: 2 fn: 5.2746	 Pars:  0.199999981507 0.400000011320 0.400000007173 0.000000005512
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 10.8890	 Pars:  0.3000000156 0.2999999950 0.3999999891 0.0000000674
## Iter: 2 fn: 10.8890	 Pars:  0.30000000864 0.29999999496 0.39999999640 0.00000004436
## solnp--> Completed in 2 iterations
```

```r
round(res, 2)
```

```
##       [,1] [,2]
## lgg    0.2  0.3
## lgk    0.4  0.3
## lkk    0.4  0.4
## gamma  0.0  0.0
```

#### Standard Errors



#### Fit



### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).

