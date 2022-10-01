
require '../intcode.rb'

def paint(hull)
  panels = Hash.new { |h,k| h[k] = 0 }
  robot = Intcode.from_file("input.txt")
  dir, i, j = 0, 0, 0
  while paintcode = robot.run([hull])
    panels[[i, j]] = paintcode
    dir = (robot.run == 0 ? (dir-1) : (dir+1)) % 4
    case dir
    when 0 then j += 1
    when 1 then i += 1
    when 2 then j -= 1
    when 3 then i -= 1
    end
    hull = panels[[i, j]]
  end
  panels
end

# part a
paint(0).length

# part b
out = paint(1)
is = out.keys.map {|i| i[0]}
js = out.keys.map {|i| i[1]}
(js.min..js.max).to_a.reverse.each { |j|
  print (is.min..is.max).to_a.map { |i|
    out[[i, j]] == 0 ? ' ' : "\u2588".encode('utf-8')

  }.join
  print "\n"
}

