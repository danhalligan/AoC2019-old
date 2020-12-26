class Intcode
  def initialize(str)
    @mem = str.split(",").map(&:to_i)
  end

  class Param
    def initialize(pos, mode)
      @pos = pos
      @mode = mode
    end

    def val
      case @mode
      when 0 # position mode
        @mem[p]
      when 1 # immediate mode
        @pos
      end
    end
  end

  def run()
    i = 0
    loop do
      return nil if @mem[i] == 99
      str = @mem[i].to_s
      str = str.rjust(5, '0')
      opcode = str[-2..-1].to_i
      modes = str[0..-3].split('').reverse.map(&:to_i)
      # puts  "#{str}  #{opcode}  #{modes.join(',')}"
      case opcode
      when 1
        p = @mem[(i+1)..(i+3)]
        set modes[2], p[2], val(modes[0], p[0]) + val(modes[1], p[1])
        i += 4
      when 2
        p = @mem[(i+1)..(i+3)]
        set modes[2], p[2], val(modes[0], p[0]) * val(modes[1], p[1])
        i += 4
      when 3
        print "Enter input: "
        input = gets.chomp.to_i
        set modes[1], @mem[(i+1)], input
        i += 2
      when 4
        p = [@mem[(i+1)]]
        puts val(modes[0], p[0])
        i += 2
      when 5 # jump if true
        p = @mem[(i+1)..(i+2)]
        if val(modes[0], p[0]) != 0
          i = val(modes[1], p[1])
        else
          i += 3
        end
      when 6 # jump if false
        p = @mem[(i+1)..(i+2)]
        if val(modes[0], p[0]) == 0
          i = val(modes[1], p[1])
        else
          i += 3
        end
      when 7 # less than
        p = @mem[(i+1)..(i+3)]
        set(modes[2], p[2], val(modes[0], p[0]) < val(modes[1], p[1]) ? 1 : 0)
        i += 4
      when 8 # equals
        p = @mem[(i+1)..(i+3)]
        set(modes[2], p[2], val(modes[0], p[0]) == val(modes[1], p[1]) ? 1 : 0)
        i += 4
      end
    end
  end

  def val(mode, p)
    case mode
    when 0 # position mode
      @mem[p]
    when 1 # immediate mode
      p
    end
  end

  def set(mode, p, val)
    case mode
    when 0 # position mode
      # puts "setting #{p} to #{val}"
      @mem[p] = val
    when 1 # immediate mode
      abort 'parameters cannot be written in immediate mode!'
    end
  end
end