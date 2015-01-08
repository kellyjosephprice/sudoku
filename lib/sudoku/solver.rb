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
    @grid = @grid.dup

    begin
      dfs
    rescue NonUniqueSolutionError
    end 

    solution
  end

  def solution 
    solutions.first
  end

  def unique?
    solutions.count == 1
  end

  def unsolvable?
    solutions.empty?
  end

  private
  
  def dfs
    cell = grid.minimum_remaining
    return if cell.nil?

    (1..9).select do |n|
      grid[cell] = n
      grid.valid_square? cell
    end.shuffle.each do |n|
      grid[cell] = n

      if grid.complete?
        solutions << grid.dup 
        raise NonUniqueSolutionError unless unique?
        break
      end

      dfs
    end

    grid[cell] = nil
  end

end

class NonUniqueSolutionError < RuntimeError
end
