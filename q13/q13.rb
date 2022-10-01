load '../intcode.rb'

TILE = {
  0 => ' ',
  1 => "\u2588".encode('utf-8'),
  2 => "\u2610".encode('utf-8'),
  3 => "\u2594".encode('utf-8'),
  4 => "\u2022".encode('utf-8')
}

game = Intcode.from_file("input.txt")
screen = Hash.new { |h,k| h[k] = 0 }
loop do
  turn = 3.times.map { game.run }
  puts turn.join(',')
  break unless turn[0]
  screen[[turn[0], turn[1]]] = turn[2]
end
screen.count { |k,v| v == 2 }



load '../intcode.rb'
load './game.rb'
game = Game.new().round {|x| puts x}


