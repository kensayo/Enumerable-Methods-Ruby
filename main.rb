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

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
