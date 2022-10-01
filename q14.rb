class Node
  attr_accessor :input, :amount, :chemical
  def initialize(x)
    @amount, @chemical = x.split(" ")
    @amount = @amount.to_i
    @input = []
  end

  def inspect
    "#{@amount} #{@chemical}"
  end
end

def parse(file)
  h = {}
  h["ORE"] = nil
  lines = IO.readlines(file, chomp: true)
  lines.map do |line|
    inp, out = line.split(" => ")
    out = Node.new(out)
    out.input = inp.split(", ").map { |x| Node.new(x) }
    h[out.chemical] = out
  end
  h
end

def ore_required(h, nfuel)
required = Hash.new {|h, k| h[k] = 0}
required["FUEL"] = nfuel
  produced = Hash.new {|h, k| h[k] = 0}
  ore = 0
  while required.length > 0
    # puts required
    item = required.keys[0]
    if required[item] <= produced[item]
      produced[item] -= required[item]
      required.delete(item)
      next
    end

    n_required = required[item] - produced[item]
    required.delete(item)
    produced.delete(item)
    n_produced = h[item].amount

    ratio = n_required.to_f / n_produced.to_f
    n_reactions = (ratio == ratio.floor ? ratio : ratio.floor + 1).to_i

    produced[item] += (n_reactions * n_produced) - n_required
    h[item].input.each { |chem|
      if chem.chemical == "ORE"
        ore += chem.amount * n_reactions
      else
        required[chem.chemical] += chem.amount * n_reactions
      end
    }
  end
  ore
end

# part a
required = Hash.new {|h, k| h[k] = 0}
required["FUEL"] = 1
inp = parse("input.txt")

puts ore_required(inp, required)

# part b
high = 1e7
low = 1e6

while low < high - 1
  mid = ((low + high) / 2).to_i
  ore = ore_required(inp, mid)
  low, high = ore < 1e12 ? [mid, high] : [low, mid]
end
puts low
