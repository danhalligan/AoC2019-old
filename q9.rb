load '../intcode.rb'
prog = IO.read("input.txt").chomp
puts Intcode.new(prog).run([1])
puts Intcode.new(prog).run([2])
