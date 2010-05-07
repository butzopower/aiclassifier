class KNN
  require 'lib/util'
  
  # training for knn is normally small
  # set rows and classes to variables
  # since we are comparing categories with the function
  #     catA - catB = sum_over_k( P(catA | k) - P(catB | k) )
  # we can calculate sum_over_k( P(cat | k) to make classifying quicker
  #
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

  # classify by getting the distance of the row we are trying to classify with
  # the rows from the training set
  # then take the k shortest distances associated with classes and weigh them 
  # inversely proportional to their distances, sum up for all relevant classes
  # and return the class with the highest value
  
  def classify(classifying_row, options = {})
    k = options.delete(:k) || 10
    distances = []
    @rows.each_with_index do |row, row_num|
      distance = Array.new(row.size)
      row.each_with_index do |elem, elem_num|
        if elem.is_a?(String) || elem.is_a?(CSV::Cell)  # if the element is categorical
          # distance = probability of category for row we are classifying minus
          # the probability of the category of the row we are measuring the
          # distance against
          distance[elem_num] = @cat_probs[elem_num][classifying_row[elem_num]] - @cat_probs[elem_num][elem] 
        else
          # if not categorical variable, then just subtract the value of the
          # classifying variable with the variable we are measuring against
          distance[elem_num] = classifying_row[elem_num].to_i - elem.to_i
        end
      end
      d = sum(distance.map{|x| x*x})  # dot(distance, distance)
      distances << [d, @classes[row_num]]
    end

    distances.sort.first(k).inject(Hash.new(0)) do |hash, distance|
      hash[distance.last] += 1.0 / distance.first # weigh the class at an inverse to it's distance
                                                  # if distance is 0, weight will be infinity
      hash
    end.to_a.sort_by(&:last).last.first           # sort by weight, return class with highest weight
  end

  # ruby doesn't have a sum method, but this is pretty simple
  def sum(array)
    array.inject(0){|sum, n| sum + n}
  end

  # use in interactive ruby to do a quick test of data set
  def test
    rows = Util.get_rows(:file => 'data/vehicles.csv', :n => 3000, :pre_process => true)
    classes = rows.transpose.last
    rows = rows.transpose[0..-2].transpose
    train(rows.first(2000), classes.first(2000))
    "#{classes.last} classified as #{classify(rows.last)}"
  end
end
