class Intcode
  def initialize(str)
    @mem = str.split(",").map(&:to_i)
  end

  def run(inp: $stdin, out: $stdout)
    @ptr = 0
    loop do
      break if @mem[@ptr] == 99
      opcode, modes = parse_opcode
      action = Action.new(opcode, inp: inp, out: out)
      # puts  "#{opcode} #{action.action} #{modes.join(',')}"
      action.run(params(action, modes))
      @ptr = action.update_ptr(@ptr)
    end
  end

  def parse_opcode
    str = @mem[@ptr].to_s.rjust(5, '0')
    opcode = str[-2..-1].to_i
    modes = str[0..-3].split('').reverse.map(&:to_i)
    [opcode, modes]
  end

  def params(action, modes)
    @mem[(@ptr + 1)..(@ptr + action.nparam)]
      .zip(modes)
      .map {|x| Param.new(@mem, *x) }
  end
end


class Param
  def initialize(mem, pos, mode)
    @mem, @pos, @mode = mem, pos, mode
  end

  def inspect
    "#{@pos}(#{@mode})"
  end

  def val
    case @mode
    when 0 then @mem[@pos]
    when 1 then @pos
    end
  end

  def set(val)
    case @mode
    when 0 then @mem[@pos] = val
    when 1 then abort 'parameters cannot be written in immediate mode!'
    end
  end
end

class Action
  attr_reader :action

  def initialize(opcode, inp: $stdin, out: $stdout)
    @action = {
      1 => :add,
      2 => :multiply,
      3 => :input,
      4 => :output,
      5 => :jit,
      6 => :jif,
      7 => :lt,
      8 => :equals
    }[opcode]
    @inp = inp
    @out = out
    @ptrval = nil
  end

  def nparam
    method(@action).arity
  end

  def run(params)
    method(@action).call(*params)
  end

  def update_ptr(ptr)
    @ptrval.nil? ? ptr + method(@action).arity + 1 : @ptrval
  end

  def add(p1, p2, p3)
    p3.set(p1.val + p2.val)
  end

  def multiply(p1, p2, p3)
    p3.set(p1.val * p2.val)
  end

  def input(p1)
    # print "Enter input: "
    input = @inp.gets.chomp.to_i
    p1.set(input)
  end

  def output(p1)
    @out.puts p1.val
  end

  def jit(p1, p2)
    if p1.val != 0
      @ptrval = p2.val
    end
  end

  def jif(p1, p2)
    if p1.val == 0
      @ptrval = p2.val
    end
  end

  def lt(p1, p2, p3)
    p3.set(p1.val < p2.val ? 1 : 0)
  end

  def equals(p1, p2, p3)
    p3.set(p1.val == p2.val ? 1 : 0)
  end
end
