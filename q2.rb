
def intcode(p)
  i = 0
  loop do
    return p if p[i] == 99
    v = p[(i+1)..(i+3)]
    case p[i]
    when 1
      p[v[2]] = p[v[0]] + p[v[1]]
    when 2
      p[v[2]] =p[v[0]] * p[v[1]]
    end
    i += 4
  end
  p
end

dat = IO.read("q2.txt").chomp.split(",").map(&:to_i)
dat[1] = 12
dat[2] = 2
intcode(dat)

def partb(dat)
  target = 19690720
  (0..99).each do |noun|
    (0..99).each do |verb|
      test = dat.clone
      test[1] = noun
      test[2] = verb
      if intcode(test)[0] == target
        return [noun, verb]
      end
    end
  end
end

out = partb(dat)
100 * out[0] + out[1]
