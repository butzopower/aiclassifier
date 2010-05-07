require 'lib/naive_bayes'

namespace :nb do
  task :tictactoe do
    nb = NaiveBayes.new
    rows = Util.get_rows(:file => 'data/tic-tac-toe.data', :n => 500)
    train_rows = rows.first(400)
    train_classes = train_rows.transpose.last
    train_rows = train_rows.transpose[0..-2].transpose

    nb.train(train_rows, train_classes)

    num_correct = 0
    rows.last(100).each do |row|
      r = row[0..-2]
      c = row.last
      classified = nb.classify(r)
      puts "#{row.join(',')} - Classified as: #{classified.first}"
      num_correct += 1 if c == classified.first
    end

    puts "Accuracy: #{num_correct} / 100 (#{num_correct / 100.0})"
  end

  task :vehicles do
    nb = NaiveBayes.new
    rows = Util.get_rows(:file => 'data/vehicles.csv', :n => 5000, :pre_process => true)
    train_rows = rows.first(4000)
    train_classes = train_rows.transpose.last
    train_rows = train_rows.transpose[0..-2].transpose

    nb.train(train_rows, train_classes)

    num_correct = 0
    same_class_rows = rows.last(1000).select{|x| x.last == "12FDEW6"}
    same_class_rows.each do |row|
      r = row[0..-2]
      c = row.last
      classified = nb.classify(r)
      puts "#{row.join(',')} - Classified as: #{classified.first}"
      num_correct += 1 if c == classified.first
    end

    puts "Accuracy: #{num_correct} / #{same_class_rows.size} (#{num_correct / (same_class_rows.size * 1.0)})"

  end
end


