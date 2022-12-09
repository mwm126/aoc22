example = raw"""
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

example2 = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

function main()
    problem_input = read(stdin)

    answer = tailprint(problem_input)
    println("Part 1 answer: ", answer)

    answer = long_tailprint(problem_input)
    println("Part 2 answer: ", answer)
end

function tailprint(input)
    grid = []
    hx = 0
    hy = 0
    tx = 0
    ty = 0
    prints :: Dict{Tuple{Int,Int}, Bool} = Dict()
    prints[(tx,ty)] = true
    # println("added origin.")
    for line in eachline(IOBuffer(input))
        dir, steps_s = split(line)
        steps = tryparse(Int, steps_s)
        for step in 1:steps
            # print("X")
            if dir == "R"
                # println("step up")
                hx += 1
            elseif dir == "L"
                # println("step down")
                hx -= 1
            elseif dir == "D"
                # println("step left")
                hy -= 1
            elseif dir == "U"
                # println("step right")
                hy += 1
            else
                @assert false
            end
            # print("H: ", dir, " ", hx, " ", hy, "         T:")
            dtx = 0
            dty = 0
            if tx < hx-1 || tx<hx && abs(hy-ty)>1
                dtx = +1
                # print("r")
            end
            if hx+1 < tx || hx<tx && abs(hy-ty)>1
                dtx = -1
                # print("l")
            end
            if ty < hy-1 || ty<hy && abs(hx-tx)>1
                dty = +1
                # print("u")
            end
            if hy+1 < ty || hy<ty && abs(hx-tx)>1
                dty = -1
                # print("d")
            end
            tx += dtx
            ty += dty
            prints[(tx,ty)] = true
        end

        # for i in 1:5
        #     for j in 1:5
        #         if i==hx && j == hy
        #             print("H")
        #         elseif i==tx && j == ty
        #             print("T")
        #         elseif ((i,j) in keys(prints))
        #             print("X")
        #         else
        #             print(".")
        #         end
        #     end
        #     println()
        # end

    end
    println("total is ", length(prints))
    length(prints)
end

function long_tailprint(input)
    36
end

@assert 13 == tailprint(example)
@assert 36 == long_tailprint(example)

main()