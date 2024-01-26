module AoC2023

using BenchmarkTools
using Markdown
using Printf
using Reexport
using Statistics
using InteractiveUtils

export benchmark_all, run_all, aocrun, aoctest, inputfile

include("dijkstra.jl")

abstract type AoCDay{D} end

daynumber(::Type{<:AoCDay{D}}) where D = D
daynumber(::AoCDay{D}) where D = D

function _aocrun_part1 end
function _aocrun_part2 end

function aocrun(day)
    return _aocrun_part1(day), _aocrun_part2(day)
end
aocrun(T::Type{<:AoCDay}) = aocrun(T())

function _aoctest_part1 end
function _aoctest_part2 end

function aoctest(day)
    _aoctest_part1(day), _aoctest_part2(day)
end

function inputfile(day::Int)
    return joinpath("inputs", @sprintf("input%02d.txt", day))
end

name(day) = @sprintf("day%02d", day)

include.(readdir(joinpath(@__DIR__, "days"); join=true))

DAYS_DONE = sort(subtypes(AoCDay); by=daynumber)

@show DAYS_DONE

# for day in DAYS_DONE
#     dname = name(day)
#     include("$dname.jl")
#     @eval using .$(Symbol(uppercasefirst(dname)))
#     @eval export $(Symbol(uppercasefirst(dname))), $(Symbol(dname))
# end

function benchmark_all(days = DAYS_DONE; showall=false)
    totaltime = 0.0
    for day in days
        println("Benchmarking $day")
        b = @benchmark aocrun($day)
        showall && display(b)
        totaltime += median(b.times)
    end
    println("Total time: ", round(totaltime*1e-6; sigdigits=4), "ms")
    return totaltime*1e-6
end

function run_all(days = DAYS_DONE)
    table = Markdown.Table([["Day", "Time", "Part 1", "Part 2"]], [:c, :c, :c, :c])
    for day in days
        res = @timed aocrun(day)
        row = [ @sprintf("Day %02d", daynumber(day)),
                _format_time(res.time),
                string(res.value[1]),
                string(res.value[2])]
        push!(table.rows, row)
    end
    return Markdown.MD(table)
end

function _format_time(time; sigdigits=4)
    magnitudes = [1e-6, 1e-3, 1.0, 1e3]
    prefixes = ["ns", "µs", "ms", "s"]
    for (mag, pref) in zip(magnitudes, prefixes)
        if time < mag
            return "$(round(time/mag/1e-3; sigdigits))$pref"
        end
    end
    return "$(div(time,60))min $(round(mod(time, 60); digits=1))s"
end

end # module
