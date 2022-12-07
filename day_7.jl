example = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""


function main()
    problem_input = read(stdin)

    answer = subtotal_100k(problem_input)
    println("Part 1 answer: ", answer)

    answer = subtotal_100k(problem_input)
    println("Part 2 answer: ", answer)
end

function subtotal_100k(input)
end

@assert 95437 == subtotal_100k(example)