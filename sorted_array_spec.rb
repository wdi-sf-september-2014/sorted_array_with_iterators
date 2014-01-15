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
