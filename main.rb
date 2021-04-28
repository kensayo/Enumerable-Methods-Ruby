# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength
module Enumerable
  # my_each Method
  def my_each
    return to_enum(:my_each) unless block_given?

    to_a.size.times do |i|
      yield to_a[i]
    end
    self
  end

  # my_each_with_index Method
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    to_a.size.times do |i|
      yield to_a[i], i
    end
    self
  end

  # my_select Method
  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    to_a.size.times do |i|
      arr.push(to_a[i]) if yield to_a[i]
    end
    return arr.to_h if is_a? Hash

    arr
  end

  # my_inject Method
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

  # my_all? Method
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

def multiply_els(arr)
  arr.my_inject(:*)
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity,  Metrics/ModuleLength
