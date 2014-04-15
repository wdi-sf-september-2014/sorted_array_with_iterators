## Iterators Lab

This lab builds on an implementation of ```SortedArray```.  A ```SortedArray``` is an array that always maintains the sorted order of its elements.  Here is some example use of ```SortedArray```:

```
arr = SortedArray.new([9,11,23,4,5,6,-10])
puts "All items:"
while i < arr.length
  puts arr[i]
  i += 1
end

arr.add(8)
puts "\nThe element at index 4 is now 8:"
puts arr[4]

```

Below is the output of the code:

```
All items:
-10
4
5
6
9
11
23

The element at index 4 is now 8:
8
```
__NOTICE__ that the array is printed in sorted order.  Since our SortedArray class always maintains order.

### Objective

The objective is to implement the iterator methods in the sorted array class so that the tests pass.  You will implement the following methods:

```
each
each_with_index
map
map!
find
inject  # BONUS!
```

### Suggestions

* Implement the methods in the order they are defined in the file.
* Implement the each method first, then use the each method to implement other methods.
* You should not have to write any while loops after you have written one in each.
* Get very familiar with the iterator methods before you implement them.  Use the ruby docs or use the methods in pry with a standard array.

### Bonus

Implement `SortedArray#inject`. See if you can get it to work exactly
like `Array#inject`. 
