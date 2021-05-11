require 'spec_helper'
require_relative '../main'

def traversal_empty(method, model, arg = nil, &block)
  my_args = [method]
  std_args = [model]
  if arg
    my_args.push(arg)
    std_args.push(arg)
  end
  context 'when working on empty Enumerables, with block' do
    it 'on Array' do
      my_result = [].send(*my_args, &block)
      std_result = [].send(*std_args, &block)
      expect(my_result).to eq(std_result)
    end

    it 'on Hash' do
      my_result = {}.send(*my_args, &block)
      std_result = {}.send(*std_args, &block)
      expect(my_result).to eq(std_result)
    end
  end
end

def traversal_tests(method, model, examples, blocks, arg = nil)
  context 'when working on nonempty Enumerables, with block' do
    let(:examples) { examples }
    let(:blocks) { blocks }
    examples.each do |structure, example|
      it "on #{structure.to_s.capitalize}" do
        my_result = example.send(method, &blocks[structure])
        std_result = example.send(model, &blocks[structure])
        expect(my_result).to eq(std_result)
      end
    end
  end
  traversal_empty(method, model, arg, &blocks[:array])
end

examples = { array: [1, 2, 3, 4, 5],
             hash: { developer: 'Kenny', fruit: 'Apple', dog: 'Serú' },
             range: (1..10) }
blocks = { array: proc { |n| n > 2 },
           hash: proc { |_, val| val == 'Apple' },
           range: proc { |n| n > 2 } }

