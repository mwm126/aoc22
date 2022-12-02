module day_2

example = """
A Y
B X
C Z
"""

function main()
    ex = rps_score(example)
    println("Example gives: ", ex)
    @assert ex == 15

    problem_input = read(stdin)
    answer = rps_score(problem_input)
    println("Part 1 answer: ", answer)

    ex = fixed_rps_score(example)
    println("Example gives: ", ex)
    @assert ex == 12

    answer = fixed_rps_score(problem_input)
    println("Part 2 answer: ", answer)
end

function rps_score(input)
    score = 0
    for line in eachline(IOBuffer(input))
        score += get_score(line)
    end
    return score
end

function get_score(line)
    score = 0
    away, home = split(line)
    score += 1 + home[1] - 'X'
    h = home[1] - 'X'
    a = away[1] - 'A'
    result = mod(3 + h - a, 3)
    if result == 0
        score += 3 # draw
    elseif result == 1
        score += 6 # win
    elseif result == 2
        score += 0 # lose
    end
    return score
end

@assert get_score("A Y") == 8
@assert get_score("B X") == 1
@assert get_score("C Z") == 6

function fixed_rps_score(input)
    ## The game is rigged!
    score = 0
    for line in eachline(IOBuffer(input))
        score += get_score_2(line)
    end
    return score
end


function get_score_2(line)
    score = 0
    away, result = split(line)
    r = result[1] - 'X'
    a = away[1] - 'A'
    if r == 0      # lose
        score += 0 # lose
        h = mod(a - 1, 3)
    elseif r == 1  # draw
        score += 3 # draw
        h = a
    elseif r == 2  # win
        score += 6 # win
        h = mod(a + 1, 3)
    end
    score += h + 1
end

@assert get_score_2("A Y") == 4
@assert get_score_2("B X") == 1
@assert get_score_2("C Z") == 7

main()

end;