module CpuDispatcher

using CpuId, Hwloc

# cat /proc/info
proccpuinfo() = read(pipeline(`cat /proc/cpuinfo`, `grep flags`, `uniq`, `cut -c 10-`, `tr ' ' '\n'`, `tr a-z A-Z`, `sort`),String) |> chomp |> x -> split(x, '\n')

fs_proc = proccpuinfo()

# jl_dump_host_cpu
function jldumphost()
	read(`julia -e "ccall(:jl_dump_host_cpu,Cvoid,())"`, String) # FIX PLZ IZ BROKEN
	jldump = "sse3, pclmul, ssse3, fma, cx16, sse4.1, sse4.2, movbe, popcnt, aes, xsave, avx, f16c, rdrnd, fsgsbase, bmi, avx2, bmi2, sahf, lzcnt, xsaveopt" |> x -> split(x, ", ") |> sort .|> uppercase;
end

fs_jldump = jldumphost()

# CpuId
fs_cpuid = String.(cpuidfeatures());

export fs_cpuid, fs_jldump, fs_proc

end # module
