require_relative '../sudoku'
require_relative '../sudoku/solver'
require_relative '../sudoku/grid'

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
      sequence: :random
    }
  ]

  SEQUENCE = {
    random: Sudoku::Grid::ALL_ORDS.shuffle,
    normal: Sudoku::Grid::ALL_ORDS,
  }

  attr_accessor :difficulty, :grid, :solver, :seeds, :verbose

  def initialize options = {}
    defaults = {
      seeds: 10,
      difficulty: 1,
      verbose: false
    }
    config = defaults.merge(options)

    @seeds = config[:seeds]
    @difficulty = config[:difficulty]
    @solver = Sudoku::Solver.new
    @verbose = config[:verbose]
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
    solver.random = false
    diggable = sequence.dup
    filled = 81

    until diggable.empty? || filled == givens
      ord = get_next diggable
      old = grid[ord]
      grid[ord] = nil

      if within_bounds?(ord) && unique?(ord, old)
        filled -= 1
        output filled if verbose
      else 
        grid[ord] = old
      end
    end

    self
  end

  def get_next set
    set.sort_by! do |ord|
      Sudoku::Grid::EFFECTED_ORDS[ord].count do |other|
        grid[other]
      end
    end

    ord = set.shift
  end

  def fill
    loop do
      solver.random = true
      solver.grid = Sudoku::Grid.new
      solver.solve

      break unless solver.unsolved?
    end
    
    self.grid = solver.solution.shuffle!
    self
  end

  def output filled
    puts 
    puts grid
    puts " -- #{filled} -- "
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
