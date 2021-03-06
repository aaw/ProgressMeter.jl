import ProgressMeter
import Base.Test.@test

function testfunc(n, dt, tsleep)
    p = ProgressMeter.Progress(n, dt)
    for i = 1:n
        sleep(tsleep)
        ProgressMeter.next!(p)
    end
end
println("Testing original interface...")
testfunc(107, 0.01, 0.01)


function testfunc2(n, dt, tsleep, desc, barlen)
    p = ProgressMeter.Progress(n, dt, desc, barlen)
    for i = 1:n
        sleep(tsleep)
        ProgressMeter.next!(p)
    end
end
println("Testing desc and progress bar")
testfunc2(107, 0.01, 0.01, "Computing...", 50)
println("Testing no desc and no progress bar")
testfunc2(107, 0.01, 0.01, "", 0)


function testfunc3(n, tsleep, desc)
    p = ProgressMeter.Progress(n, desc)
    for i = 1:n
        sleep(tsleep)
        ProgressMeter.next!(p)
    end
end
println("Testing tty width...")
testfunc3(107, 0.02, "Computing (use tty width)...")
println("Testing no description...")
testfunc3(107, 0.02, "")




function testfunc4()  # test "days" format
    p = ProgressMeter.Progress(10000000, "Test...")
    for i = 1:105
        sleep(0.02)
        ProgressMeter.next!(p)
    end
end

println("Testing that not even 1% required...")
testfunc4()


function testfunc5(n, dt, tsleep, desc, barlen)
    p = ProgressMeter.Progress(n, dt, desc, barlen)
    for i = 1:int(floor(n/2))
        sleep(tsleep)
        ProgressMeter.next!(p)
    end
    for i = int(ceil(n/2)):n
        sleep(tsleep)
        ProgressMeter.next!(p, :red)
    end
end

println("Testing changing the bar color")
testfunc5(107, 0.01, 0.01, "Computing...", 50)


function testfunc6(n, dt, tsleep)
    ProgressMeter.@showprogress dt for i in 1:n
        if !isprime(i)
            sleep(tsleep)
            continue
        end
    end
end

println("Testing @showprogress macro on for loop")
testfunc6(3000, 0.01, 0.002)


function testfunc7(n, dt, tsleep)
    s = ProgressMeter.@showprogress dt "Calculating..." [(sleep(tsleep); z) for z in 1:n]
    @test s == [1:n]
end

println("Testing @showprogress macro on comprehension")
testfunc7(100, 0.1, 0.01)


function testfunc8(n, dt, tsleep)
    ProgressMeter.@showprogress dt for i in 1:n
        if !isprime(i)
            sleep(tsleep)
            continue
        end
        for j in 1:10
            if j % 2 == 0
                continue
            end
        end
        while randbool()
            continue
        end
    end
end

println("Testing @showprogress macro on a for loop with inner loops containing continue statements")
testfunc8(3000, 0.01, 0.002)


function testfunc9(n, dt, tsleep)
    s = ProgressMeter.@showprogress dt "Calculating..." Float64[(sleep(tsleep); z) for z in 1:n]
    @test s == [1:n]
end

println("Testing @showprogress macro on typed comprehension")
testfunc9(100, 0.1, 0.01)


println("")
println("All tests complete")
