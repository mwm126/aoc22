module day_3

example = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

function main()
    problem_input = read(stdin)

    @assert 157 == compartments_score(example)
    answer = compartments_score(problem_input)
    println("Part 1 answer: ", answer)

    answer = trios_score(problem_input)
    println("Part 2 answer: ", answer)
end

function compartments_score(input)
    return sum(Iterators.map(get_score, eachline(IOBuffer(input))))
end

function trios_score(input)
    score = 0
    io = eachline(IOBuffer(input))
    while (!isempty(io))
        one, two, three = Iterators.take(io,3)
        score += get_trip_score(one, two, three)
    end
    score
end

function get_score(line)
    half = length(line) ÷ 2
    # println("hallf = ", half)
    lefty = line[begin:half]
    right = line[half+1:end]
    @assert length(line) == length(lefty) + length(right)
    extra = find_dup(lefty, right)
    find_score(extra)
end

function find_dup(left, right)
    for char in left
        if char in right
            return char
        end
    end
end

function find_score(char)
    if 'a' <= char <= 'z'
        return 1 + char - 'a'
    end
    if 'A' <= char <= 'Z'
        return 27 + char - 'A'
    end
end

function get_trip_score(one, two, three)
    for char in one
        if char in two && char in three
            return find_score(char)
        end
    end
end

@assert get_score("vJrwpWtwJgWrhcsFMMfFFhFp") == 16
@assert get_score("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL") == 38
@assert get_score("PmmdzqPrVvPwwTWBwg") == 42
@assert get_score("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn") == 22
@assert get_score("ttgJtRGJQctTZtZT") == 20
@assert get_score("CrZsJsPPZsGzwwsLwLmpwMDw") == 19

@assert 18 == trios_score("""
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg""")

@assert 52 == trios_score("""
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw""")


main()

end;
