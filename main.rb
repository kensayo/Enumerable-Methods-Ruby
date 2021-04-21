module Enumerable
  def my_each
    size.times do |i|
      yield self[i]
    end
  end
end
