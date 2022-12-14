function main()
    @assert 13 == ordered_sum(example)

    problem_input = read(stdin)

    answer = ordered_sum(problem_input)
    println("Part 1 answer: ", answer)
end

function ordered_sum(input)
    pairs = parse_pairs(input)
    pairsum = 0
    for (ii, pair) in enumerate(pairs)
        left, right = pair
        if ordered(left, right) != 1
            pairsum += ii
        end
    end
    pairsum
end

function ordered(left, right)
    # println("comparing ", left, ":", typeof(left), " and ", right, " : ", typeof(right))
    if typeof(left) == Int && typeof(right) == Int
        return left==right ? 0 : left<right ? -1 : +1
    elseif typeof(left) == Int
        return ordered([left], right)
    elseif typeof(right) == Int
        return ordered(left, [right])
    else
        for (ll, rr) in zip(left, right)
            result = ordered(ll, rr)
            if result != 0
                return result
            end
        end
        return length(left)==length(right) ? 0 : length(left)<length(right) ? -1 : +1
    end
end

function parse_pairs(input)
    pairs = []
    iter = eachline(IOBuffer(input))
    next = iterate(iter)
    while true
        (left, state) = next
        left = parse_line(left)

        next = iterate(iter)
        (right, state) = next
        right = parse_line(right)
        push!(pairs, (left, right))

        next = iterate(iter)
        if isnothing(next)
            break
        end
        (blank, state) = next
        @assert length(blank) == 0
        next = iterate(iter)
    end
    pairs
end

function parse_line(line)
    eval(Meta.parse(line))
end

@assert -1 == ordered(parse_line("[1,1,3,1,1]"), parse_line("[1,1,5,1,1]"))
@assert -1 == ordered(parse_line("[[1],[2,3,4]]"), parse_line("[[1],4]"))

example = raw"""
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

main()