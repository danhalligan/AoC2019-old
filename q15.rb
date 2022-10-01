load '../intcode.rb'
droid = Intcode.from_file("input.txt", mode: 0)

map = Hash.new {|h,k| h[k] = ' '}
loc = [0,0]
dir = 1
map[loc] = arrow(dir)
out = nil

def move(loc, dir)
  case dir
  when 1 then [loc[0], loc[1] - 1]
  when 2 then [loc[0], loc[1] + 1]
  when 3 then [loc[0] - 1, loc[1]]
  when 4 then [loc[0] + 1, loc[1]]
  end
end

def arrow(dir)
  case dir
  when 1 then "\u2191"
  when 2 then "\u2193"
  when 3 then "\u2190"
  when 4 then "\u2192"
  end
end

def view(map, loc, dir, oxygen)
  map[loc] = arrow(dir).encode('utf-8')
  is = map.keys.map { |x| x[0] }
  js = map.keys.map { |x| x[1] }
  # s = "\e[2J\e[f"
  s = ''
  a = arrow(dir)
  map[[0,0]] = 'S'
  map[oxygen] = '*' if oxygen
  (js.min..js.max).to_a.each { |j|
    s += (is.min..is.max).to_a.map { |i| map[[i, j]] }.join
    s += "\n"
  }
  s
end

def right(dir)
  case dir
  when 1 then 4
  when 4 then 2
  when 2 then 3
  when 3 then 1
  end
end

def left(dir)
  case dir
  when 4 then 1
  when 2 then 4
  when 3 then 2
  when 1 then 3
  end
end

oxygen = nil
loop do
  # puts "loc: #{loc} dir: #{dir}"
  # $stdin.gets
  out = droid.run([dir])
  if out == 0
    map[move(loc, dir)] = "\u2588".encode('utf-8')
    dir = right(dir)
  elsif out == 1
    map[loc] = '.'
    loc = move(loc, dir)
    dir = left(dir)
  elsif out == 2
    oxygen = loc
    map[loc] = '*'
    loc = move(loc, dir)
    dir = left(dir)
  else
    abort "error code: #{out}"
  end
  puts
  print(view(map, loc, dir, oxygen))
end

# print(view(map, loc))

