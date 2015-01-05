require_relative '../sudoku'
require_relative 'grid'

class Sudoku::Solver

  attr_accessor :grid, :solutions

  def initialize options = {}
    defaults = {}
    config = defaults.merge(options)

    @grid = config[:grid] || Sudoku::Grid.new
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
    cell = grid.first_empty
    return unless cell

    (1..9).to_a.shuffle.each do |n|
      grid[cell] = n

      next unless grid.valid_square?(cell)

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
