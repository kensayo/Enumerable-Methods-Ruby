module Enumerable
  # my_each method
  def my_each
    return to_enum(:my_each) unless block_given?    
    to_a.size.times do |i|
      yield to_a[i]
    end
    self
  end

  # my_each_with_index
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    to_a.size.times do |i|
      yield self.to_a[i], i
    end
    self
  end

  # my_select method
  def my_select
    arr = []
    to_a.size.times do |i|
      arr.push(self[i]) if yield self[i]
    end
    arr
  end

  # my_all? method
  def my_all?    
    to_a.size.times do |i|
      if !yield self.to_a[i]
        return false
      end
    end
    true
  end

end

