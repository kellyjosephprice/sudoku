require_relative '../sudoku'
require_relative 'grid'

require 'pp'
require 'pry'

class Sudoku::Solver

  attr_accessor :grid, :solutions, :counts

  def initialize options = {}
    defaults = {}
    config = defaults.merge(options)

    @grid = config[:grid] || Sudoku::Grid.new
    @solutions = []
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
  
  def dfs
    cell = grid.first_empty
    return if cell.nil?

    grid.valid_values(cell).shuffle.each do |n|
      break if solution
      grid[cell] = n

      if grid.complete?
        solutions << grid.dup 
        break
      end

      dfs
    end

    grid[cell] = nil
  end

end
