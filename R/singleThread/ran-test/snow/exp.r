#library(Rmpi)
#library(parallel)
library(snow)

# start up cluster
#ncore <- mpi.universe.size()-1
#cl <- makeCluster(type="MPI")
cl <- getMPIcluster()
ncore <- length(cl)
cat("ncore:",ncore,"\n")

# if you want to evaluate a funciton f, it needs to be defined on each slave
f.long<-function(n) {
         xx<-rnorm(n)            
         log(abs(xx))+xx^2
}

#system.time(sapply(rep(5E6,ncore),f.long))
system.time(parSapply(cl,rep(5E6,ncore),f.long))

stopCluster(cl)



