module Enumerable
    def my_each
        (self.size).times do |i|
            yield self[i]
        end
    end

end
