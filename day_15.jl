function main()
    @assert 26 == no_beacons(example, 10)

    problem_input = read(stdin)

    answer = no_beacons(problem_input, 2000000)
    println("Part 1 answer:\n", answer)
end

function no_beacons(input, count_row)
    sensors = []
    min_col = count_row
    max_col = count_row
    for line in eachline(IOBuffer(input))
        sensor = parse_sensor(line)
        push!(sensors, sensor)
        min_col = min(min_col, sensor.x - sensor.r)
        max_col = max(max_col, sensor.x + sensor.r)
    end
    count = 0

    # min_col = -100000
    min_row = count_row
    # max_col = 1100010
    max_row = count_row
    for row in min_row:max_row
        # print("row ", row, " ")
        for col in min_col:max_col
            if is_sensor(sensors, col, row)
                # print("S")
                if count_row == row
                    count += 1
                end
            elseif is_beacon(sensors, col, row)
                # print("B")
            elseif no_beacon(sensors, col, row)
                # print("x")
                if count_row == row
                    count += 1
                end
            else
                # print(".")
            end
        end
        # println()
    end

    println("COUNTED ", count)
    count
end

function is_beacon(sensors, col, row)
    for sensor in sensors
        if sensor.bx == col && sensor.by == row
            return true
        end
    end
    return false
end

function is_sensor(sensors, col, row)
    for sensor in sensors
        if sensor.x == col && sensor.y == row
            return true
        end
    end
    return false
end

function no_beacon(sensors, col, row)
    for sensor in sensors
        dist = manhattan_distance((col, row), (sensor.x, sensor.y))
        if dist <= sensor.r
            return true
        end
    end
    return false
end

struct Sensor
    x::Int
    y::Int
    r::Int
    bx::Int
    by::Int
end

function parse_sensor(line)
    sens, beac = split(line, ":")
    xx_s, yy_s = split(sens, ",")
    _, x_s = split(xx_s, "=")
    _, y_s = split(yy_s, "=")
    x = tryparse(Int, x_s)
    y = tryparse(Int, y_s)

    xxr_s, yyr_s = split(beac, ",")
    _, xr_s = split(xxr_s, "=")
    _, yr_s = split(yyr_s, "=")
    xr = tryparse(Int, xr_s)
    yr = tryparse(Int, yr_s)

    r = manhattan_distance((x, y), (xr, yr))
    Sensor(x, y, r, xr, yr)
end

function manhattan_distance((x, y), (xr, yr))
    abs(x - xr) + abs(y - yr)
end

example = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""

main()
