require_relative '../sudoku'
require_relative 'grid'

require 'pp'
require 'pry'

class Sudoku::Solver

  attr_accessor :grid, :solution, :count, :random
  alias_method :random?, :random

  def initialize options = {}
    defaults = {
      random: true,
    }
    config = defaults.merge(options)

    @grid = config[:grid] || Sudoku::Grid.new
    @random = config[:random]
    @count = 0
  end

  def empty cells
    cells.each { |k,v| grid[k] = nil }
  end

  def fill_all 
    {}.tap do |constraints|
      grid.all_empty.each do |ord|
        values = grid.valid_values(ord)
        next unless 1 == values.count

        grid[ord] = values.first
        constraints[ord] = values.first
      end
    end
  end

  def grid= new_grid
    @grid = new_grid
    @solution = nil
    @count = 0
  end

  def solve
    @solution = nil
    @count = 0

    dfs

    solution
  end

  def solved?
    !!solution
  end

  def unsolved?
    solution.nil?
  end

  private

  def values ord
    random? ? grid.valid_values(ord).shuffle : grid.valid_values(ord)
  end
  
  def dfs
    ord = grid.minimum_remaining
    return if ord.nil?

    @count += 1

    values(ord).each do |n|
      break if solved?
      grid[ord] = n
      
      cons = fill_all

      if grid.complete?
        @solution = grid.dup 
      else 
        dfs
      end

      empty cons
    end

    grid[ord] = nil
  end

end
