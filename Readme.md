### guess: Estimates of Learning Adjusted for Guessing

[![GPL-3.0](http://img.shields.io/:license-gpl-blue.svg)](http://opensource.org/licenses/GPL-3.0)

Implements the method to adjust learning for guessing in [this paper](http://gsood.com/research/papers/guess.pdf).

### Installation

To get the current development version from github:

```{r install}
# install.packages("devtools")
devtools::install_github("soodoku/guess")
```

### Usage

**Standard Correction for Guessing**

To adjust estimates of learning for standard correction of guessing, use `stndcor`.

```{r stndcor}
pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)) 
pst_test <-  pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
lucky <- rep(.25, 2); 
stndcor(pre_test, pst_test, lucky)
```



#### License
Scripts are released under [GNU V3](http://www.gnu.org/licenses/gpl-3.0.en.html).

