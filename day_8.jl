example = raw"""
30373
25512
65332
33549
35390
"""

function main()
    problem_input = read(stdin)

    answer = visible_trees(problem_input)
    println("Part 1 answer: ", answer)

    answer = max_visibility_tree(problem_input)
    println("Part 2 answer: ", answer)
end

function visible_trees(input) :: UInt
    grid = parse_map(input)
    count = 0
    SIZE = size(grid,1)
    @assert SIZE == size(grid,2)
    for jj in 1:SIZE
        for ii in 1:SIZE
            if check_visibility(grid, ii, jj)
                count += 1
            end
        end
    end
    count
end

function max_visibility_tree(input) :: UInt
    grid = parse_map(input)
    max_score = 0
    SIZE = size(grid,1)
    @assert SIZE == size(grid,2)
    for jj in 1:SIZE
        for ii in 1:SIZE
            score = score_visibility(grid, ii, jj)
            if score > max_score
                max_score = score
            end
        end
    end
    max_score
end

function check_visibility(grid, ii, jj)
    tree = grid[ii, jj]
    SIZE = size(grid,1)
    @assert SIZE == size(grid,2)
    visible = true
    for mm in 1:ii-1
        if tree <= grid[mm,jj]
            visible = false
            break
        end
    end
    if visible
        return true
    end
    visible = true
    for mm in ii+1:SIZE
        if tree <= grid[mm,jj]
            visible = false
            break
        end
    end
    if visible
        return true
    end
    visible = true
    for nn in 1:jj-1
        if tree <= grid[ii,nn]
            visible = false
            break
        end
    end
    if visible
        return true
    end
    visible = true
    for nn in jj+1:SIZE
        if tree <= grid[ii,nn]
            visible = false
            break
        end
    end
    visible
end

function score_visibility(grid, ii, jj)
    tree = grid[ii, jj]
    SIZE = size(grid,1)
    @assert SIZE == size(grid,2)
    l_count = 0
    for mm in ii-1:-1:1
        l_count += 1
        if tree <= grid[mm,jj]
            break
        end
    end
    r_count = 0
    for mm in ii+1:SIZE
        r_count += 1
        if tree <= grid[mm,jj]
            break
        end
    end
    u_count = 0
    for nn in jj-1:-1:1
        u_count += 1
        if tree <= grid[ii,nn]
            break
        end
    end
    d_count = 0
    for nn in jj+1:SIZE
        d_count += 1
        if tree <= grid[ii,nn]
            break
        end
    end
    l_count*r_count*u_count*d_count
end

function parse_map(input)
    grid = []
    count = 0
    for line in eachline(IOBuffer(input))
        chars = [ Char(c) for c in line]
        strs = [ string(char) for char in chars]
        digs = [ tryparse(Int, d) for d in strs]
        grid = vcat(grid, digs)
        count += 1
    end
    reshape(grid, count, :)
end

@assert 21 == visible_trees(example)
@assert 8 == max_visibility_tree(example)

main()