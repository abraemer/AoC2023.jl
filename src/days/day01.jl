module Day01Module
using ..AoC2023
export Day01

const TEST_INPUT_PART1 = raw"1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"
const TEST_RESULT_PART1 = 142

const TEST_INPUT_PART2 = raw"two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

const TEST_RESULT_PART2 = 281

struct Day01{T} <: AoC2023.AoCDay{1}
    data::T
    function Day01(input = inputfile(1))
        data = parseInput(eachline(input))
        return new{typeof(data)}(data)
    end
end

AoC2023._aocrun_part1(data::Day01) = part1(data.data)
AoC2023._aocrun_part2(data::Day01) = part2(data.data)
AoC2023._aoctest_part1(::Type{Day01}) = TEST_RESULT_PART1 == AoC2023._aocrun_part1(Day01(IOBuffer(TEST_INPUT_PART1)))
AoC2023._aoctest_part2(::Type{Day01}) = TEST_RESULT_PART2 == AoC2023._aocrun_part2(Day01(IOBuffer(TEST_INPUT_PART2)))


function parseLine(line)
    # this line is not type-stable!
    # when line == "9", then the result is not a Vector{...} but String because the vcat does not apply :-(
    # return mapreduce(m->m[1], vcat, eachmatch(r"(one|two|three|four|five|six|seven|eight|nine|[0-9])",line; overlap=true))

    return [string(m[1]) for m in eachmatch(r"(one|two|three|four|five|six|seven|eight|nine|[0-9])",line; overlap=true)]
end

function parseInput(lines)
    return parseLine.(lines)
end

function part1(data)
    s = 0
    for line in data
        relevant = filter(str -> length(str)==1, line)
        s += parse(Int, relevant[begin])*10
        s += parse(Int, relevant[end])
    end
    return s
end

const VALUES = Dict("one"=>1, "two"=>2, "three"=>3, "four"=>4, "five"=>5,
    "six"=>6, "seven"=>7, "eight"=>8, "nine"=>9, [string(i)=>i for i in 0:9]...)

function part2(data)
    s = 0
    for line in data
        s += VALUES[line[begin]]*10
        s += VALUES[line[end]]
    end
    return s
end

end #module

@reexport using .Day01Module
