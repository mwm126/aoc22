module day_2

example = """
A Y
B X
C Z
"""

function main()
    problem_input = read(stdin)

    @assert 15 == rps_score(example)
    answer = rps_score(problem_input)
    println("Part 1 answer: ", answer)

    @assert 12 == fixed_rps_score(example)
    answer = fixed_rps_score(problem_input)
    println("Part 2 answer: ", answer)
end

function rps_score(input)
    return sum(Iterators.map(get_score, eachline(IOBuffer(input))))
end

function fixed_rps_score(input)
    ## The game is rigged!
    return sum(Iterators.map(get_score_2, eachline(IOBuffer(input))))
end

function get_score(line)
    away, home = split(line)
    h = home[1] - 'X'
    a = away[1] - 'A'
    result = mod(3 + h - a, 3)
    score = 1 + h
    if result == 0
        score += 3 # draw
    elseif result == 1
        score += 6 # win
    elseif result == 2
        score += 0 # lose
    end
    score
end

@assert get_score("A Y") == 8
@assert get_score("B X") == 1
@assert get_score("C Z") == 6

function get_score_2(line)
    away, result = split(line)
    r = result[1] - 'X'
    a = away[1] - 'A'
    if r == 0      # lose
        score = 0 + mod(a - 1, 3) + 1
    elseif r == 1  # draw
        score = 3 + a + 1
    elseif r == 2  # win
        score = 6 + mod(a + 1, 3) + 1
    end
    score
end

@assert get_score_2("A Y") == 4
@assert get_score_2("B X") == 1
@assert get_score_2("C Z") == 7

main()

end;