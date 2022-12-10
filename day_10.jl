function main()
    signals = find_signals(example)

    @assert 420 == signals[20]
    @assert 1140 == signals[60]
    @assert 1800 == signals[100]
    @assert 2940 == signals[140]
    @assert 2880 == signals[180]
    @assert 3960 == signals[220]
    @assert 13140 == sigsum(signals)

    problem_input = read(stdin)

    signals = find_signals(problem_input)
    answer = sigsum(signals)
    println("Part 1 answer: ", answer)

end

function sigsum(signals)
    sum(signals[cycle] for cycle in 20:40:220)
end

function find_signals(input)
    Vs = []
    for line in eachline(IOBuffer(input))
        V = 0
        if line != "noop"
            addx, V_s = split(line)
            @assert addx == "addx"
            V = tryparse(Int, V_s)
            push!(Vs, 0)
        end
        push!(Vs, V)
    end
    register = 1
    registers = []
    for (cycle, V) in enumerate(Vs)
        if 2 < cycle
            register += Vs[cycle-1]
        end
        push!(registers, register)
        println("cycle: ", cycle, "   V:  ", V, "       register: ", register, "   signal: ", cycle*register)
    end
    signals = [cycle * regval for (cycle, regval) in enumerate(registers)]
    signals
end

simple_example = """
noop
addx 3
addx -5
"""

example = raw"""
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

main()
