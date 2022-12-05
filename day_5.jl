example = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
 """

function main()
    problem_input = read(stdin)

    @assert "CMZ" == end_state(example, do_move)

    answer = end_state(problem_input, do_move)
    println("Part 1 answer: ", answer)

    @assert "MCD" == end_state(example, do_move_3001)

    answer = end_state(problem_input, do_move_3001)
    println("Part 2 answer: ", answer)
end

function end_state(input, funk)
    input_iter = eachline(IOBuffer(input))
    stacks = parse_stacks(input_iter)

    make_moves(stacks, funk, input_iter)
end

function make_moves(stacks, funk, input_iter)
    for line in input_iter
        if isempty(strip(line))
            continue
        end
        _, count_s, _, src_s, _, dest_s = split(line)
        count = tryparse(Int64, count_s)
        src = tryparse(Int64, src_s)
        dest = tryparse(Int64, dest_s)
        funk(stacks, src, dest, count)
    end
    join([pop!(stack) for stack in stacks])
end

function do_move(stacks, src, dest, count)
    for _ in 1:count
        push!(stacks[dest], pop!(stacks[src]))
    end
end

function do_move_3001(stacks, src, dest, count)
    tmp_stack = []
    for _ in 1:count
        push!(tmp_stack, pop!(stacks[src]))
    end
    for _ in 1:count
        push!(stacks[dest], pop!(tmp_stack))
    end
end

function parse_stacks(input_iter)
    stack_lines = []
    for line in input_iter
        if isempty(line)
            break
        end
        push!(stack_lines, line)
    end
    stack_labels = pop!(stack_lines)
    stack_count = length(split(stack_labels))
    stacks = [[] for _ in 1:stack_count]

    while length(stack_lines) > 0
        line = pop!(stack_lines)
        for n in 1:stack_count+1
            char_index = 4 * n - 2
            if char_index < length(line)
                the_char = line[char_index]
                if the_char != ' '
                    push!(stacks[n], the_char)
                end
            end
        end
    end
    stacks
end

main()
