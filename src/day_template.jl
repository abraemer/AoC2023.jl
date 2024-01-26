module DayNNNModule
using ..AoC2023
export DayNNN

TEST_INPUT_PART1 = raw""
TEST_RESULT_PART1 = missing

TEST_INPUT_PART2 = raw""
TEST_RESULT_PART2 = missing

struct DayNNN{T} <: AoC2023.AoCDay{NNN}
    data::T
    function DayNNN(input = inputfile(NNN))
        data = parseInput(eachline(input))
        return new{typeof(data)}(data)
    end
end

AoC2023._aocrun_part1(data::DayNNN) = part1(data.data)
AoC2023._aocrun_part2(data::DayNNN) = part2(data.data)
AoC2023._aoctest_part1(::Type{DayNNN}) = TEST_RESULT_PART1 == AoC2023._aocrun_part1(DayNNN(IOBuffer(TEST_INPUT_PART1)))
AoC2023._aoctest_part2(::Type{DayNNN}) = TEST_RESULT_PART2 == AoC2023._aocrun_part2(DayNNN(IOBuffer(TEST_INPUT_PART2)))

function parseLine(line)
    line
end

function parseInput(lines)
    return parseLine.(lines)
end

function part1(data)
    return missing
end

function part2(data)
    return missing
end

end #module

@reexport using .DayNNNModule
