#! /usr/bin/env ruby

require 'udokus'

filename = ARGV.shift

grid = Udokus::Grid.from_s(IO.read(filename), '')
solver = Udokus::Solver.new(grid: grid)

puts solver.solve
