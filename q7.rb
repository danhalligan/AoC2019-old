load '../intcode.rb'

def thruster(seq, prog)
  seq.reduce(0) do |signal, setting|
    Intcode.new(prog).run([setting, signal])
  end
end

def thruster2_threads(seq, prog)
  queues = (0..4).map { |i| Queue.new << seq[i] }
  queues.first << 0

  Array.new(5) do |i|
    Thread.new do
      Intcode.new(prog).run(queues[i]) { |v| queues.rotate[i] << v }
    end
  end.each(&:join)
  queues.first.pop
end

def thruster2(seq, prog)
  amps = (0..4).map { Intcode.new(prog) }
  buffers = seq.map { |s| [s] }

  amps.zip(buffers).cycle.reduce(0) do |input, (amp, buff)|
    amp.run(buff << input) || (break input)
  end
end

thruster([4,3,2,1,0], '3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0')
thruster([0,1,2,3,4], '3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0')
thruster([1,0,4,3,2], '3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0')

prog = IO.read("input.txt").chomp

# part a: 199988
[0,1,2,3,4].permutation.map { |seq| thruster(seq, prog) }.max

# part b: 17519904
[5,6,7,8,9].permutation.map { |seq| thruster2_threads(seq, prog) }.max

# part b: 17519904
[5,6,7,8,9].permutation.map { |seq| thruster2(seq, prog) }.max
