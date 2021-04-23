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
      yield to_a[i], i
    end
    self
  end

  # my_select method
  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    to_a.size.times do |i|
      arr.push(to_a[i]) if yield to_a[i]
    end
    return arr.to_h if is_a? Hash

    arr
  end

  # my_all? method
  def my_all?
    return true unless block_given?

    to_a.size.times do |i|
      return false unless yield to_a[i]
    end
    true
  end

  def my_any?
    return true unless block_given?    
    my_each do |var|
     return true if yield var
    end
    false
  end

  def my_none?
    return false unless block_given?  
    my_each do |var|
     return false if yield var
    end
    true
  end

  def my_count
    counter=0
    my_each do |var|
      counter+=1 if yield var
    end
    counter
  end
end
