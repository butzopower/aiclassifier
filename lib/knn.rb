class KNN
  require 'lib/util'
  require 'rubygems'
  require 'ruby-debug'
  
  def train(rows, classes)
    @rows = rows
    @classes = classes
    @table = (rows.transpose + [classes]).transpose
    @cat_probs = Array.new(rows.transpose.size) { Hash.new(0) }
    
    # calculate the sum over all classes the probability of a category value
    # belonging to a class
    
    @classes.uniq.each do |c| # for every class
      rows_for_class = @table.select{|row| row.last == c} # select the rows for that class
      rows_for_class.transpose[0..-2].each_with_index do |row, i|
        next unless row.first.is_a?(String)              # if it's not a string, don't do anything
        counts = row.group_by{|x| x}                      # group by the values
        counts.each_pair do |category, group|             
          # the group size will be the count, divide it by the number of rows
          # for that class to get the probability that that category belongs to
          # that class
          @cat_probs[i][category] += group.size / (rows_for_class.size * 1.0)
        end
      end
    end

  end

  def classify(row)
    distances = []
    @rows.each do |row|

    end
  end

  def sum(array)
    array.inject(0){|sum, n| sum + n}
  end

  def test
    rows = Util.get_rows(:file => 'data/vehicles.csv', :n => 1000, :pre_process => true)
    classes = rows.transpose.last
    rows = rows.transpose[0..-2].transpose
    train(rows, classes)
  end
end
