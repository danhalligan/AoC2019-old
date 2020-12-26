load '../intcode.rb'

def thruster(seq, prog)
  res = 0
  seq.each do |s|
    io = StringIO.new "#{s}\n#{res}\n"
    Intcode.new(prog).run(io: io)
    res = io.string.split("\n").last.to_i
  end
  res
end

thruster([0,1,2,3,4], '3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0')
thruster([1,0,4,3,2], '3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0')

prog = IO.read("input.txt").chomp
[0,1,2,3,4].permutation.map { |seq| thruster(seq, prog) }.max

Array(0..4).permutation.map do |phase_settings|
  phase_settings.reduce(0) do |input, setting|
    Intcode.new(intcode).run([setting, input])
  end
end.max


(5..9).to_a.permutation.map do |seq|
  amps_buffs = seq.map { |s| [Intcode.new(intcode), [s]] }

  (0..).reduce(0) do |input, i|
    amp, buff = amps_buffs[i % 5]
    amp.run(buff << input) || (break input)
  end
end
