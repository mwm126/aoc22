function main()
    @assert 24 == resting_sandcount(example)

    @assert 93 == restingfloor_sandcount(example)

    problem_input = read(stdin)

    answer = resting_sandcount(problem_input)
    println("Part 1 answer: ", answer)

    answer = restingfloor_sandcount(problem_input)
    println("Part 2 answer: ", answer)
end

function resting_sandcount(input)
    map = parse_map(input)
    run_sand(map)
end

function restingfloor_sandcount(input)
    map = parse_map(input, true)
    run_sand(map)
end

function run_sand(map)
    count = 0
    while true
        s_i = 0
        s_j = 500

        if map[s_i+1, s_j-1] == sand && map[s_i+1, s_j] == sand && map[s_i+1, s_j+1] == sand
            ## floor to ceiling
            print_map(map)
            return count+1 # plus one for the origin
        end

        while true
            if s_i+1 > size(map,2)
                ## flow to void
                print_map(map)
                println("fallen to void!")
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


# ............o............
# ...........ooo...........
# ..........ooooo..........
# .........ooooooo.........
# ........oo#ooo##o........
# .......ooo#ooo#ooo.......
# ......oo###ooo#oooo......
# .....oooo.oooo#ooooo.....
# ....oooooooooo#oooooo....
# ...ooo#########ooooooo...
# ..ooooo.......ooooooooo..
# #########################

function print_map(map :: Matrix{CellMatter})
    println()
    for i in 1:300
        for j in 300:650
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


function parse_map(input, with_floor=false)
    map = Matrix{CellMatter}(undef, 1000, 1000)
    for i in 1:size(map,1)
        for j in 1:size(map,2)
            map[i,j] = air
        end
    end
    i_floor = 1
    for line in eachline(IOBuffer(input))
        segments = split(line, "->")
        j, i = split(segments[1], ",")
        i = tryparse(Int, i)
        j = tryparse(Int, j)
        i_floor = max(i_floor, i+2)
        for segment in segments[2:end]
            j_n, i_n = split(segment, ",")
            i_n = tryparse(Int, i_n)
            j_n = tryparse(Int, j_n)
            i_floor = max(i_floor, i_n+2)
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
    if with_floor
        for j in 1:size(map,2)
            map[i_floor, j] = rock
        end
    end
    map
end

example = raw"""
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

main()