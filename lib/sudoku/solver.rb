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

    reset_counts
  end

  def grid= new_grid
    @grid = new_grid
    @solutions = []
    reset_counts
  end

  def minimum_remaining
    grid.all_empty.max_by do |ord|
      @counts[ord]
    end
  end

  def reset_counts
    @counts = Hash.new(0)
    grid.all_not_empty.each do |ord|
      grid.effected_sets(ord) do |other|
        @counts[other] += 1
      end
    end
  end

  def set ord, value
    if grid[ord].nil? && value
      grid.effected_sets(ord) do |other|
        @counts[other] += 1
      end
    elsif value.nil? && grid[ord]
      grid.effected_sets(ord) do |other|
        @counts[other] -= 1
      end
    end

    grid[ord] = value
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
    cell = (32 > grid.all_empty.count) ? minimum_remaining : grid.first_empty
    return unless cell

    (1..9).select do |n|
      grid[cell] = n
      grid.valid_square?(cell)
    end.shuffle.each do |n|
      set cell, n

      if grid.complete?
        solutions << grid.dup 
        raise NonUniqueSolutionError unless unique?
        break
      end

      dfs
    end

    set cell, nil
  end

end

class NonUniqueSolutionError < RuntimeError
end
