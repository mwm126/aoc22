module day_1
print("hi!")

example = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

function max_elf(input)
    max_elf = -1
    elf = 0
    for line in eachline(IOBuffer(input))
        val = tryparse(Int64, line)
        if typeof(val) == Int64
            elf += val
        else
            max_elf = max(elf, max_elf)
            elf = 0
        end

    end
    max_elf = max(elf, max_elf)
    return max_elf
end;

ex = max_elf(example)
println("Example gives: ", ex)

problem_input=read(stdin)
answer = max_elf(problem_input)
println("Part 1 answer: ", answer)

function top_3_elfs(input)
    au = -1 # Gold
    ag = -1 # Silver
    cu = -1 # Bronze
    elf = 0
    for line in eachline(IOBuffer(input))
        val = tryparse(Int64, line)
        if typeof(val) == Int64
            elf += val
        else
            if elf>cu
                cu = elf
            end
            if cu>ag
                cu, ag = ag, cu
            end
            if ag>au
                au, ag = ag, au
            end
            elf = 0
        end
    end
            if elf>cu
                cu = elf
            end
            if cu>ag
                cu, ag = ag, cu
            end
            if ag>au
                au, ag = ag, au
            end
    return au, ag, cu
end;

answer = top_3_elfs(problem_input)
println("Part 2 answer: ", answer, " Total: ", sum(answer))
end;