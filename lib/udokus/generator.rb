class Udokus::Generator
  include Udokus::Generator::Difficulty

  attr_accessor :difficulty, :grid, :solver, :seeds, :verbose, :filled

  def initialize options = {}
    defaults = {
      seeds: 10,
      difficulty: 1,
      verbose: false
    }
    config = defaults.merge(options)

    @seeds = config[:seeds]
    @difficulty = config[:difficulty]
    @solver = Udokus::Solver.new
    @verbose = config[:verbose]
    @filled = 81
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

  def rating
    ((81 / @filled) * Math.log10(solver.count)).round(1)
  end

  def dig
    solver.grid = grid
    solver.random = false
    diggable = sequence.dup
    @filled = 81

    until diggable.empty? || filled == givens
      ord = get_next diggable
      old = grid[ord]
      grid[ord] = nil

      if within_bounds?(ord) && unique?(ord, old)
        @filled -= 1
        output if verbose
      else 
        grid[ord] = old
      end
    end

    self
  end

  def get_next set
    set.sort_by! do |ord|
      Udokus::Grid::EFFECTED_ORDS[ord].count do |other|
        grid[other]
      end
    end

    set.shift
  end

  def fill
    loop do
      solver.random = true
      solver.grid = Udokus::Grid.new
      solver.solve

      break unless solver.unsolved?
    end
    
    self.grid = solver.solution.shuffle!
    self
  end

  def output
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
    
    row = Udokus::Grid.effected_row(ord)
    col = Udokus::Grid.effected_col(ord)

    [row, col].each do |set|
      actual = set.reject do |ord|
        grid[ord].nil?
      end.count

      return false if actual < bounds
    end 

    true
  end
end
