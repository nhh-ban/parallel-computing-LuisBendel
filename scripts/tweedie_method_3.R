# Assignment 1:  
library(tweedie) 
library(ggplot2)
library(doParallel)

# initiating parallel computing
maxCores <- 16
Cores <- min(parallel::detectCores(), maxCores)

cl <- makeCluster(Cores)
registerDoParallel(cl)

# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){
    
    # when defining this function outside of the MTweedieTests function, it did
    # not get recognized (function not found)
    # defining it inside the MTweedieTests function works
    simTweedieTest <-  
      function(N){ 
        t.test( 
          rtweedie(N, mu=10000, phi=100, power=1.9), 
          mu=10000 
        )$p.value 
      } 
    
    # spliting the number of iterations depending across each core
    # depending on the M-parameter and the number of cores
    # the splits-vector contains the number of iterations for each core
    if (M %/% Cores != ceiling(M / Cores)) {
      splits <- c(rep(M %/% Cores, Cores/2), rep(ceiling(M / Cores), Cores/2))
    } else if (M %/% Cores == ceiling(M / Cores)) {
      splits <- c(rep(M / Cores, Cores))
    }
    
    # parallel computing for the splits-vector
    foreach(
      i = 1:length(splits),
      .combine = "mean",
      .packages = c("tweedie")
    ) %dopar%
      sum(replicate(splits[i],simTweedieTest(N)) < sig)/splits[i]
    
    
  } 

# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 


for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

stopCluster(cl)