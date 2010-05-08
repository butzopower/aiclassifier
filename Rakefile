require 'lib/naive_bayes'
require 'lib/knn'

def generic_tic_tac_toe(klass, file, n, output_lines = true)
  classifier = klass.new
  rows = Util.get_rows(:file => file, :n => n)
  train_rows = rows.first((n * 80) / 100)
  train_classes = train_rows.transpose.last
  train_rows = train_rows.transpose[0..-2].transpose

  classifier.train(train_rows, train_classes)

  num_correct = 0
  rows.last((n * 20) / 100).each do |row|
    r = row[0..-2]
    c = row.last
    classified = classifier.classify(r)
    puts "#{row.join(',')} - Classified as: #{classified.first}" if output_lines
    num_correct += 1 if c == classified.first
  end

  puts "Accuracy: #{num_correct} / 100 (#{num_correct / 100.0})"
  num_correct / 100.0
end

def generic_vehicles(klass, file, n, k, output_lines = true)
  nb = klass.new
  rows = Util.get_rows(:file => file, :n => n, :pre_process => true)
  train_rows = rows.first((n * 80) / 100)
  train_classes = train_rows.transpose.last
  train_rows = train_rows.transpose[0..-2].transpose

  nb.train(train_rows, train_classes)

  num_correct = 0
  same_class_rows = rows.last((n * 20) / 100).select{|x| x.last == k}
  same_class_rows.each do |row|
    r = row[0..-2]
    c = row.last
    classified = nb.classify(r)
    puts "#{row.join(',')} - Classified as: #{classified.first}" if output_lines
    num_correct += 1 if c == classified.first
  end

  puts "Accuracy: #{num_correct} / #{same_class_rows.size} (#{num_correct / (same_class_rows.size * 1.0)})"
  num_correct / (same_class_rows.size * 1.0)
end

namespace :nb do
  task :tictactoe do
    generic_tic_tac_toe(NaiveBayes, 'data/tic-tac-toe.data', 500)
  end

  task :tictactoe100fold do
    sum = 0
    percents = []
    100.times do |i|
      percent = generic_tic_tac_toe(NaiveBayes, 'data/tic-tac-toe.data', 500, false)
      percents << percent
      sum += percent
    end
    
    puts "Percents: (#{percents.sort.join(',')})"
    puts "Min: #{percents.min}"
    puts "Max: #{percents.max}"
    puts "Mean: #{sum / 100.0}"

  end

  task :vehicles do
    generic_vehicles(NaiveBayes, 'data/vehicles.csv', 5000, '12FDEW6')
  end

  task :vehicles20fold do
    sum = 0
    percents = []
    20.times do |i|
      percent = generic_vehicles(NaiveBayes, 'data/vehicles.csv', 5000, '12FDEW6', false)
      percents << percent
      sum += percent
    end
    
    puts "Percents: (#{percents.sort.join(',')})"
    puts "Min: #{percents.min}"
    puts "Max: #{percents.max}"
    puts "Mean: #{sum / 20.0}"

  end
end

namespace :knn do
  task :tictactoe do
    generic_tic_tac_toe(KNN, 'data/tic-tac-toe.data', 500)
  end

  task :tictactoe100fold do
    sum = 0
    percents = []
    100.times do |i|
      percent = generic_tic_tac_toe(KNN, 'data/tic-tac-toe.data', 500, false)
      percents << percent
      sum += percent
    end
    
    puts "Percents: (#{percents.sort.join(',')})"
    puts "Min: #{percents.min}"
    puts "Max: #{percents.max}"
    puts "Mean: #{sum / 100.0}"

  end

  task :vehicles do
    generic_vehicles(KNN, 'data/vehicles.csv', 5000, '12FDEW6')
  end

  task :vehicles20fold do
    sum = 0
    percents = []
    20.times do |i|
      percent = generic_vehicles(KNN, 'data/vehicles.csv', 5000, '12FDEW6', false)
      percents << percent
      sum += percent
    end
    
    puts "Percents: (#{percents.sort.join(',')})"
    puts "Min: #{percents.min}"
    puts "Max: #{percents.max}"
    puts "Mean: #{sum / 20.0}"

  end
end
