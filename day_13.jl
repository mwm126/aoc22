function main()
    @assert 13 == ordered_sum(example)

    @assert 140 == decoder_key(example)

    problem_input = read(stdin)

    answer = ordered_sum(problem_input)
    println("Part 1 answer: ", answer)

    answer = decoder_key(problem_input)
    println("Part 2 answer: ", answer)
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

function sort_packets(packets)
    packets
end

function decoder_key(input)
    packets = parse_all(input)
    packets = sort_packets(packets)
    index_1 = -1
    index_2 = -1
    for (ii, packet) in enumerate(packets)
        # println(ii, " ", packet, typeof(packet), " ", [[2]], " ", typeof([[2]]), "???", packet == [[2]])
        if packet == [[2]]
            index_1 = ii
        end
        if packet == [[6]]
            index_2 = ii
        end
    end
    println("index 1: ", index_1)
    println("index 2: ", index_2)
    index_1*index_2
end

function parse_all(input)
    packets :: Vector{Any} = [parse_line("[[2]]"), parse_line("[[6]]")]
    pairs = parse_pairs(input)
    for pair in pairs
        left, right = pair
        push!(packets, left)
        push!(packets, right)
    end
    packets
end

function ordered(left, right)
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