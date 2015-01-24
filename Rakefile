require 'rake/testtask'
require 'benchmark'
require_relative 'lib/sudoku/generator'

task default: %w[spec]

Rake::TestTask.new do |t|
  t.name = "spec"
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

def run_benchmark name, difficulty, count
  generator = Sudoku::Generator.new difficulty: difficulty
  rating_total = 0

  Benchmark.bm(15) do |x|
    x.report("#{name} (#{count}x):") do 
      count.times do 
        generator.fill.dig

        generator.solver.grid = generator.grid
        generator.solver.solve

        rating_total += generator.rating
      end
    end
  end

  puts "average rating: #{(rating_total / count).round(2)}"
end

namespace :benchmark do
  desc "Run all the benchmarks"
  task default: %w[all]

  desc "Run all the benchmarks"
  task all: %w[boring easy medium hard insane]

  difficulties = {
    boring: {
      difficulty: 0,
      count: 1000
    },
    easy: {
      difficulty: 1,
      count: 1000
    },
    medium: {
      difficulty: 2,
      count: 500
    },
    hard: {
      difficulty: 3,
      count: 200
    },
    insane: {
      difficulty: 4,
      count: 100
    },
  }

  difficulties.each do |k, v|
    desc "Run the #{k} benchmarks"
    task k do 
      run_benchmark k, v[:difficulty], v[:count]
    end
  end
end

desc "Run the default benchmark"
task bm: "benchmark:default"