RSpec.describe 'Enumerable methods tests' do
  let(:array) { examples[:array] }
  let(:hash) { examples[:hash] }
  let(:range) { examples[:range] }
  let(:examples) { examples }

  describe '#my_each_with_index replicates #each_with_index' do
    context 'when working on nonempty Enumerables' do
      examples.each do |structure, example|
        it "on #{structure.to_s.capitalize}" do
          my_result = []
          example.my_each_with_index { |val, i| my_result.push([val, i]) }
          std_result = []
          example.each_with_index { |val, i| std_result.push([val, i]) }
          expect(my_result).to eq(std_result)
        end
      end
    end

    context 'when Enumerables are empty' do
      it 'on Array' do
        my_result = []
        [].my_each_with_index { |val, i| my_result.push([val, i]) }
        std_result = []
        [].each_with_index { |val, i| std_result.push([val, i]) }
        expect(my_result).to eq(std_result)
      end

      it 'on Hash' do
        my_result = []
        {}.my_each_with_index { |val, i| my_result.push([val, i]) }
        std_result = []
        {}.each_with_index { |val, i| std_result.push([val, i]) }
        expect(my_result).to eq(std_result)
      end
    end

    it 'check Enumerator when no block given' do
      len = array.length
      my_enum_arr = array.my_each_with_index.take(len)
      std_enum_arr = array.each_with_index.take(len)
      expect(my_enum_arr).to eq(std_enum_arr)
    end
  end

  describe '#my_each replicates #each' do
    context 'when working on nonempty Enumerables' do
      examples.each do |structure, example|
        it "on #{structure.to_s.capitalize}" do
          my_result = []
          example.my_each { |val| my_result.push(val) }
          std_result = []
          example.each { |val| std_result.push(val) }
          expect(my_result).to eq(std_result)
        end
      end
    end

    context 'when Enumerables are empty' do
      it 'on Array' do
        my_result = []
        [].my_each { |val| my_result.push(val) }
        std_result = []
        [].each { |val| std_result.push(val) }
        expect(my_result).to eq(std_result)
      end

      it 'on Hash' do
        my_result = []
        {}.my_each { |val| my_result.push(val) }
        std_result = []
        {}.each { |val| std_result.push(val) }
        expect(my_result).to eq(std_result)
      end
    end

    it 'check Enumerator when no block given' do
      len = array.length
      my_enum_arr = array.my_each.take(len)
      std_enum_arr = array.each.take(len)
      expect(my_enum_arr).to eq(std_enum_arr)
    end
  end

  describe '#my_select replicates #select' do
    traversal_tests(:my_select, :select, examples, blocks)

    it 'check Enumerator when no block given' do
      len = array.length
      my_enum_arr = array.my_select.take(len)
      std_enum_arr = array.select.take(len)
      expect(my_enum_arr).to eq(std_enum_arr)
    end
  end

  describe '#my_inject replicates #inject' do
    inject_blocks = { array: proc { |acc, val| acc + val },
                      hash: proc { |acc, val| acc.push(val[1]) },
                      range: proc { |acc, n| acc * n } }
    traversal_tests(:my_inject, :inject, examples, inject_blocks, 0)

    context 'Behavior depends on the argument' do
      it 'with an initial value' do
        my_result = array.my_inject(5) { |acc, v| acc + v }
        std_result = array.inject(5) { |acc, v| acc + v }
        expect(my_result).to eq(std_result)
      end

      it 'with symbol' do
        my_result = array.my_inject(5, :+)
        std_result = array.inject(5, :+)
        expect(my_result).to eq(std_result)
      end

      it 'with symbol and block' do
        my_result = array.my_inject(5, :*) { |acc, v| acc + v }
        std_result = array.inject(5, :*) { |acc, v| acc + v }
        expect(my_result).to eq(std_result)
      end
    end

    it '#multiply_els' do
      expect(multiply_els(array)).to eq(120)
    end
  end

  describe '#my_all? replicates #all?' do
    let(:bool_true) { [true, true, true, true] }
    let(:bool_false) { [false, true, true] }
    let(:pattern_true) { %w[avocado palta aguacate] }
    let(:pattern_false) { %w[letter word sentence] }
    let(:class_true) { [1, 2, 3, 4] }
    let(:class_false) { [1, 2, 3, 'a'] }

    traversal_tests(:my_all?, :all?, examples, blocks)

    context 'When result is true' do
      it 'on Boolean array' do
        expect(bool_true.my_all?).to eq(bool_true.all?)
      end
      it 'with pattern as argument' do
        expect(pattern_true.my_all?(/a/)).to eq(pattern_true.all?(/a/))
      end
      it 'with class argument' do
        expect(class_true.my_all?(Numeric)).to eq(class_true.all?(Numeric))
      end
      it 'with value argument' do
        expect(bool_true.my_all?(true)).to eq(bool_true.all?(true))
      end
    end

    context 'When result is false' do
      it 'on Boolean array' do
        expect(bool_false.my_all?).to eq(bool_false.all?)
      end
      it 'with pattern as argument' do
        expect(pattern_false.my_all?(/t/)).to eq(pattern_false.all?(/t/))
      end
      it 'with class argument' do
        expect(class_false.my_all?(Numeric)).to eq(class_false.all?(Numeric))
      end
      it 'with value argument' do
        expect(bool_false.my_all?(true)).to eq(bool_false.all?(true))
      end
    end
  end

  describe '#my_any? replicates #any?' do
    let(:bool_true) { [true, false, true, false] }
    let(:bool_false) { [false, false, false] }
    let(:pattern_true) { %w[avocado palta aguacate] }
    let(:pattern_false) { %w[letter word sentence] }
    let(:class_true) { [1, 'b', 3, 'a'] }
    let(:class_false) { [1, 2, 3, 4] }

    traversal_tests(:my_any?, :any?, examples, blocks)

    context 'When result is true' do
      it 'on Boolean array' do
        expect(bool_true.my_any?).to eq(bool_true.any?)
      end
      it 'with pattern as argument' do
        expect(pattern_true.my_any?(/d/)).to eq(pattern_true.any?(/d/))
      end
      it 'with class argument' do
        expect(class_true.my_any?(Numeric)).to eq(class_true.any?(Numeric))
      end
      it 'with value argument' do
        expect(bool_true.my_any?(true)).to eq(bool_true.any?(true))
      end
    end

    context 'When result is false' do
      it 'on Boolean array' do
        expect(bool_false.my_any?).to eq(bool_false.any?)
      end
      it 'with pattern as argument' do
        expect(pattern_false.my_any?(/a/)).to eq(pattern_false.any?(/a/))
      end
      it 'with class argument' do
        expect(class_false.my_any?(String)).to eq(class_false.any?(String))
      end
      it 'with value argument' do
        expect(bool_false.my_any?(true)).to eq(bool_false.any?(true))
      end
    end
  end

  describe '#my_none? replicates #none?' do
    let(:bool_true) { [false, false, false] }
    let(:bool_false) { [true, false, true, false] }
    let(:pattern_true) { %w[letter word sentence] }
    let(:pattern_false) { %w[avocado palta aguacate] }
    let(:class_true) { [1, 2, 3, 4] }
    let(:class_false) { [1, 'b', 3, 'a'] }

    traversal_tests(:my_none?, :none?, examples, blocks)

    context 'When result is true' do
      it 'on Boolean array' do
        expect(bool_true.my_none?).to eq(bool_true.none?)
      end
      it 'with pattern as argument' do
        expect(pattern_true.my_none?(/d/)).to eq(pattern_true.none?(/d/))
      end
      it 'with class argument' do
        expect(class_true.my_none?(Numeric)).to eq(class_true.none?(Numeric))
      end
      it 'with value argument' do
        expect(bool_true.my_none?(true)).to eq(bool_true.none?(true))
      end
    end

    context 'When result is false' do
      it 'on Boolean array' do
        expect(bool_false.my_none?).to eq(bool_false.none?)
      end
      it 'with pattern as argument' do
        expect(pattern_false.my_none?(/a/)).to eq(pattern_false.none?(/a/))
      end
      it 'with class argument' do
        expect(class_false.my_none?(String)).to eq(class_false.none?(String))
      end
      it 'with value argument' do
        expect(bool_false.my_none?(true)).to eq(bool_false.none?(true))
      end
    end
  end

  describe '#my_count replicates #count' do
    traversal_tests(:my_count, :count, examples, blocks)

    it 'with value as argument' do
      expect(array.my_count(1)).to eq(array.count(1))
    end
    it 'without arguement' do
      expect(array.my_count).to eq(array.count)
    end
  end

  describe '#my_map replicates #map' do
    traversal_tests(:my_map, :map, examples, blocks)

    it 'with proc as an argument' do
      expect(array.my_map(blocks[:array])).to eq([false, false, true, true, true])
    end
    it 'check Enumerator when no block given' do
      len = array.length
      my_enum_arr = array.my_map.take(len)
      std_enum_arr = array.my_map.take(len)
      expect(my_enum_arr).to eq(std_enum_arr)
    end
  end
end
