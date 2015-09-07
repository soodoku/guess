### guess: Adjust Estimates of Learning for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)
[![Build Status](https://travis-ci.org/soodoku/abbyyR.svg?branch=master)](https://travis-ci.org/soodoku/guess)

Over informative processes, naive estimator of learning---difference between post and pre process scores---underestimates actual learning. A heuristic account for why the naive estimator is negatively biased is as follows: people know as much or more after exposed to an informative process than before it. And the less people know, the larger the number of items they don't know. And greater the opportunity to guess. 

Guessing, even when random, only increases the proportion correct. Thus, bias due to guessing for naive measures of knowledge is always positive. On average, thus, there is more positive bias in the pre-process scores than post-process scores. And naturally, subtracting pre-process scores from post-process provides an attenuated estimate of actual learning. For a more complete treatment of the issue, read [this paper](http://gsood.com/research/papers/guess.pdf) by Gaurav Sood and Ken Cor.

We provide a few different ways to adjust estimates of learning for guessing. For now, we limit our attention to cases where the same battery of knowledge questions has been asked in both the pre- and the post-process wave. And to cases where closed-ended questions have been asked. (Guessing is not a serious issue on open-ended items. See more evidence for that in [DK Means DK](http://bullock.research.yale.edu/papers/DKs/DK.pdf) by Robert Luskin and John Bullock.)  More generally, the package implements the methods to adjust learning for guessing discussed in [this paper](http://gsood.com/research/papers/guess.pdf).

### Installation

To get the current development version from github:


```r
# install.packages("devtools")
library(devtools)
devtools::install_github("soodoku/guess")
```

### Usage

To learn about how to use the package, see [this vignette](vignettes/Overview of Guess.md).

### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).

