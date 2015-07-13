### guess: Estimates of Learning Adjusted for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)

Over informative processes, naive estimator of learning -- difference between post and pre process scores-- underestimates actual learning. A heuristic account for why the naive estimator is negatively biased is as follows: people know as much or more after exposed to an informative process than before it. The less people know, the larger the number of items they don't know. And greater the opportunity to guess. Guessing - even when random - only increases the proportion correct. Thus bias due to guessing for naive measures of knowledge is always positive. On average, thus, there is more positive bias in the pre-process scores than post-process. And subtracting pre-process scores from post-process thus provides an attenuated estimate of actual learning. For a more complete treatment of the issue, read [this paper](http://gsood.com/research/papers/guess.pdf) by Gaurav Sood and Ken Cor.

We provide a few different ways to adjust estimates of learning for guessing. For now, we limit our attention to cases where the same battery of knowledge questions has been asked in both the pre- and the post-process wave. And to cases where closed-ended questions have been asked. (Guessing is not a serious issue on open-ended items. See more evidence for that in [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Robert Luskin and John Bullock.)  More generally, the package implements the methods to adjust learning for guessing discussed in [this paper](http://gsood.com/research/papers/guess.pdf).

**Dealing with Missing Data**  
If you assume that the data are missing completely at random, you can simply ignore them. Generally, however, respondents tend to skip items they don't know. So missing responses on knowledge questions typically indicate ignorance. (Of course, it is important to investigate other potential reasons behind missing data. And we encourage researchers to take all precautions.) In our treatment, however, for simplicity sake, we treat missing as indicators of ignorance. 

**Dealing with Don't Know**  
We now know a little bit about Don't Know. One generally strategy is to treat Don't Know responses as ignorance. But research suggests that on average there is approximately 3\% hidden knowledge behind Don't Know responses. See [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Robert Luskin and John Bullock. Thus one can also choose to replace Don't Know responses with .03.

**Standard Correction for Guessing**  


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

**Two important notes regarding how the data should be structured:**

1. For current purposes, we assume missing responses to indicate ignorance. Thus code missing responses as 0.
2. If the items offer an option to mark `Don't know`, code all `Don't Know` responses as NA.

**Note About Data**

In the sample data below, NAs reflect `Don't Know' responses. To calculate unadjusted effects, we treat `Don't Know` responses as indicators of ignorance. See [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Luskin and Bullock. They estimate hidden knowledge behind `Don't Know' responses on closed-ended items at about 3%. Thus one can also choose to replace Don't Know responses with .03.


```r
library(guess)
pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)) 
pst_test <-  pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
lucky <- rep(.25, 2)

# Unadjusted Effect
colMeans(nona(pst_test) - nona(pre_test))
```

```
## item1 item2 
##   0.4   0.2
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

#### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).

