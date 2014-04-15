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
      sorted_array.class.should == SortedArray
    end
    it 'can be given an array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      sorted_array.size.should == source.size
    end
    it 'is sorted if initialized with an array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      sorted_array[0...5].should == source.sort
    end
  end

  describe '#[]' do
    before do
      @source = [2,3,4,7,9]
      @sorted_array = SortedArray.new
      @sorted_array.internal_arr = @source
    end

    it 'indexes an element' do
      @sorted_array[2].should == 4
    end

    it 'gives nil for an out of range element' do
      @sorted_array[10].should == nil
    end

    it 'indexes a range' do
      @sorted_array[1..3].should == @source[1..3]
    end
  end

  describe '#size' do
    it 'gives the size of []' do
      sorted_array = SortedArray.new
      sorted_array.size.should == 0
    end
    it 'works with a starter array' do
      source = [4,7,3,9,2]
      sorted_array = SortedArray.new(source)
      sorted_array.size.should == source.size
    end
  end
  describe '#add' do
    before do
      @source = [4,7,3,9,2]
      @sorted_array = SortedArray.new(@source)
    end
    it 'can add an element' do
      @sorted_array.add(4)
      @sorted_array.size.should == @source.size + 1
    end
    it 'adds in the correct location' do
      @sorted_array.add(1)
      @sorted_array.add(10)
      @sorted_array[-1].should == 10
      @sorted_array[0].should == 1
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
      @sorted_array.first_larger_index(4).should == 0
    end

    it 'can pick before or after a single element' do
      @sorted_array.internal_arr = [5]
      @sorted_array.first_larger_index(4).should == 0
      @sorted_array.first_larger_index(6).should == 1
    end

    it 'can pick before, after or between two elements' do
      @sorted_array.internal_arr = [5,7]
      @sorted_array.first_larger_index(4).should == 0
      @sorted_array.first_larger_index(6).should == 1
      [1,2].include?(@sorted_array.first_larger_index(7)).should == true
      @sorted_array.first_larger_index(8).should == 2
    end

    it 'can put an existing element on either side' do
      @sorted_array.internal_arr = [5]
      [0,1].include?(@sorted_array.first_larger_index(5)).should == true
    end

    it 'gives 0 for a new smallest' do
      @sorted_array.first_larger_index(-4).should == 0
    end

    it 'gives the last index for a new largest' do
      @sorted_array.first_larger_index(10).should == @sorted_array.size
    end
    it 'gives the right location' do
      @sorted_array.first_larger_index(5).should == 3
    end
  end

  describe '#index' do
    before do
      @source = ["Crisis","Balderdash","Masticate","Xanadu","Lemur"]
      # ["Balderdash", "Crisis", "Lemur", "Masticate", "Xanadu"]
      @sorted_array = SortedArray.new(@source)
    end
    it 'finds the middle item' do
      @sorted_array.index("Lemur").should == 2
    end
    it 'finds an item in the left half' do
      @sorted_array.index("Crisis").should == 1
    end
    it 'finds the last item' do
      @sorted_array.index("Xanadu").should == 4
    end
    it 'returns nil for an item not in the array' do
      @sorted_array.index("Boredom").should == nil
    end

    it 'returns nil for an item not in the array' do
      @sorted_array.index("Aaron").should == nil
    end
    it 'returns nil for an item greater than anything in the array' do
      @sorted_array.index("Zebra").should == nil
    end
  end

  describe "iterators" do
    describe "that don't update the original array" do 
      describe :each do
        context 'when passed a block' do
          it_should_behave_like "yield to all elements in sorted array", :each
        end

        it 'should return the array' do
          sorted_array.each {|el| el }.should eq source
        end
      end

      describe :each_with_index do
        it 'should call the block with two arguments, the item and its index, for each element' do
          expect do |b|
            sorted_array.each_with_index &b 
          end.to yield_successive_args([2,0],[3,1],[4,2],[7,3],[9,4])
        end

        it 'should return the original array' do
          sorted_array.each_with_index { |el, index| }.should == [2,3,4,7,9]
        end
      end

      describe :map do
        it 'the original array should not be changed' do
          original_array = sorted_array.internal_arr
          expect { sorted_array.map {|el| el * 2 } }.to_not change { original_array }
        end

        it_should_behave_like 'yield to all elements in sorted array', :map

        it 'should return an array' do
          sorted_array.map {|el| el }.class.should eq Array
        end

        its 'array should not be the original array' do
          undesired_obj_id = sorted_array.internal_arr.object_id
          sorted_array.map {|el| el }.object_id.should_not eq undesired_obj_id
        end

        its 'returned array contains the values returned by the block' do
          sorted_array.map { |el| el * 2 }.should eq [4,6,8,14,18]
        end
      end
    end

    describe "that update the original array" do


      describe :map! do
        it_should_behave_like "yield to all elements in sorted array", :map!

        it 'should return an array' do
          sorted_array.map! {|el| el }.class.should eq Array
        end

        its 'array should be the original array' do
          desired_obj_id = sorted_array.internal_arr.object_id
          sorted_array.map! {|el| el }.object_id.should eq desired_obj_id
        end

        it 'should replace value of each element with the value returned by block' do
          sorted_array.map! { |el| el * 2 }.should eq [4,6,8,14,18]
        end
      end
    end
  end

  describe :find do
    describe 'given a block' do
      it 'should return the element for which the block is true' do
        # let's see if we can get a multiple of 7
        sorted_array.find { |el| el % 7 == 0 }.should eq 7
      end

      context 'cannot find the element' do
        it 'should return nil' do
          # a multiple of 10 should not exist
          sorted_array.find { |el| el % 10 == 0 }.should be_nil
        end
      end
    end
  end

  describe :inject do
    context 'when passed no accumulator' do
      it 'should accumulate from the first element' do
        sorted_array.inject { |acc,el| acc + el }.should == 25
      end
    end

    context 'when passed an accumulator' do
      it 'should accumulate starting with that value' do
        sorted_array.inject(5) { |acc,el| acc + el }.should == 30
      end
    end
  end
end
