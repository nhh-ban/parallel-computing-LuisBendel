
library(tictoc)

# run the three scripts for the methods
tic()
source("scripts/tweedie_method_1.R")
toc(log = TRUE)

tic()
source("scripts/tweedie_method_2.R")
toc(log = TRUE)

tic()
source("scripts/tweedie_method_3.R")
toc(log = TRUE)

# EXPLANATION:
# the third method is the fastest because the workload is spread more evenly 
# across the cores. In The first method, one core has to calculate a tweedie sample of
# 10.000 observations 1000 times, and another core has to just calculate a
# tweedie sample of 10 observations 1000 times, so one core does more work than the other
# and thus, the overall time does not change significantly.
# In the third method, however, every core calculates for all sample sizes but instead
# of 1000 times for each sample size, just 62 or 63 times. Thus, the workload
# is spreach more evenly and the method is more time-saving.