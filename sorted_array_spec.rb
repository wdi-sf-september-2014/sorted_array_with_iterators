require 'rspec'
require './sorted_array.rb'
require 'pry'

shared_examples "yield to all elements in sorted array" do |method|
    specify do 
      expect do |b| 
        sorted_array.send(method, &b) 
      end.to yield_successive_args(2,3,4,7,9) 
    end
end

describe SortedArray do
  let(:source) { [2,3,4,7,9] }
  let(:sorted_array) { SortedArray.new source }

  describe 'initialize' do
    it 'can be instantiated' do
      sorted_array = SortedArray.new
      expect(sorted_array.class).to eq(SortedArray)
    end
    it 'can be given an array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      expect(sorted_array.size).to eq(source.size)
    end
    it 'is sorted if initialized with an array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      expect(sorted_array[0...5]).to eq(source.sort)
    end
  end

  describe '#[]' do
    before do
      @source = [2,3,4,7,9]
      @sorted_array = SortedArray.new
      @sorted_array.internal_arr = @source
    end

    it 'indexes an element' do
      expect(@sorted_array[2]).to eq(4)
    end

    it 'gives nil for an out of range element' do
      expect(@sorted_array[10]).to be_nil
    end

    it 'indexes a range' do
      expect(@sorted_array[1..3]).to eq(@source[1..3])
    end
  end

  describe '#size' do
    it 'gives the size of []' do
      sorted_array = SortedArray.new
      expect(sorted_array.size).to eq(0)
    end
    it 'works with a starter array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      expect(sorted_array.size).to eq(source.size)
    end
  end
  describe '#add' do
    before do
      @source = [4,7,3,9,2]
      @sorted_array = SortedArray.new(@source)
    end
    it 'can add an element' do
      @sorted_array.add(4)
      expect(@sorted_array.size).to eq(@source.size + 1)
    end
    it 'adds in the correct location' do
      @sorted_array.add(1)
      @sorted_array.add(10)
      expect(@sorted_array[-1]).to eq(10)
      expect(@sorted_array[0]).to eq(1)
    end
  end

  describe '#first_larger_index' do
    before do
      @source = [2,3,4,7,9]
      @sorted_array = SortedArray.new
      @sorted_array.internal_arr = @source
    end

    it 'gives 0 for an empty array' do
      @sorted_array.internal_arr = []
      expect(@sorted_array.first_larger_index(4)).to eq(0)
    end

    it 'can pick before or after a single element' do
      @sorted_array.internal_arr = [5]
      expect(@sorted_array.first_larger_index(4)).to eq(0)
      expect(@sorted_array.first_larger_index(6)).to eq(1)
    end

    it 'can pick before, after or between two elements' do
      @sorted_array.internal_arr = [5,7]
      expect(@sorted_array.first_larger_index(4)).to eq(0)
      expect(@sorted_array.first_larger_index(6)).to eq(1)
      expect([1,2].include?(@sorted_array.first_larger_index(7))).to eq(true) 
      expect(@sorted_array.first_larger_index(8)).to eq(2)
    end

    it 'can put an existing element on either side' do
      @sorted_array.internal_arr = [5]
      expect([0,1].include?(@sorted_array.first_larger_index(5))).to eq(true) 
    end

    it 'gives 0 for a new smallest' do
      expect(@sorted_array.first_larger_index(-4)).to eq(0)
    end

    it 'gives the last index for a new largest' do
      expect(@sorted_array.first_larger_index(10)).to eq(@sorted_array.size)
    end
    it 'gives the right location' do
      expect(@sorted_array.first_larger_index(5)).to eq(3)
    end
  end

  describe '#index' do
    before do
      @source = ["Crisis","Balderdash","Masticate","Xanadu","Lemur"]
      # ["Balderdash", "Crisis", "Lemur", "Masticate", "Xanadu"]
      @sorted_array = SortedArray.new(@source)
    end
    it 'finds the middle item' do
      expect(@sorted_array.index("Lemur")).to eq(2)
    end
    it 'finds an item in the left half' do
      expect(@sorted_array.index("Crisis")).to eq(1)
    end
    it 'finds the last item' do
      expect(@sorted_array.index("Xanadu")).to eq(4)
    end
    it 'returns nil for an item not in the array' do
      expect(@sorted_array.index("Boredom")).to be_nil
    end

    it 'returns nil for an item not in the array' do
      expect(@sorted_array.index("Aaron")).to be_nil 
    end
    it 'returns nil for an item greater than anything in the array' do
      expect(@sorted_array.index("Zebra")).to be_nil 
    end
  end

  describe "iterators" do
    describe "that don't update the original array" do 
      describe :each do
        context 'when passed a block' do
          it_should_behave_like "yield to all elements in sorted array", :each
        end

        it 'should return the array' do
          expect(sorted_array.each {|el| el }).to eq(source)
        end
      end

      describe :each_with_index do
        it 'should call the block with two arguments, the item and its index, for each element' do
          expect do |b|
            sorted_array.each_with_index &b 
          end.to yield_successive_args([2,0],[3,1],[4,2],[7,3],[9,4])
        end

        it 'should return the original array' do
          expect(sorted_array.each_with_index { |el, index| }).to eq([2,3,4,7,9])
        end
      end

      describe :map do
        it 'the original array should not be changed' do
          original_array = sorted_array.internal_arr
          expect { sorted_array.map {|el| el * 2 } }.to_not change { original_array }
        end

        it_should_behave_like 'yield to all elements in sorted array', :map

        it 'should return an array' do
          expect(sorted_array.map {|el| el }.class).to eq(Array)
        end

        it 'array should not be the original array' do
          undesired_obj_id = sorted_array.internal_arr.object_id
          expect(sorted_array.map {|el| el }.object_id).not_to eq(undesired_obj_id)
        end

        it 'returned array contains the values returned by the block' do
          expect(sorted_array.map { |el| el * 2 }).to eq([4,6,8,14,18])
        end
      end
    end

    describe "that update the original array" do


      describe :map! do
        it_should_behave_like "yield to all elements in sorted array", :map!

        it 'should return an array' do
          expect(sorted_array.map! {|el| el }.class).to eq(Array)
        end

        it 'array should be the original array' do
          desired_obj_id = sorted_array.internal_arr.object_id
          expect(sorted_array.map! {|el| el }.object_id).to eq(desired_obj_id)
        end

        it 'should replace value of each element with the value returned by block' do
          expect(sorted_array.map! { |el| el * 2 }).to eq([4,6,8,14,18])
        end
      end
    end
  end

  describe :find do
    describe 'given a block' do
      it 'should return the element for which the block is true' do
        # let's see if we can get a multiple of 7
        expect(sorted_array.find { |el| el % 7 == 0 }).to eq(7)
      end

      context 'cannot find the element' do
        it 'should return nil' do
          # a multiple of 10 should not exist
          expect(sorted_array.find { |el| el % 10 == 0 }).to be_nil
        end
      end
    end
  end

  describe :inject do
    context 'when passed no accumulator' do
      it 'should accumulate from the first element' do
        expect(sorted_array.inject { |acc,el| acc + el }).to eq(25)
      end
    end

    context 'when passed an accumulator' do
      it 'should accumulate starting with that value' do
        expect(sorted_array.inject(5) { |acc,el| acc + el }).to eq(30)
      end
    end
  end

  describe :each_with_index do
    it 'should call the block with two arguments, the item and its index, for each element' do
      expect do |b|
        sorted_array.each_with_index &b 
      end.to yield_successive_args([2,0],[3,1],[4,2],[7,3],[9,4])
    end

    it 'should return the original array' do
      expect(sorted_array.each_with_index { |el, index| }).to eq([2,3,4,7,9])
    end
  end
end
