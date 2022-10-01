class Intcode
  include Enumerable

  def initialize(str, mode: 0)
    mem = str.split(",").map(&:to_i)
    @mem = mem.each_with_index.map {|v, i| [i, v]}.to_h
    @ptr = 0
    @relbase = 0
    @mode = mode
  end

  def self.from_file(file, mode: 0)
    str = IO.read(file).chomp
    Intcode.new(str, mode: mode)
  end

  def run(input = [])
    loop do
      break if @mem[@ptr] == 99
      opcode, modes = parse_opcode
      action = Action.new(opcode, input, @relbase, @mode)
      params = params(action, modes)
      # puts  "#{@ptr} #{@mem[@ptr]} #{opcode} #{action.action} #{params.map {|x| x.inspect }.join(',')}"
      out = action.run(params)
      @ptr = action.update_ptr(@ptr)
      # puts @relbase
      @relbase = action.relbase
      if out
        block_given? ? (yield out) : (return out)
      end
    end
  end

  def each(input, &block)
    if block_given?
      block.call(run(input))
    else
      to_enum(:run, input)
    end
  end

  def parse_opcode
    str = @mem[@ptr].to_s.rjust(5, '0')
    opcode = str[-2..-1].to_i
    modes = str[0..-3].split('').reverse.map(&:to_i)
    [opcode, modes]
  end

  def params(action, modes)
    # binding.irb
    ((@ptr + 1)..(@ptr + action.nparam)).to_a
      .map {|k| @mem[k]}
      .zip(modes)
      .map {|x| Param.new(@mem, @relbase, *x) }
  end
end


class Param
  def initialize(mem, relbase, pos, mode)
    @mem, @relbase, @pos, @mode = mem, relbase, pos, mode
  end

  def inspect
    "#{@pos}(#{@mode})"
  end

  def val
    case @mode
    when 0 then @mem[@pos] || 0
    when 1 then @pos
    when 2 then @mem[@relbase + @pos] || 0
    end
  end

  def set(val)
    case @mode
    when 0 then @mem[@pos] = val
    when 1 then abort 'parameters cannot be written in immediate mode!'
    when 2 then @mem[@relbase + @pos] = val
    end
  end
end

class Action
  attr_reader :action, :relbase

  def initialize(opcode, input, relbase, mode)
    @action = {
      1 => :add,
      2 => :multiply,
      3 => :input,
      4 => :output,
      5 => :jit,
      6 => :jif,
      7 => :lt,
      8 => :equals,
      9 => :relupdate
    }[opcode]
    @input = input
    @relbase = relbase
    @ptrval = nil
    @mode = mode
  end

  def nparam
    method(@action).arity
  end

  def run(params)
    o = method(@action).call(*params)
    @action == :output ? o : nil
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
    if @mode == 0
      p1.set(@input.shift)
    else
      print "Enter value: "
      v = $stdin.gets.to_i
      puts v
      p1.set(v)
    end
  end

  def output(p1)
    return p1.val
  end

  def jit(p1, p2)
    @ptrval = p2.val if p1.val != 0
  end

  def jif(p1, p2)
    @ptrval = p2.val if p1.val == 0
  end

  def lt(p1, p2, p3)
    p3.set(p1.val < p2.val ? 1 : 0)
  end

  def equals(p1, p2, p3)
    p3.set(p1.val == p2.val ? 1 : 0)
  end

  def relupdate(p1)
    @relbase += p1.val
  end
end
