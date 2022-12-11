mutable struct Monkey
    items::Vector{Int}
    operation::Expr
    test::Int
    true_throw::Int
    false_throw::Int
    inspection_count::Int
end

function main()
    monkeys = parse_monkeys(example)
    for _ in 1:20
        monkey_with_items(monkeys)
    end
    @assert 101 == monkeys[1].inspection_count
    @assert 95 == monkeys[2].inspection_count
    @assert 7 == monkeys[3].inspection_count
    @assert 105 == monkeys[4].inspection_count
    @assert 10605 == monkey_business(example)

    problem_input = read(stdin)

    answer = monkey_business(problem_input)
    println("Part 1 answer:\n", answer)
end

function monkey_business(input)
    monkeys = parse_monkeys(input)
    for _ in 1:20
        monkey_with_items(monkeys)
    end
    counts = [m.inspection_count for m in monkeys]
    sort!(counts)
    monk, monk2 = last(counts, 2)
    monk*monk2
end

function monkey_with_items(monkeys)
    for monkey in monkeys
        while !isempty(monkey.items)
            monkey.inspection_count += 1
            global old = popfirst!(monkey.items) ## global needed for eval()
            # println("monkey inspects with worry level ", old)
            item = eval(monkey.operation)
            # println("worry level now ", item)
            item ÷= 3
            # println("bored monkey; worry level now ", item)
            next_monkey = (0 == item % monkey.test) ? monkey.true_throw : monkey.false_throw
            # println("throw to monkey ", next_monkey)
            push!(monkeys[next_monkey+1].items, item)
        end
    end
end

function parse_monkeys(input)
    monkeys = []
    iter = eachline(IOBuffer(input))
    next = iterate(iter)
    while !isnothing(next)
        items = []
        (line, state) = next
        label, _ = split(line)
        @assert label == "Monkey"

        (line, state) = iterate(iter)
        _, items = split(line, "Starting items:")
        items = [tryparse(Int, item) for item in split(items, ",")]

        (line, state) = iterate(iter)
        _, op_s = split(line, "Operation:")
        _, rhs = split(op_s, "new =")
        expr = Meta.parse(rhs)

        (line, state) = iterate(iter)
        _, div_s = split(line, "Test: divisible by")
        div_test = tryparse(Int, div_s)

        (line, state) = iterate(iter)
        _, true_s = split(line, "If true: throw to monkey ")
        true_throw = tryparse(Int, true_s)

        (line, state) = iterate(iter)
        _, false_s = split(line, "If false: throw to monkey ")
        false_throw = tryparse(Int, false_s)

        monkey = Monkey(items, expr, div_test, true_throw, false_throw, 0)
        push!(monkeys, monkey)

        next = iterate(iter)
        if isnothing(next)
            break ## no newline at the end
        end
        (line, state) = next
        @assert isempty(line) # newline between monkeys
        next = iterate(iter, state)
    end
    monkeys
end

example = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

main()
