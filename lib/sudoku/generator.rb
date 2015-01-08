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

  attr_accessor :difficulty, :grid, :solver

  def initialize options = {}
    defaults = {
      difficulty: 1,
    }
    config = defaults.merge(options)

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

      if within_bounds?(ord) && unique?
        filled -= 1
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

      break unless solver.unsolvable?
    end
    
    self.grid = solver.solution
    self
  end
  
  def random_set count, &block
    set = Sudoku::Grid::ALL_ORDS.sample(count)

    count.times do |n|
      block.call(n, set[n])
    end

    set.first(count)
  end

  def unique? 
    solver.solve
    solver.unique?
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
