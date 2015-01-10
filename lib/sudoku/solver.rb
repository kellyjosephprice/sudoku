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

  def fill_all
    {}.tap do |constraints|
        grid.all_empty.each do |ord|
          values = grid.valid_values(ord)

          if 1 == values.count
            grid[ord] = values.first
            constraints[ord] = values.first
          end
        end
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

      cons = fill_all

      if grid.complete?
        solutions << grid.dup 
      else 
        dfs
      end

      empty cons
    end

    grid[ord] = nil
  end

end
