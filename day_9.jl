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
            dtx = 0
            dty = 0
            if tx < hx-1 || tx<hx && abs(hy-ty)>1
                dtx = +1
            end
            if hx+1 < tx || hx<tx && abs(hy-ty)>1
                dtx = -1
            end
            if ty < hy-1 || ty<hy && abs(hx-tx)>1
                dty = +1
            end
            if hy+1 < ty || hy<ty && abs(hx-tx)>1
                dty = -1
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
    length(prints)
end

mutable struct Knot
    id :: Int
    x :: Int
    y :: Int
end

function make_knots()
    knots = [Knot(0, 0, 0)] ## head has ID zero
    for n in 1:9
        push!(knots, Knot(n, 0, 0))
    end
    knots
end

function long_tailprint(input)
    prints :: Dict{Tuple{Int,Int}, Bool} = Dict()
    prints[(0,0)] = true

    knots = make_knots()

    for line in eachline(IOBuffer(input))
        dir, steps_s = split(line)
        steps = tryparse(Int, steps_s)
        for _ in 1:steps
            dx = 0
            dy = 0
            if dir == "R"
                dx = 1
            elseif dir == "L"
                dx = -1
            elseif dir == "D"
                dy = -1
            elseif dir == "U"
                dy = 1
            else
                @assert false
            end
            move_knot(prints, knots, 1, dx, dy)

            ## Debug print
            for i in 20:1:-10
                for j in -10:20
                    symbol = "."
                    if ((i,j) in keys(prints))
                        symbol = "X"
                    end
                    for n in length(knots):-1:1
                        if i==knots[n].x && j == knots[n].y
                            if n == 1
                                symbol = "H"
                            elseif n == 10
                                symbol = "T"
                            else
                                symbol = n-1
                            end
                        end
                    end
                    print(symbol)
                end
                println()
            end

        end
    end
    length(prints)
end

function move_knot(prints, knots, idx, dx :: Int, dy :: Int)
    knot = knots[idx]
    knot.x += dx
    knot.y += dy

    if idx == length(knots)
        # println("Tail ", knot.id, " visited: ", knot.x, " x ", knot.y)
        @assert knot.id == 9
        prints[(knot.x,knot.y)] = true
        return
    end

    next_idx = idx + 1
    tail = knots[next_idx]

    # print("H: ", dir, " ", hx, " ", hy, "         T:")
    dtx = 0
    dty = 0
    if tail.x < knot.x-1 || tail.x<knot.x && abs(knot.y-tail.y)>1
        dtx = +1
        # print("r")
    end
    if knot.x+1 < tail.x || knot.x<tail.x && abs(knot.y-tail.y)>1
        dtx = -1
        # print("l")
    end
    if tail.y < knot.y-1 || tail.y<knot.y && abs(knot.x-tail.x)>1
        dty = +1
        # print("u")
    end
    if knot.y+1 < tail.y || knot.y<tail.y && abs(knot.x-tail.x)>1
        dty = -1
        # print("d")
    end
    move_knot(prints, knots, next_idx, dtx, dty)

end

@assert 13 == tailprint(example)
@assert 1 == long_tailprint(example)
@assert 36 == long_tailprint(example2)

main()