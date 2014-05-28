function bind_pe_procs()
  # filestream = open(ENV["PBS_NODEFILE"])
  home = ENV["HOME"]
  node_file_name = ENV["PE_HOSTFILE"]

  # parse the file - extract addresses and number of procs
  # on each
  # filestream = open("pe_file_ex.txt")
  filestream = open(node_file_name)
  seekstart(filestream)
  linearray = readlines(filestream)
  procs = map(linearray) do line
      line_parts = split(line," ")
      proc = {"name" => line_parts[1], "n" => line_parts[2]}
  end

  print(procs)

  # repeat for nodes with multiple procs
  # remove master from the node list
  master_node = ENV["HOSTNAME"]
  remove_master = 1
  machines = ASCIIString[]
  for pp in procs
    println(pp["name"])
    for i=1:int(pp["n"])
      if ( !contains(pp["name"],master_node)) | (remove_master==0)
        push!(machines,pp["name"])
      else
        remove_master=0
      end
    end
  end

  print(machines)


  println("adding machines to current system")
  addprocs(machines, dir= "/data/uctpfos/git/julia/")
  println("done")
end

println("Started julia")

bind_pe_procs()

println(" trying parallel for loop with $(nprocs()) processes")
@time map( n -> sum(svd(rand(n,n))[1]) , [800 for i in 1:20]);
@time pmap( n -> sum(svd(rand(n,n))[1]) , [800 for i in 1:20]);

println(" quitting ")

quit()