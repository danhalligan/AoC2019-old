require 'set'

map = File.open('map1.txt').read.split("\n")

orbits = {}

map.each do |m|
  o = m.split(')')
  planet = o[0]
  orbiter = o[1]
  orbits[orbiter] = Set.new([planet, orbits[planet].to_a].flatten.compact)

  orbits.each do |orb, p|
    if p.include?(orbiter)
      orbits[orb].merge([planet, orbits[planet].to_a].flatten.compact)
    end
  end
end

# Part 1:
puts(orbits.values.inject(0) { |sum, p| sum += p.length })
