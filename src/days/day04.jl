module Day04Module
using ..AoC2023
export Day04

TEST_INPUT = raw"Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
TEST_RESULT_PART1 = 13
TEST_RESULT_PART2 = 30

struct Day04{T} <: AoC2023.AoCDay{04}
    data::T
    function Day04(input = inputfile(04))
        data = parseInput(eachline(input))
        return new{typeof(data)}(data)
    end
end

AoC2023.aocrun(data::Day04) = both_parts(data.data)
AoC2023.aoctest(::Type{Day04}) = AoC2023.aocrun(Day04(IOBuffer(TEST_INPUT))) .== (TEST_RESULT_PART1, TEST_RESULT_PART2)

function parseLine(line)
    start = findfirst(':', line)
    winningnumbers_raw, numbers_raw = split(line[start+1:end], '|')
    winningnumbers = parse.(Int, filter(s->length(s)>0, split(winningnumbers_raw, ' ')))
    numbers = parse.(Int, filter(s->length(s)>0, split(numbers_raw, ' ')))
    return length(intersect(winningnumbers, numbers))

end

function parseInput(lines)
    return parseLine.(lines)
end

_score_part1(nmatches) = nmatches == 0 ? 0 : 2^(nmatches-1)

function both_parts(data)
    res_part1 = sum(_score_part1, data)
    counter = ones(Int, length(data))
    for (i,n) in enumerate(data)
        for j in i+1:i+n
            counter[j] += counter[i]
        end
    end
    return res_part1, sum(counter)
end

function part2(data)
    return missing
end

end #module

@reexport using .Day04Module
