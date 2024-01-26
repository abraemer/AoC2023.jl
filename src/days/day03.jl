module Day03Module
using ..AoC2023
export Day03

TEST_INPUT_PART1 = raw"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
TEST_RESULT_PART1 = 4361

TEST_INPUT_PART2 = raw""
TEST_RESULT_PART2 = missing

struct Day03{T} <: AoC2023.AoCDay{03}
    data::T
    function Day03(input = inputfile(03))
        data = parseInput(eachline(input))
        return new{typeof(data)}(data)
    end
end

AoC2023._aocrun_part1(data::Day03) = part1(data.data)
AoC2023._aocrun_part2(data::Day03) = part2(data.data)
AoC2023._aoctest_part1(::Type{Day03}) = TEST_RESULT_PART1 == AoC2023._aocrun_part1(Day03(IOBuffer(TEST_INPUT_PART1)))
AoC2023._aoctest_part2(::Type{Day03}) = TEST_RESULT_PART2 == AoC2023._aocrun_part2(Day03(IOBuffer(TEST_INPUT_PART2)))

function parseInput(lines)
    return collect(lines)
end

function part1(data)
    width = length(data[1])
    dummy = String(fill('.', width))
    res = 0
    for (prev,line,next) in zip([dummy; data], data, [data[2:end]; dummy])
        for m in eachmatch(r"(\d+)", line)
            l = length(m[1])
            # check before and after for symbol
            # cannot be another number in this case
            if (m.offset > 1 && line[m.offset-1] != '.') || (m.offset+l <= width && line[m.offset+l] != '.')
                res += parse(Int, m[1])
                continue
            end

            left = max(1, m.offset-1)
            right = min(width, m.offset+l)
            # check next line and previous line
            if !isnothing(match(r"([^\.\d]+)", prev[left:right])) || !isnothing(match(r"([^\.\d]+)", next[left:right]))
                res += parse(Int, m[1])
                continue
            end
        end
    end
    return res
end

function part2(data)
    return missing
end

end #module

@reexport using .Day03Module
