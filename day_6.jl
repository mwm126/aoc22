function main()
    problem_input = read(stdin)

    answer = first_uniq_four(problem_input)
    println("Part 1 answer: ", answer)

    answer = first_uniq_14(problem_input)
    println("Part 2 answer: ", answer)
end

function first_uniq_four(s)
    N = length(s)
    for n in 4:N
        uniq = true
        for i in 0:4
            for j in (i+1):4
                if s[n+i-3] == s[n+j-3]
                    uniq = false
                    break
                end
            end
        end
        if uniq
            return n
        end
    end
    throw(ArgumentError("Invalid input: No Answer found"))
end

function first_uniq_14(s)
    N = length(s)
    for n in 14:N
        uniq = true
        char14 = s[n-13:n]
        chars = [char for char in char14]
        charset = Set(chars)
        if length(charset) == 14
            return n
        end
    end
    throw(ArgumentError("Invalid input: No Answer found"))
end

@assert 5 == first_uniq_four("bvwbjplbgvbhsrlpgdmjqwftvncz")
@assert 6 == first_uniq_four("nppdvjthqldpwncqszvftbrmjlhg")
@assert 10 == first_uniq_four("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
@assert 11 == first_uniq_four("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")

@assert 19 == first_uniq_14("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
@assert 23 == first_uniq_14("bvwbjplbgvbhsrlpgdmjqwftvncz")
@assert 23 == first_uniq_14("nppdvjthqldpwncqszvftbrmjlhg")
@assert 29 == first_uniq_14("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
@assert 26 == first_uniq_14("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")

main()