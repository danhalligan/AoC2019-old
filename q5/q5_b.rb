require '../intcode.rb'
Intcode.from_file("input.txt").run([5]) {|x| puts x}
