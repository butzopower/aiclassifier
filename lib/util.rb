class Util
  require 'csv'

  # this method with get a random :n rows from a cvs :file
  # can also pass :pre_process option
  def self.get_rows(options={})
    file_name = options.delete(:file)
    n = options.delete(:n)
    pre_process = options.delete(:pre_process) || false
    rows = []

    # read all the rows of the CSV and put them in our array
    CSV::Reader.parse(File.open(file_name)) do |row|
      rows << row
    end

    # grab all the rows excluding the first, since it might be the column names
    # ( we can afford this since are most likely working with larger data sets )
    # shuffle around the data we have and grab the first n rows
    rows = rows[1..-1].shuffle.first(n)

    pre_process ? self.pre_process(rows) : rows # ruby returns the last evaluation of a method
  end

  def self.pre_process(rows)
    rows.transpose.each do |row| # transpose the table to make the columns into rows
      case row.first             # check the form of the first element in the column
      when /^\d+\.\d+$/          # if it's a real number
        row.map!(&:to_f)         #    convert every element in the column to a float
      when /^\d+$/               # if it's a integer
        row.map!(&:to_i)         #    map every element in the column to an int
      end                        # otherwise do nothing
    end.transpose                # transpose back
  end

end
