require_relative '../sudoku'
require_relative '../sudoku/solver'
require_relative '../sudoku/grid'
require_relative 'grid'

class Sudoku::Generator
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

  attr_accessor :difficulty, :grid, :solver, :seeds

  def initialize options = {}
    defaults = {
      seeds: 10,
      difficulty: 1,
    }
    config = defaults.merge(options)

    @seeds = config[:seeds]
    @difficulty = config[:difficulty]
    @solver = Sudoku::Solver.new
  end

  def bounds 
    DIFFICULTY[difficulty][:bounds]
  end

  def givens 
    DIFFICULTY[difficulty][:givens]
  end
  
  def search 
    DIFFICULTY[difficulty][:search]
  end

  def sequence 
    SEQUENCE[DIFFICULTY[difficulty][:sequence]]
  end

  def dig
    solver.grid = grid
    diggable = sequence.dup
    filled = 81

    until diggable.empty? || filled == givens
      ord = diggable.shift
      old = grid[ord]
      grid[ord] = nil

      if within_bounds?(ord) && unique?(ord, old)
        filled -= 1
        puts grid
      else 
        grid[ord] = old
      end
    end

    self
  end

  def fill
    loop do
      solver.grid = Sudoku::Grid.new
      solver.solve

      break unless solver.unsolved?
    end
    
    self.grid = solver.solution
    self
  end
  
  def random_set count, &block
    Sudoku::Grid::ALL_ORDS.sample(count).each do |ord|
      block.call(ord)
    end
  end

  def seed
    Sudoku::Grid.new.tap do |grid|
      loop do
        random_set(seeds) do |ord|
          grid[ord] = grid.valid_values(ord).sample(1)
        end

        break if grid.valid?
        grid = Sudoku::Grid.new
      end
    end
  end

  def unique? ord, old
    !grid.valid_values(ord).any? do |value|
      next if value == old

      grid[ord] = value
      solver.solve
      grid[ord] = nil

      solver.solution
    end
  end

  def within_bounds? ord
    return false if grid.all_not_empty.count < givens
    return true if 0 == bounds
    
    row = Sudoku::Grid.effected_row(ord)
    col = Sudoku::Grid.effected_col(ord)

    [row, col].each do |set|
      actual = set.reject do |ord|
        grid[ord].nil?
      end.count

      return false if actual < bounds
    end 

    true
  end

end
