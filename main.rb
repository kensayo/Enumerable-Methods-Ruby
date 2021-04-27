# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength, Style/ClassEqualityComparison
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

  def my_inject(arg1 = nil, arg2 = nil)
    if arg1.is_a?(Symbol) && !arg2
      base = to_a[0]
      1.upto(to_a.length - 1) { |item| base = base.send(arg1, to_a[item]) }
    elsif !arg1.is_a?(Symbol) && arg2.is_a?(Symbol)
      base = arg1
      0.upto(to_a.length - 1) { |item| base = base.send(arg2, to_a[item]) }
    elsif block_given? && arg1
      base = arg1
      to_a.my_each { |val| base = yield(base, val) }
    elsif block_given? && !arg1
      base = to_a[0]
      1.upto(to_a.length - 1) { |item| base = yield(base, to_a[item]) }
    elsif !block_given? && !arg1
      raise LocalJumpError
    else
      raise LocalJumpError, 'No block given'
    end
    base
  end

  def my_all?(args = nil)
    unless block_given?
      if args.instance_of?(Regexp)
        to_a.my_each { |var| return false unless args.match(var) }
        return true
      elsif args
        to_a.my_each { |var| return false unless my_instance_of(args, var) }
      end
      to_a.my_each { |var| return false unless var }
      return true
    end
    to_a.size.times { |i| return false unless yield to_a[i] }

    true
  end

  # my_any? Method
  def my_any?(args = nil)
    unless block_given?
      if args.instance_of?(Regexp)
        to_a.my_each { |var| return true if args.match(var) }
        return false
      elsif args
        to_a.my_each { |var| return true if my_instance_of(args, var) }
      end

      to_a.my_each { |var| return true if var == true }
      return false
    end
    to_a.my_each { |var| return true if yield var }
    false
  end

  # my_none? Method
  def my_none?(args = nil)
    unless block_given?
      if args.instance_of?(Regexp)
        to_a.my_each { |var| return false if args.match(var) }
        return true
      elsif args
        to_a.my_each { |var| return false if my_instance_of(args, var) }
      end
      to_a.my_each { |var| return false if var }
      return true
    end
    my_each { |var| return false if yield var }
    true
  end

  # my_count Method
  def my_count(num = nil)
    return to_a.size unless block_given?

    counter = 0
    if num
      my_each do |var|
        counter += 1 if var == num
      end

    else
      my_each do |var|
        counter += 1 if yield var
      end
    end
    counter
  end

  # my_map Method
  def my_map
    return to_enum(:my_map) unless block_given?

    mp_new = []
    my_each { |var| mp_new.push(yield(var)) }
    mp_new
  end

  def my_instance_of(args, var)
    return true if var.class == args || var.class.superclass == args

    false
  end
end
p 'all example' # ALL
# rubocop:disable Lint/AmbiguousBlockAssociation
p %w[anta bear cata].my_all? { |word| word.length >= 3 } #=> true
p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
p %w[cat cat cat].my_all?(/b/) #=> false
p [1, 2i, 5].my_all?(Numeric) #=> true
p [nil, true, 99].my_all? #=> false
p [].my_all? #=> true
p 'any examples' # ANY

p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
p %w[ant bear cat].my_any?(/d/) #=> false
p [nil, true, 99].my_any?(Integer) #=> true
p [nil, true, 99].my_any? #=> true
p [].my_any? #=> false
p 'none examples' # NONE
p %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
p %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
p %w[ant bear cat].my_none?(/d/) #=> true
p [1, 3.14, 42].my_none?(Float) #=> false
p [].my_none? #=> true
p [nil].my_none? #=> true
p [nil, false].my_none? #=> true
p [nil, false, true].my_none? #=> false
p 'count examples' # Count
ary = [1, 2, 4, 2]
p ary.count(&:even?) #=> 3
p ary.count #=>4
p ary.count(2) #=>2
p 'map examples' # MAP
p [1, 2, 3, 4].my_map { |i| i * i } #=> [1, 4, 9, 16]
p [1, 2, 3, 4].my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity,  Metrics/ModuleLength, Style/ClassEqualityComparison, Lint/AmbiguousBlockAssociation
