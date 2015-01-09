require_relative '../sudoku'
require_relative 'grid'

require 'pp'
require 'pry'

class Sudoku::Solver

  attr_accessor :grid, :solutions, :counts, :random
  alias_method :random?, :random

  def initialize options = {}
    defaults = {
      random: true
    }
    config = defaults.merge(options)

    @grid = config[:grid] || Sudoku::Grid.new
    @solutions = []
    @random = config[:random]
  end

  def empty cells
    cells.each { |k,v| grid[k] = nil }
  end

  def fill cells
    cells.each { |k,v| grid[k] = v.first }
  end

  def fill_all
    {}.tap do |constraints|
      loop do
        more = find_constraints
        break if more.empty?

        constraints.merge! more
        fill more
      end
    end
  end

  def find_constraints
    grid.all_empty.each_with_object({}) do |ord, h|
      h[ord] = grid.valid_values(ord)
    end.select do |k, v|
      v.count == 1
    end
  end

  def grid= new_grid
    @grid = new_grid
    @solutions = []
  end

  def solve
    @solutions = []

    dfs

    solution
  end

  def solution 
    solutions.first
  end

  def unique?
    solutions.count == 1
  end

  def unsolved?
    solutions.empty?
  end

  private

  def values ord
    random? ? grid.valid_values(ord).shuffle : grid.valid_values(ord)
  end
  
  def dfs
    ord = grid.minimum_remaining
    return if ord.nil?

    values(ord).each do |n|
      break if solution
      grid[ord] = n

      constraints = fill_all

      if grid.complete?
        solutions << grid.dup 
      else 
        dfs
      end

      empty constraints
    end

    grid[ord] = nil
  end

end
