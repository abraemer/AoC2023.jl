module Day02Module
using ..AoC2023
export Day02

TEST_INPUT = raw"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
TEST_RESULT_PART1 = 8
TEST_RESULT_PART2 = 2286

struct Day02{T} <: AoC2023.AoCDay{2}
    data::T
    function Day02(input = inputfile(02))
        data = parseInput(eachline(input))
        return new{typeof(data)}(data)
    end
end

AoC2023.aocrun(data::Day02) = both_parts(data.data)
AoC2023.aoctest(data::Type{Day02}) = aocrun(Day02(IOBuffer(TEST_INPUT))) .== (TEST_RESULT_PART1, TEST_RESULT_PART2)

### ASSUMPTION: The only possible colors are actually red, green, blue

function _color_index(name)
    name == "red" && return 1
    name == "green" && return 2
    name == "blue" && return 3
    @error "Unknown color: $name"
end

function parse_subset(subset_raw)
    colorvect = zeros(Int,3)
    for (count,color) in eachmatch(r"(\d+) (\w+)", subset_raw)
        colorvect[_color_index(color)] = parse(Int, count)
    end
    return colorvect
end

function parseLine(line)
    start = findfirst(':', line)
    id = parse(Int, line[findfirst(' ', line)+1:start-1])
    subsets_raw = split(line[start+1:end], ';')

    return (; id, sets=stack(parse_subset, subsets_raw))
end

function parseInput(lines)
    return parseLine.(lines)
end

function both_parts(data)
    # only 12 red cubes, 13 green cubes, and 14 blue cubes
    reference = zeros(Int,3)
    reference[_color_index("red")] = 12
    reference[_color_index("green")] = 13
    reference[_color_index("blue")] = 14
    res1 = 0
    res2 = 0
    for game in data
        minset = maximum(game.sets; dims=2)
        if all(minset .<= reference)
            res1 += game.id
        end
        res2 += reduce(*, minset)
    end
    return res1,res2
end

end #module

@reexport using .Day02Module
