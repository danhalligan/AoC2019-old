class Game
  TILE = {
    0 => ' ', # empty
    1 => "\u2588".encode('utf-8'), # wall
    2 => "\u2610".encode('utf-8'), # block
    3 => "\u2594".encode('utf-8'), # paddle
    4 => "\u2022".encode('utf-8')  # ball
  }

  def initialize(file = "input.txt")
    str = IO.read(file).chomp
    str[0] = '2'
    @score = 0
    @prog = Intcode.new(str)
    @screen = Hash.new { |h,k| h[k] = 0 }
  end

  def round(input = [])
    @input = input
    paddle = 99
    ball_pos = [-1, -1]
    loop do
      x, y, t = 3.times.map { @prog.run(@input) }
      break unless x
      # puts "#{t} #{[x, y].inspect}"
      if x == -1 && y == 0 # score
        @score = t
      else
        if t == 3
          paddle = x
        elsif t == 4
          ball_pos = [x, y]
          @input << (ball_pos[0] <=> paddle)
        elsif ball_pos == [x, y]
          yield view
          sleep 0.05
        end
        @screen[[x, y]] = t
      end
    end
    puts "END! Score: #{@score}"
  end

  def view
    is = @screen.keys.map { |x| x[0] }
    js = @screen.keys.map { |x| x[1] }
    s = "\e[2J\e[f"
    (js.min..js.max).to_a.each { |j|
      s += (is.min..is.max).to_a.map { |i| TILE[@screen[[i, j]]] }.join
      s += "\n"
    }
    score = @score.to_s.rjust(5, "0")
    n = (36 - 9 - score.length) / 2
    line = TILE[1] + "-" * n + " SCORE #{score} " + "-" * n + TILE[1]
    s + line
  end
end
