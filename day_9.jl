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
    @assert 13 == tailprint(example)
    @assert 1 == long_tailprint(example)
    @assert 36 == long_tailprint(example2)

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
    for line in eachline(IOBuffer(input))
        dir, steps_s = split(line)
        steps = tryparse(Int, steps_s)
        for _ in 1:steps
            if dir == "R"
                hx += 1
            elseif dir == "L"
                hx -= 1
            elseif dir == "D"
                hy -= 1
            elseif dir == "U"
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
    end
    length(prints)
end

mutable struct Knot
    x :: Int
    y :: Int
end

function long_tailprint(input)
    prints :: Dict{Tuple{Int,Int}, Bool} = Dict()
    prints[(0,0)] = true

    knots = [Knot(0, 0) for _ in 0:9]

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

            # debug_print(prints, knots)
        end
    end
    length(prints)
end

function debug_print(prints, knots)
    ## Debug print
    for i in 20:-1:-10
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

function move_knot(prints, knots, idx, dx :: Int, dy :: Int)
    knot = knots[idx]
    knot.x += dx
    knot.y += dy

    if idx == length(knots) ## record tail print
        prints[(knot.x,knot.y)] = true
        return
    end

    next_idx = idx + 1
    tail = knots[next_idx]
    dtx = 0
    dty = 0
    if tail.x < knot.x-1 || tail.x<knot.x && abs(knot.y-tail.y)>1
        dtx = +1
    end
    if knot.x+1 < tail.x || knot.x<tail.x && abs(knot.y-tail.y)>1
        dtx = -1
    end
    if tail.y < knot.y-1 || tail.y<knot.y && abs(knot.x-tail.x)>1
        dty = +1
    end
    if knot.y+1 < tail.y || knot.y<tail.y && abs(knot.x-tail.x)>1
        dty = -1
    end
    move_knot(prints, knots, next_idx, dtx, dty)
end

main()