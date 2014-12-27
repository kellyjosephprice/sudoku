require 'rake/testtask'

task default: %w[spec]

Rake::TestTask.new do |t|
  t.name = "spec"
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end
