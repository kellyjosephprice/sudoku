require 'rake/testtask'
require 'benchmark'
require_relative 'lib/sudoku/generator'

task default: %w[spec]

Rake::TestTask.new do |t|
  t.name = "spec"
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

namespace :benchmark do
  task default: %w[easy]

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
    task k do 
      generator = Sudoku::Generator.new difficulty: v[:difficulty]
      rating_total = 0

      Benchmark.bm(15) do |x|
        x.report("#{k} (#{v[:count]}x):") do 
          v[:count].times do 
            generator.fill.dig

            generator.solver.grid = generator.grid
            generator.solver.solve

            rating_total += generator.rating
          end
        end
      end

      puts "average rating: #{(rating_total / v[:count]).round(2)}"
    end
  end
end

task bm: "benchmark:default"
