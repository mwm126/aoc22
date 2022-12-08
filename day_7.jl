example = raw"""
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

    answer = total_sub100k(problem_input)
    println("Part 1 answer: ", answer)

    answer = find_min_deldir(problem_input)
    println("Part 2 answer: ", answer)
end

struct DirTree
    name :: String
    parent :: Union{DirTree, Nothing}
    subdirs :: Vector{DirTree}
    file_sizes :: Vector{UInt}
end

## Julia needs to wrap primitive in a struct to pass by reference
mutable struct Total
    size :: UInt
end

function total_sub100k(input)
    root = parse_input(input)
    sub100k = Total(0)
    find_total(root, sub100k)
    sub100k.size
end

function find_total(tree::DirTree, sub100k :: Total)
    dir_total :: UInt = sum(tree.file_sizes; init=0)
    subdir_total = sum([ find_total(subdir, sub100k) for subdir in tree.subdirs]; init=0)
    total = dir_total + subdir_total
    if total < 100000
        sub100k.size += total
    end
    total
end

function find_min_deldir(input)
    root = parse_input(input)
    current_usage = find_total(root, Total(0))
    current_free = 70000000 - current_usage
    min_deldir = Total(current_usage) ## Root dir usage > all other possible directories
    find_smallest_deldir(root, current_free, min_deldir)
    min_deldir.size
end

NEED_FREE = 30000000

function find_smallest_deldir(tree::DirTree, current_free, min_deldir)
    dir_total :: UInt = sum(tree.file_sizes; init=0)
    subdir_total = sum([ find_smallest_deldir(subdir, current_free, min_deldir) for subdir in tree.subdirs]; init=0)
    total = dir_total + subdir_total
    if NEED_FREE <= current_free + total
        min_deldir.size = min(total, min_deldir.size)
    end
    total
end

PROMPT = raw"$"

function parse_input(input) :: DirTree
    root = DirTree("root", nothing, [], [])
    curr = root
    for line in eachline(IOBuffer(input))
        fields = split(line)
        if fields[1] == PROMPT && fields[2] == "cd" && fields[3] == ".."
            curr = curr.parent
        elseif fields[1] == PROMPT && fields[2] == "cd"
            subdir = DirTree(fields[3], curr, [], [])
            push!(curr.subdirs,subdir)
            curr = subdir
        elseif fields[1] == PROMPT && fields[2] == "ls"
            # println("Listing...", curr.name)
        elseif fields[1] == PROMPT
            @assert false
        elseif fields[1] == "dir"
            # println("Subdir...", fields[2])
        else
            file_size = tryparse(Int64, fields[1])
            push!(curr.file_sizes,file_size)
        end
    end
    root
end

@assert 95437 == total_sub100k(example)
@assert 24933642 == find_min_deldir(example)

main()