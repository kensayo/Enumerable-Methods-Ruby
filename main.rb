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

  def my_inject(*arg)

    if arg.empty?
      sum = arg[0]
      operator = :+
    elsif arg[0].is_a? Symbol
      operator = arg[0]
      sum = 0
    elsif arg[0].is_a? Integer && arg.size > 1
      sum = arg[0]
      operator arg[1]
    elsif arg[0].is_a? Integer
      sum = 0
      operator = :+
    end
    
    #if block_given? sum = ; puts var 
      proc = Proc.new { |num| sum = sum.send operator, num }      
    #else
    #  puts "No hay yield"
    #end

    my_each {|var| proc.call(var) unless block_given?}

    sum
  end
end

arr = [1,2,3,4,5,6,]
p arr.my_inject { |sum, n| sum + n }


#p 1.send(:method)
#p 4.send(:+,5)
