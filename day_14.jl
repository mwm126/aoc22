function main()
    @assert 24 == resting_sandcount(example)

    problem_input = read(stdin)

    answer = resting_sandcount(problem_input)
    println("Part 1 answer: ", answer)
end

function resting_sandcount(input)
    map = parse_map(input)
    run_sand(map)
end

function run_sand(map)
    count = 0
    while true
        s_i = 1
        s_j = 500
        while true
            if s_i+1 > size(map,2)
                print_map(map)
                return count
            elseif map[s_i+1, s_j] == air
                s_i += 1
            elseif map[s_i+1, s_j-1] == air
                s_i += 1
                s_j -= 1
            elseif map[s_i+1, s_j+1] == air
                s_i += 1
                s_j += 1
            else
                map[s_i, s_j] = sand
                count += 1
                # println("grain #", count, " resting at s_i,s_j: ", s_i, " ", s_j)
                break
            end
        end
    end
end

@enum CellMatter air=1 rock=2 sand=3 source=4

function print_map(map :: Matrix{CellMatter})
    for i in 1:200
        for j in 430:530
            cell = map[i,j]
            if i>50000
                print("!")
            elseif cell == air
                print(".")
            elseif cell == rock
                print("#")
            elseif cell == sand
                print("o")
            elseif cell == source
                print("+")
            else
                @assert false
            end
        end
        println()
    end
end


function parse_map(input)
    map = Matrix{CellMatter}(undef, 1000, 1000)
    for i in 1:size(map,1)
        for j in 1:size(map,2)
            map[i,j] = air
        end
    end
    print_map(map)
    for line in eachline(IOBuffer(input))
        segments = split(line, "->")
        j, i = split(segments[1], ",")
        i = tryparse(Int, i)
        j = tryparse(Int, j)
        for segment in segments[2:end]
            j_n, i_n = split(segment, ",")
            i_n = tryparse(Int, i_n)
            j_n = tryparse(Int, j_n)
            # println("DRAW LINE FROM ", i, " ", j, " -> ", i_n, " ", j_n)
            while i_n != i || j_n != j
                @assert i==i_n || j==j_n
                map[i, j] = rock
                i += sign(i_n-i)
                j += sign(j_n-j)
            end
            map[i, j] = rock
            # print_map(map)
        end
    end
    map
end

example = raw"""
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

main()