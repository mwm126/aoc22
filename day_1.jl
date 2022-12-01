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
println("Example gives:", ex)

line=readline(stdin)
answer = max_elf(line)
print("My problem gives:", answer)
end;