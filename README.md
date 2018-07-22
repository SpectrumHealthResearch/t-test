# Calculate two sample Student's t-test with summary statistics

These are simple scripts to facilitate the computation of the two independent
samples Student's *t* test when only the summary statistics of the data are
available, but not the raw data. To compute the *t* statistic, you will need
the following:

- Group means
- Group standard deviations
- Group sizes

## Instructions

### R

#### Installation

The function is housed in an R package. To use the function, first you must 
install the package. To do so, execute the following in your R console:

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("SpectrumHealthResearch/t-test/R")
```

#### Example

```r
# Load the package into your session
library(stt)

# Using chickwts data from datasets
summary_chicks <- tapply(
  chickwts$weight,
  chickwts$feed,
  function(x) c(mean = mean(x), sd = sd(x), n = length(x))
)

# We now have a named list of vectors containing summary stats
summary_chicks

# Execute the t test using summary stats
with(summary_chicks,
     summary_t_test(
       linseed["mean"],
       soybean["mean"],
       linseed["sd"],
       soybean["sd"],
       linseed["n"],
       soybean["n"],
       alternative = "less",
       method = "sat"
       )
     )

## 	Two Sample t-test (satterthwaite)
##
## data:  summary statistics
## t = -1.3246, df = 23.63, p-value = 0.09899
## alternative hypothesis: true difference in means is less than 0
## 95 percent confidence interval:
##     -Inf 8.09536
## sample estimates:
## difference in means
##           -27.67857

# Compare with stats::t.test using raw data
t.test(
  weight ~ feed,
  chickwts,
  feed %in% c("linseed", "soybean"),
  alternative = "less"
)

## 	Welch Two Sample t-test
##
## data:  weight by feed
## t = -1.3246, df = 23.63, p-value = 0.09899
## alternative hypothesis: true difference in means is less than 0
## 95 percent confidence interval:
##     -Inf 8.09536
## sample estimates:
## mean in group linseed mean in group soybean
##              218.7500              246.4286
```

### SAS

There are many ways to make use of this program. One suggested route:

1. Clone this repository or download the SAS code in the SAS folder.
1. Run the macro definition in the source editor or using `%include`.
1. Run the macro call.
