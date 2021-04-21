module Enumerable
  # my_each method
  def my_each
    to_a.size.times do |i|
      yield self[i]
    end
    self
  end

  # my_each_with_index
  def my_each_with_index
    to_a.size.times do |i|
      yield self[i], i
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
    my_each do |var|
      false unless yield var
    end
    true
  end
end


words = %w[bacon orang apple]

puts [].my_all? {|str| str.size == 5}
