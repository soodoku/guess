### guess: Adjust Estimates of Learning to Account for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)

Implements the method to adjust learning for guessing in [this paper](http://gsood.com/research/papers/guess.pdf).

### Installation

To get the current development version from github:


```r
# install.packages("devtools")
library(devtools)
devtools::install_github("soodoku/guess")
devtools::install_github("soodoku/goji")
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
colMeans(goji::nona(pst_test) - goji::nona(pre_test))
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

