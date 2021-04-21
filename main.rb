module Enumerable
  def my_each
    size.times do |i|
      yield self[i]
    end
  end

  def my_each_with_index
    size.times do |i|
      yield self[i], i
    end
  end
end
