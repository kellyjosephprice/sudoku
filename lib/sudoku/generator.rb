require_relative '../sudoku'
require_relative '../sudoku/solver'
require_relative '../sudoku/grid'
require_relative 'grid'

class Sudoku::Generator
  attr_accessor :seeds, :difficulty, :grid

  DIFFICULTY = [
    {
      givens: 50,
      bounds: 5,
      search: 0,
      sequence: :random
    },
    {
      givens: 36,
      bounds: 4,
      search: 100,
      sequence: :random
    },
    {
      givens: 32,
      bounds: 3,
      search: 1000,
      sequence: :jumping
    },
    {
      givens: 28,
      bounds: 2,
      search: 10000,
      sequence: :wander
    },
    {
      givens: 22,
      bounds: 0,
      search: 100000,
      sequence: :normal
    }
  ]

  SEQUENCE = {
    random: Sudoku::Grid::ALL_ORDS.shuffle,
    normal: Sudoku::Grid::ALL_ORDS,
  }

  def initialize options = {}
    defaults = {
      seeds: 5,
      difficulty: 4,
    }
    config = defaults.merge(options)

    @seeds = config[:seeds]
    @difficulty = config[:difficulty]
    
    @solver = Sudoku::Solver.new 
  end

  def dig
    diggable = SEQUENCE[DIFFICULTY[difficulty][:sequence]]
    @solver.grid = grid

    until diggable.empty?
      ord = diggable.shift
      old = grid[ord]
      grid[ord] = nil

      if within_bounds? ord
        unless unique? ord, old
          grid[ord] = old
        end
      else
        grid[ord] = old
      end
    end

    self
  end

  def fill
    loop do
      @solver.grid = grid || Sudoku::Grid.new
      @solver.solve
      break unless @solver.unsolvable?
    end
    
    self.grid = @solver.solution
    self
  end
  
  def random_set count, &block
    set = Sudoku::Grid::ALL_ORDS.sample(count)

    count.times do |n|
      block.call(n, set[n])
    end

    set.first(count)
  end

  def seed 
    self.grid = Sudoku::Grid.new

    loop do
      grid.clear

      values = (1..81).to_a.map { |v| (v % 9) + 1 }.sample(seeds)
      random_set(seeds) do |n, ord|
        grid[ord] = values[n]
      end

      break if grid.valid?
    end

    self
  end

  def unique? ord, value
    nums = (1..9).to_a
    nums.slice!(value - 1)

    nums.all? do |n|
      begin
        grid[ord] = n
        @solver.solve
      rescue NonUniqueSolutionError
        grid[ord] = nil
        return false
      end

      grid[ord] = nil
      @solver.unsolvable?
    end
  end

  def within_bounds? ord
    return false if grid.all_empty.count < DIFFICULTY[difficulty][:givens]

    bounds = DIFFICULTY[difficulty][:bounds]
    return true if 0 == bounds
    
    row = grid.effected_row(ord)
    col = grid.effected_col(ord)

    [row, col].each do |set|
      actual = set.reject do |ord|
        grid[ord].nil?
      end.count

      return false if actual < bounds
    end 

    true
  end

end
