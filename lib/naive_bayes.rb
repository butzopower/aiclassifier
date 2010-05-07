class NaiveBayes
  require 'rubygems'
  require 'ruby-debug'
  require 'lib/util'
  # need to make continuous variables discrete
  def train(rows, classes)
    @classes = Hash.new
    raise 'rows and classes need to be the same size' unless rows.size == classes.size

    # for each unique class, set the key in @classes for that class to an array
    # of empty hashes (with default values of 1 for the psuedocount)
    # the number of hashes in the array is equal to the number of elements in a row
    classes.uniq.each { |c| @classes[c] = Array.new(rows.first.size){ Hash.new(0) }}

    rows.each_with_index do |row, row_num| 
      row.each_with_index do |elem, elem_num|
        @classes[classes[row_num]][elem_num][elem] += 1
      end
    end
    @classes
  end

  def classify(row)
    # find the total number of instances of the class by summing the counts of each
    # item in the first element
    counts = Hash.new
    @classes.each_key do |c|
      counts[c] = sum(@classes[c].first.values)
    end

    # find P(C) by setting the number of instances of the class over the total number of instances
    probs = Hash.new
    counts.each_key do |c|
      probs[c] = counts[c] / (sum(counts.values) * 1.0)
    end

    # find the product of P(fi | C)
    row.each_with_index do |elem, elem_num|
      @classes.keys.each do |c|
        probs[c] *= (@classes[c][elem_num][elem] / (counts[c] * 1.0))
      end
    end

    # sort by the probability, reverse, and give us the first class and the prob it was
    probs.to_a.sort_by(&:last).reverse.first
  end

  def test
    rows = Util.get_rows(:file => 'data/tic-tac-toe.data', :n => 100)
    classes = rows.transpose.last
    rows = rows.transpose[0..-2].transpose
    train(rows, classes)
  end

  def sum(array)
    array.inject(0){|sum, n| sum + n}
  end
end
