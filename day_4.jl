function main()
    problem_input = read(stdin)

    answer = total_score(problem_input, complete_overlap)
    println("Part 1 answer: ", answer)

    answer = total_score(problem_input, any_overlap)
    println("Part 2 answer: ", answer)
end

function total_score(input, funk)
    return sum(Iterators.map(funk, eachline(IOBuffer(input))))
end

function parse(line)
    one, two = split(line, ",")

    low_s, high_s = split(one, "-")
    low = tryparse(Int64, low_s)
    high = tryparse(Int64, high_s)

    low2_s, high2_s = split(two, "-")
    low2 = tryparse(Int64, low2_s)
    high2 = tryparse(Int64, high2_s)

    return low, high, low2, high2
end

function complete_overlap(line)
    (low, high, low2, high2) = parse(line)
    if ((high2 - high) * (low2 - low) <= 0)
        1
    else
        0
    end
end

function any_overlap(line)
    (low, high, low2, high2) = parse(line)
    if (low2 <= low && low <= high2)
        1
    elseif (low2 <= high && high <= high2)
        1
    elseif (low <= low2 && low2 <= high)
        1
    elseif (low <= high2 && high2 <= high)
        1
    else
        0
    end
end

@assert complete_overlap("2-4,6-8") == 0
@assert complete_overlap("2-3,4-5") == 0
@assert complete_overlap("5-7,7-9") == 0
@assert complete_overlap("2-8,3-7") == 1
@assert complete_overlap("6-6,4-6") == 1
@assert complete_overlap("2-6,4-8") == 0

@assert any_overlap("2-4,6-8") == 0
@assert any_overlap("2-3,4-5") == 0
@assert any_overlap("5-7,7-9") == 1
@assert any_overlap("2-8,3-7") == 1
@assert any_overlap("6-6,4-6") == 1
@assert any_overlap("2-6,4-8") == 1

main()
