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
  def my_all? (args=nil)
    case args
    when Regexp
      to_a.my_each do |var|
        return false unless args.match(var)
      end
    when Class
      to_a.my_each do |var|
        return false unless var.instance_of?(args)
      end
    else  
    return true unless block_given?

    to_a.size.times do |i|
      return false unless yield to_a[i]
    end
    true
  end

  # my_any? Method
  def my_any?(args = nil)
    case args
    when Regexp
      to_a.my_each do |var|
        return true if args.match(var)
      end
    when Class
      to_a.my_each do |var|
        return true if var.instance_of?(args)
      end
    else
      return true unless block_given?

      to_a.my_each do |var|
        return true if yield var
      end
    end
    false
  end

  # my_none? Method
  def my_none?(args=nil)
    case args
    when Regexp
      to_a.my_each do |var|
        return false if args.match(var)
      end
    when Class
      to_a.my_each do |var|
        return false if var.instance_of?(args)
      end
    else  
    return false unless block_given?

    my_each do |var|
      return false if yield var
    end
    true
  end

  # my_count Method
  def my_count (num=nil)
    return to_a.size unless block_given?
    counter=0
    if num
      my_each do 
        |var| 
        if var == num
          counter+=1
        end
      end

    else
    my_each do |var|
      counter+=1 if yield var
    end
  end
    counter
  end

  # my_map Method
  def my_map
    return to_enum(:my_map) unless block_given?
    mp_new=[]
    my_each { |var| mp_new.push(yield(var))}
    mp_new
  end

end
