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
  def my_all?(args = nil)
    case args
    when Regexp
      to_a.my_each { |var| return false unless args.match(var) }

    when Class
      to_a.my_each { |var| return false unless var.class.superclass == args || var.instance_of?(args) }
    else
      unless block_given?
        to_a.my_each { |var| return false unless var }
        return true
      end

      to_a.size.times { |i| return false unless yield to_a[i] }
    end
    true
  end

  # my_any? Method
  def my_any?(args = nil)
    case args
    when Regexp
      to_a.my_each { |var| return true if args.match(var) }
    when Class
      to_a.my_each { |var| return true if var.class.superclass == args || var.instance_of?(args) }
    else
      unless block_given?
        to_a.my_each { |var| return true if var == true }
        return false
      end

      to_a.my_each { |var| return true if yield var }
    end
    false
  end

  # my_none? Method
  def my_none?(args = nil)
    case args
    when Regexp
      to_a.my_each do |var|
        my_regexp(false, var)
      end
    when Class
      to_a.my_each { |var| return false if var.class.superclass == args || var.instance_of?(args) }
    else
      unless block_given?
        to_a.my_each { |var| return false if var }
        return true
      end

      my_each { |var| return false if yield var }
    end
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

  def my_regexp(xav, var)
    return xav if args.match(var)
  end
  p 'hello world'
end
