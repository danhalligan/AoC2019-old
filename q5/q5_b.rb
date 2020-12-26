require '../intcode2.rb'
dat = IO.read("input.txt").chomp
Intcode.new(dat).run()
