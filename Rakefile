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

  task all: %w[easy hard]

  task :easy do
    n = 1000
    generator = Sudoku::Generator.new difficulty: 1

    Benchmark.bm(14) do |x|
      x.report("level 2 (#{n}x):") do 
        n.times { generator.fill.dig }
      end
    end
  end

  task :hard do
    n = 100
    generator = Sudoku::Generator.new difficulty: 4

    Benchmark.bm(13) do |x|
      x.report("level 5 (#{n}x):") do 
        n.times { generator.fill.dig }
      end
    end
  end
end

task bm: "benchmark:default"
