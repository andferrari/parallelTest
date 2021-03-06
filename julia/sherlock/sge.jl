
println("Started julia on sherlock")

include("sherlock_launch.jl")

bind_sherlock_procs()

# here a function that runs your estimation:
# using MOpt, mig

# require some code on all nodes
require("../incl.jl")

println("make everybody say hello")

@everywhere sayhello()

println("make everybody do some math")

pmap( i->domath(i), [100 for j in 1:length(workers())] )

println("make everybody pass a memory test")

pmap( i->doBIGmath(), 1:length(workers()) )

println("trying parallel for loop with $(nprocs()) processes")
println("numworkers: $(length(workers()))")
println("workers: $(workers())")
@time map( n -> sum(svd(rand(n,n))[1]) , [800 for i in 1:32]);
@time pmap( n -> sum(svd(rand(n,n))[1]) , [800 for i in 1:32]);

println(" quitting ")

quit()