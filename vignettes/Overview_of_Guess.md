### guess: Adjust Estimates of Learning for Guessing

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
## x00 x10 xd0 x01 x11 xd1 xd0 x1d xdd 
##   1   2   1   0   2   1   1   1   0
```

#### Estimates from the Latent Class Model


```r
# load(file.path(system.file(package = "guess"), "data", "alldat.rda"))
load("../data/alldat.rda")

# nitems
nitems <- length(alldat)/400

# Vectors of Names
t1 <- paste0("guess.t1", 1:nitems)
t2 <- paste0("guess.t2", 1:nitems)

transmatrix <- multi_transmat(alldat[,t1], alldat[,t2])

res <- guesstimate(transmatrix)
```

```
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
## Iter: 1 fn: 179.6872	 Pars:  0.05408 0.03328 0.91264 0.03845
## Iter: 2 fn: 179.6872	 Pars:  0.05408 0.03328 0.91264 0.03846
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1415.6458	 Pars:  0.04587 0.02159 0.93254 0.25882
## Iter: 2 fn: 1415.6458	 Pars:  0.04587 0.02159 0.93254 0.25882
## solnp--> Completed in 2 iterations
```

```r
round(res$param.lca[,1:4], 3)
```

```
##        [,1] [,2]  [,3]  [,4]
## lgg   0.077 0.05 0.040 0.036
## lgk   0.000 0.02 0.016 0.030
## lkk   0.923 0.93 0.944 0.934
## gamma 0.543 0.20 0.500 0.667
```

```r
round(res$est.learning[1:4], 3)
```

```
## [1] 0.000 0.020 0.016 0.030
```

#### Standard Errors


```r
guess_stnderr(alldat[,t1], alldat[,t2], 10)
```

```
## 
## Iter: 1 fn: 105.3595	 Pars:  0.046722577160 0.000000007789 0.953277414759 0.379314763477
## Iter: 2 fn: 105.3595	 Pars:  0.046721728967 0.000000004953 0.953278266080 0.379305162713
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 158.6721	 Pars:  0.05095 0.02316 0.92589 0.13636
## Iter: 2 fn: 158.6721	 Pars:  0.05095 0.02316 0.92589 0.13636
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 81.2853	 Pars:  0.03600 0.03000 0.93400 0.66667
## Iter: 2 fn: 81.2853	 Pars:  0.03600 0.03000 0.93400 0.66667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 87.5072	 Pars:  0.054001 0.005998 0.940001 0.666678
## Iter: 2 fn: 87.5072	 Pars:  0.05400 0.00600 0.94000 0.66667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 121.5056	 Pars:  0.04225 0.01950 0.93825 0.38463
## Iter: 2 fn: 121.5056	 Pars:  0.04225 0.01950 0.93825 0.38461
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 126.1123	 Pars:  0.03812 0.01694 0.94494 0.05555
## Iter: 2 fn: 126.1123	 Pars:  0.03812 0.01694 0.94494 0.05556
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 135.1800	 Pars:  0.04114 0.03772 0.92114 0.41662
## Iter: 2 fn: 135.1800	 Pars:  0.04114 0.03771 0.92114 0.41667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 189.3189	 Pars:  0.06827 0.02560 0.90613 0.06250
## Iter: 2 fn: 189.3189	 Pars:  0.06827 0.02560 0.90613 0.06250
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 155.0273	 Pars:  0.05120 0.03520 0.91360 0.37500
## Iter: 2 fn: 155.0273	 Pars:  0.05120 0.03520 0.91360 0.37500
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 182.5722	 Pars:  0.05608 0.03323 0.91069 0.03705
## Iter: 2 fn: 182.5722	 Pars:  0.05608 0.03323 0.91069 0.03704
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1390.1695	 Pars:  0.04517 0.01969 0.93514 0.23838
## Iter: 2 fn: 1390.1695	 Pars:  0.04517 0.01969 0.93514 0.23837
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 130.7062	 Pars:  0.0722518775 0.0000001279 0.9277479943 0.5294248039
## Iter: 2 fn: 130.7062	 Pars:  0.07224990984 0.00000001749 0.92775007267 0.52941139466
## Iter: 3 fn: 130.7062	 Pars:  0.072249918660 0.000000001945 0.927750079395 0.529411409792
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 154.0044	 Pars:  0.04050 0.03150 0.92800 0.11111
## Iter: 2 fn: 154.0044	 Pars:  0.04050 0.03150 0.92800 0.11111
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 73.0666	 Pars:  0.03600 0.01800 0.94600 0.66667
## Iter: 2 fn: 73.0666	 Pars:  0.03600 0.01800 0.94600 0.66666
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 89.0849	 Pars:  0.1620727635 0.0000009363 0.8379262999 0.8889460210
## Iter: 2 fn: 89.0849	 Pars:  0.1619965935 0.0000007011 0.8380027054 0.8888886383
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 118.2376	 Pars:  0.049999 0.006667 0.943334 0.399998
## Iter: 2 fn: 118.2376	 Pars:  0.050000 0.006667 0.943333 0.400000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 123.7286	 Pars:  0.02817 0.02600 0.94583 0.07692
## Iter: 2 fn: 123.7286	 Pars:  0.02817 0.02600 0.94583 0.07692
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 135.2690	 Pars:  0.03756 0.03178 0.93067 0.30768
## Iter: 2 fn: 135.2690	 Pars:  0.03756 0.03178 0.93067 0.30769
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 156.1165	 Pars:  0.05038 0.02190 0.92771 0.08695
## Iter: 2 fn: 156.1165	 Pars:  0.05038 0.02190 0.92771 0.08696
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 189.3867	 Pars:  0.08577 0.01588 0.89835 0.37038
## Iter: 2 fn: 189.3867	 Pars:  0.08576 0.01588 0.89835 0.37037
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 166.9102	 Pars:  0.04399995993 0.03599995479 0.92000008499 0.00000007538
## Iter: 2 fn: 166.9102	 Pars:  0.04399995816 0.03599995511 0.92000008673 0.00000003559
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1382.9524	 Pars:  0.04654 0.02003 0.93344 0.29091
## Iter: 2 fn: 1382.9524	 Pars:  0.04654 0.02003 0.93344 0.29091
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 121.0777	 Pars:  0.05760 0.02400 0.91840 0.58333
## Iter: 2 fn: 121.0777	 Pars:  0.05760 0.02400 0.91840 0.58333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 155.4906	 Pars:  0.05236 0.01964 0.92800 0.08333
## Iter: 2 fn: 155.4906	 Pars:  0.05236 0.01964 0.92800 0.08333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 79.4208	 Pars:  0.02420 0.00660 0.96920 0.09091
## Iter: 2 fn: 79.4208	 Pars:  0.02420 0.00660 0.96920 0.09091
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 90.4891	 Pars:  0.03267 0.02801 0.93932 0.57152
## Iter: 2 fn: 90.4891	 Pars:  0.03267 0.02800 0.93933 0.57145
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 126.4468	 Pars:  0.05625 0.01125 0.93250 0.46667
## Iter: 2 fn: 126.4468	 Pars:  0.05625 0.01125 0.93250 0.46667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 122.7553	 Pars:  0.03612 0.01700 0.94688 0.05880
## Iter: 2 fn: 122.7553	 Pars:  0.03613 0.01700 0.94687 0.05883
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 122.8513	 Pars:  0.03025 0.03025 0.93950 0.27272
## Iter: 2 fn: 122.8513	 Pars:  0.03025 0.03025 0.93950 0.27273
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 169.0715	 Pars:  0.05095 0.03011 0.91895 0.13636
## Iter: 2 fn: 169.0715	 Pars:  0.05095 0.03011 0.91895 0.13636
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 142.3149	 Pars:  0.02880 0.04080 0.93040 0.16667
## Iter: 2 fn: 142.3149	 Pars:  0.02880 0.04080 0.93040 0.16667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 170.2204	 Pars:  0.039999967 0.041999957 0.918000075 0.000000283
## Iter: 2 fn: 170.2204	 Pars:  0.0399999623 0.0419999567 0.9180000810 0.0000001543
## Iter: 3 fn: 170.2204	 Pars:  0.03999995724 0.04199995640 0.91800008636 0.00000002973
## Iter: 4 fn: 170.2204	 Pars:  0.039999956124 0.041999956264 0.918000087612 0.000000003726
## solnp--> Completed in 4 iterations
## 
## Iter: 1 fn: 1336.7458	 Pars:  0.03768 0.02396 0.93836 0.19867
## Iter: 2 fn: 1336.7458	 Pars:  0.03769 0.02396 0.93835 0.19868
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 150.0779	 Pars:  0.0770416027250 0.0000000005341 0.9229583964483 0.4418602409733
## Iter: 2 fn: 150.0779	 Pars:  0.0770416051094 0.0000000001822 0.9229583947081 0.4418602369692
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 125.5305	 Pars:  0.04654 0.01163 0.94182 0.31249
## Iter: 2 fn: 125.5305	 Pars:  0.04655 0.01164 0.94182 0.31250
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 91.6741	 Pars:  0.02700 0.01500 0.95800 0.33333
## Iter: 2 fn: 91.6741	 Pars:  0.02700 0.01500 0.95800 0.33333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 76.1239	 Pars:  0.07200 0.03601 0.89199 0.83335
## Iter: 2 fn: 76.1239	 Pars:  0.07200 0.03600 0.89200 0.83334
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 144.1488	 Pars:  0.04655 0.02618 0.92727 0.31250
## Iter: 2 fn: 144.1488	 Pars:  0.04655 0.02618 0.92727 0.31250
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 128.5057	 Pars:  0.057166618176 0.000000002602 0.942833378930 0.142857098211
## Iter: 2 fn: 128.5057	 Pars:  0.0571666209623 0.0000000008003 0.9428333782377 0.1428570621846
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 114.5824	 Pars:  0.01829 0.03429 0.94743 0.12500
## Iter: 2 fn: 114.5824	 Pars:  0.01829 0.03429 0.94743 0.12500
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 143.7175	 Pars:  0.03854 0.02720 0.93427 0.11765
## Iter: 2 fn: 143.7175	 Pars:  0.03853 0.02720 0.93427 0.11765
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 192.5972	 Pars:  0.06943 0.02828 0.90229 0.22223
## Iter: 2 fn: 192.5972	 Pars:  0.06943 0.02829 0.90229 0.22222
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 170.0458	 Pars:  0.05208 0.02917 0.91875 0.04000
## Iter: 2 fn: 170.0458	 Pars:  0.05208 0.02917 0.91875 0.04000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1381.9339	 Pars:  0.04857 0.01619 0.93524 0.27118
## Iter: 2 fn: 1381.9339	 Pars:  0.04857 0.01619 0.93524 0.27118
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 149.6656	 Pars:  0.067846 0.006462 0.925692 0.380952
## Iter: 2 fn: 149.6656	 Pars:  0.067846 0.006462 0.925692 0.380952
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 173.6807	 Pars:  0.06945 0.01666 0.91389 0.28001
## Iter: 2 fn: 173.6807	 Pars:  0.06944 0.01667 0.91389 0.28000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 87.4491	 Pars:  0.03199 0.01601 0.95199 0.50004
## Iter: 2 fn: 87.4491	 Pars:  0.03200 0.01600 0.95200 0.49999
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 89.0477	 Pars:  0.03600 0.04200 0.92200 0.66666
## Iter: 2 fn: 89.0477	 Pars:  0.03600 0.04200 0.92200 0.66667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 108.3869	 Pars:  0.03333 0.02333 0.94334 0.40000
## Iter: 2 fn: 108.3869	 Pars:  0.03333 0.02333 0.94333 0.40000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 98.9920	 Pars:  0.035636 0.005091 0.959273 0.214273
## Iter: 2 fn: 98.9920	 Pars:  0.035636 0.005091 0.959273 0.214286
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 118.7326	 Pars:  0.02025 0.03375 0.94600 0.11117
## Iter: 2 fn: 118.7326	 Pars:  0.02025 0.03375 0.94600 0.11111
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 183.2884	 Pars:  0.06145 0.02836 0.91018 0.15385
## Iter: 2 fn: 183.2884	 Pars:  0.06145 0.02836 0.91018 0.15385
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 210.4495	 Pars:  0.08182 0.03000 0.88818 0.26667
## Iter: 2 fn: 210.4495	 Pars:  0.08182 0.03000 0.88818 0.26667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 156.1165	 Pars:  0.05038 0.02190 0.92771 0.08695
## Iter: 2 fn: 156.1165	 Pars:  0.05038 0.02190 0.92771 0.08696
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1412.9777	 Pars:  0.04659 0.02059 0.93283 0.26163
## Iter: 2 fn: 1412.9777	 Pars:  0.04659 0.02059 0.93283 0.26163
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 105.6160	 Pars:  0.06250072528 0.00000004976 0.93749922467 0.60000285361
## Iter: 2 fn: 105.6160	 Pars:  0.062499894608 0.000000002683 0.937500102709 0.599999479155
## Iter: 3 fn: 105.6160	 Pars:  0.062499894566 0.000000001559 0.937500103875 0.599999477922
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 162.5757	 Pars:  0.04512 0.03325 0.92163 0.15791
## Iter: 2 fn: 162.5757	 Pars:  0.04512 0.03325 0.92163 0.15789
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 89.0477	 Pars:  0.01800 0.02700 0.95500 0.33333
## Iter: 2 fn: 89.0477	 Pars:  0.01800 0.02700 0.95500 0.33333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 89.2923	 Pars:  0.03199 0.08801 0.88000 0.75000
## Iter: 2 fn: 89.2923	 Pars:  0.03200 0.08800 0.88000 0.75000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 103.4635	 Pars:  0.05400 0.03000 0.91599 0.66669
## Iter: 2 fn: 103.4635	 Pars:  0.05400 0.03000 0.91600 0.66667
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 136.0270	 Pars:  0.04266 0.02133 0.93601 0.24998
## Iter: 2 fn: 136.0270	 Pars:  0.04267 0.02133 0.93600 0.25000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 121.2452	 Pars:  0.05397452 0.00002533 0.94600015 0.33317637
## Iter: 2 fn: 121.2452	 Pars:  0.0539994284 0.0000005199 0.9460000517 0.3333299539
## Iter: 3 fn: 121.2452	 Pars:  0.0539995393 0.0000004084 0.9460000522 0.3333306245
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 134.9492	 Pars:  0.04610 0.01467 0.93924 0.04545
## Iter: 2 fn: 134.9492	 Pars:  0.04610 0.01467 0.93924 0.04545
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 169.1859	 Pars:  0.04900 0.03267 0.91833 0.14286
## Iter: 2 fn: 169.1859	 Pars:  0.04900 0.03267 0.91833 0.14286
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 157.5158	 Pars:  0.04609 0.02724 0.92667 0.04546
## Iter: 2 fn: 157.5158	 Pars:  0.04610 0.02724 0.92667 0.04545
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1312.1547	 Pars:  0.04143 0.02004 0.93853 0.26144
## Iter: 2 fn: 1312.1547	 Pars:  0.04143 0.02004 0.93853 0.26144
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 137.7057	 Pars:  0.05254 0.01546 0.93200 0.35291
## Iter: 2 fn: 137.7057	 Pars:  0.05255 0.01545 0.93200 0.35294
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 132.8261	 Pars:  0.03853 0.02040 0.94107 0.11765
## Iter: 2 fn: 132.8261	 Pars:  0.03853 0.02040 0.94107 0.11765
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 109.2359	 Pars:  0.04840 0.01760 0.93400 0.54545
## Iter: 2 fn: 109.2359	 Pars:  0.04840 0.01760 0.93400 0.54545
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 45.5157	 Pars:  0.003999955 0.011999960 0.984000085 0.000001027
## Iter: 2 fn: 45.5157	 Pars:  0.00399995087 0.01199995234 0.98400009680 0.00000006701
## Iter: 3 fn: 45.5157	 Pars:  0.00399995073 0.01199995205 0.98400009722 0.00000003425
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 105.3140	 Pars:  0.043555 0.003111 0.953333 0.357141
## Iter: 2 fn: 105.3140	 Pars:  0.043556 0.003111 0.953333 0.357143
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 137.9923	 Pars:  0.059524 0.002381 0.938095 0.160000
## Iter: 2 fn: 137.9923	 Pars:  0.059524 0.002381 0.938095 0.160000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 137.9947	 Pars:  0.05689 0.01778 0.92533 0.43750
## Iter: 2 fn: 137.9947	 Pars:  0.05689 0.01778 0.92533 0.43750
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 151.8269	 Pars:  0.04900 0.02100 0.93000 0.14286
## Iter: 2 fn: 151.8269	 Pars:  0.04900 0.02100 0.93000 0.14286
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 181.8365	 Pars:  0.04446 0.05493 0.90061 0.23530
## Iter: 2 fn: 181.8365	 Pars:  0.04446 0.05492 0.90061 0.23530
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 186.3808	 Pars:  0.05208 0.03958 0.90833 0.04000
## Iter: 2 fn: 186.3808	 Pars:  0.05208 0.03958 0.90833 0.04000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1368.8204	 Pars:  0.04287 0.02079 0.93634 0.23032
## Iter: 2 fn: 1368.8204	 Pars:  0.04287 0.02079 0.93634 0.23030
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 138.4520	 Pars:  0.0691362976 0.0000001194 0.9308635827 0.4358971394
## Iter: 2 fn: 138.4520	 Pars:  0.06913626642 0.00000003935 0.93086369423 0.43589705238
## Iter: 3 fn: 138.4520	 Pars:  0.0691363056726 0.0000000001597 0.9308636941681 0.4358972032714
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 139.4971	 Pars:  0.04629 0.01800 0.93571 0.22222
## Iter: 2 fn: 139.4971	 Pars:  0.04629 0.01800 0.93571 0.22222
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 116.8411	 Pars:  0.03600 0.02100 0.94300 0.33332
## Iter: 2 fn: 116.8411	 Pars:  0.03600 0.02100 0.94300 0.33333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 77.7518	 Pars:  0.04900 0.01400 0.93700 0.71429
## Iter: 2 fn: 77.7518	 Pars:  0.04900 0.01400 0.93700 0.71428
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 128.4439	 Pars:  0.04800 0.03200 0.92000 0.50000
## Iter: 2 fn: 128.4439	 Pars:  0.04800 0.03200 0.92000 0.50000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 120.3604	 Pars:  0.04050 0.01125 0.94825 0.11111
## Iter: 2 fn: 120.3604	 Pars:  0.04050 0.01125 0.94825 0.11111
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 106.8588	 Pars:  0.01633 0.03267 0.95100 0.14279
## Iter: 2 fn: 106.8588	 Pars:  0.01633 0.03267 0.95100 0.14286
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 159.1280	 Pars:  0.04033 0.07333 0.88633 0.45455
## Iter: 2 fn: 159.1280	 Pars:  0.04033 0.07333 0.88633 0.45455
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 189.4939	 Pars:  0.06760 0.02860 0.90380 0.23078
## Iter: 2 fn: 189.4939	 Pars:  0.06760 0.02860 0.90380 0.23077
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 174.6289	 Pars:  0.06031 0.02369 0.91600 0.07143
## Iter: 2 fn: 174.6289	 Pars:  0.06031 0.02369 0.91600 0.07143
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1389.8039	 Pars:  0.04397 0.02323 0.93281 0.27672
## Iter: 2 fn: 1389.8038	 Pars:  0.04397 0.02323 0.93281 0.27673
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 105.0705	 Pars:  0.07199982872 0.00000006055 0.92800011044 0.66666604994
## Iter: 2 fn: 105.0705	 Pars:  0.07199984310 0.00000001874 0.92800013815 0.66666605337
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 129.9523	 Pars:  0.05290 0.00460 0.94250 0.13044
## Iter: 2 fn: 129.9523	 Pars:  0.05290 0.00460 0.94250 0.13044
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 94.3171	 Pars:  0.02450 0.02800 0.94750 0.42856
## Iter: 2 fn: 94.3171	 Pars:  0.02450 0.02800 0.94750 0.42857
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 67.6779	 Pars:  0.0845099419486 0.0000000006277 0.9154900571318 0.8461720339470
## Iter: 2 fn: 67.6779	 Pars:  0.08449785454 0.00000000032 0.91550214514 0.84615043582
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 142.0349	 Pars:  0.03756 0.03756 0.92489 0.30769
## Iter: 2 fn: 142.0349	 Pars:  0.03756 0.03756 0.92489 0.30769
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 131.2505	 Pars:  0.04813 0.01013 0.94173 0.21052
## Iter: 2 fn: 131.2505	 Pars:  0.04813 0.01013 0.94173 0.21053
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 112.3169	 Pars:  0.04000 0.02800 0.93200 0.49998
## Iter: 2 fn: 112.3169	 Pars:  0.04000 0.02800 0.93200 0.50000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 186.6110	 Pars:  0.06145 0.03073 0.90782 0.15385
## Iter: 2 fn: 186.6110	 Pars:  0.06145 0.03073 0.90782 0.15385
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 180.2304	 Pars:  0.0885963414 0.0000001728 0.9114034854 0.3114817103
## Iter: 2 fn: 180.2303	 Pars:  0.08859327043 0.00000004167 0.91140668789 0.31146506929
## Iter: 3 fn: 180.2303	 Pars:  0.088598103784 0.000000005886 0.911401890330 0.311490911864
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 182.4494	 Pars:  0.0439999677 0.0459999574 0.9100000746 0.0000002526
## Iter: 2 fn: 182.4494	 Pars:  0.0439999630 0.0459999571 0.9100000799 0.0000001461
## Iter: 3 fn: 182.4494	 Pars:  0.04399995802 0.04599995709 0.91000008489 0.00000003035
## Iter: 4 fn: 182.4494	 Pars:  0.043999956688 0.045999956823 0.910000086488 0.000000002915
## solnp--> Completed in 4 iterations
## 
## Iter: 1 fn: 1386.4757	 Pars:  0.04755 0.01835 0.93410 0.28070
## Iter: 2 fn: 1386.4757	 Pars:  0.04755 0.01835 0.93410 0.28070
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 128.4439	 Pars:  0.057142802903 0.000000007229 0.942857189576 0.299999831435
## Iter: 2 fn: 128.4439	 Pars:  0.057142806076 0.000000001737 0.942857192187 0.299999844731
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 160.6000	 Pars:  0.05188 0.02471 0.92341 0.19047
## Iter: 2 fn: 160.6000	 Pars:  0.05188 0.02471 0.92341 0.19048
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 100.0937	 Pars:  0.04050 0.02250 0.93700 0.55555
## Iter: 2 fn: 100.0937	 Pars:  0.04050 0.02250 0.93700 0.55555
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 121.2452	 Pars:  0.04800 0.02400 0.92800 0.49998
## Iter: 2 fn: 121.2452	 Pars:  0.04800 0.02400 0.92800 0.50000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 118.5063	 Pars:  0.06424384 0.00004192 0.93571425 0.53318186
## Iter: 2 fn: 118.5062	 Pars:  0.0642847581 0.0000008747 0.9357143672 0.5333297539
## Iter: 3 fn: 118.5062	 Pars:  0.0642849366 0.0000006959 0.9357143675 0.5333304101
## solnp--> Completed in 3 iterations
## 
## Iter: 1 fn: 114.0325	 Pars:  0.03462 0.01385 0.95154 0.13334
## Iter: 2 fn: 114.0325	 Pars:  0.03462 0.01385 0.95154 0.13333
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 156.3493	 Pars:  0.06453 0.01173 0.92373 0.31818
## Iter: 2 fn: 156.3493	 Pars:  0.06453 0.01173 0.92373 0.31818
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 142.8815	 Pars:  0.04444 0.02000 0.93556 0.10000
## Iter: 2 fn: 142.8815	 Pars:  0.04444 0.02000 0.93556 0.10000
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 220.6438	 Pars:  0.08736 0.03382 0.87882 0.29033
## Iter: 2 fn: 220.6438	 Pars:  0.08736 0.03382 0.87882 0.29032
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 167.0704	 Pars:  0.05009 0.02922 0.92069 0.04168
## Iter: 2 fn: 167.0704	 Pars:  0.05009 0.02922 0.92070 0.04167
## solnp--> Completed in 2 iterations
## 
## Iter: 1 fn: 1461.9631	 Pars:  0.05249 0.01704 0.93047 0.27225
## Iter: 2 fn: 1461.9631	 Pars:  0.05249 0.01704 0.93047 0.27225
## solnp--> Completed in 2 iterations
```

```
## Error in `[<-`(`*tmp*`, 2, , value = structure(c(NA_real_, NA_real_, NA_real_, : subscript out of bounds
```

#### Fit


```r
fit			<- fit_nodk(res[4,], res[1:3,], transmat) 
```

```
## Error in res[4, ]: incorrect number of dimensions
```

```r
print(fit[,1:4])
```

```
## Error in print(fit[, 1:4]): object 'fit' not found
```
