class MaxIntSet

  def initialize(max)
    @store = Array.new(max) { false }
  end

  def insert(num)
    is_valid?(num) ? (@store[num] = true) : (raise ArgumentError.new("Out of bounds"))
  end

  def remove(num)
    is_valid?(num) ? (@store[num] = false) : (raise ArgumentError.new("Out of bounds"))
  end

  def include?(num)
    is_valid?(num) ? @store[num] : (raise ArgumentError.new("Out of bounds"))
  end

  private

  def is_valid?(num)
    num <= @store.length && num >= 0
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num] << num unless self[num].include?(num)
  end

  def remove(num)
    self[num].delete(num) if self[num].include?(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num%20]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    unless self[num].include?(num)
      self[num] << num 
      @count += 1
    end
    if @count + 1 == @store.length
      resize!
    end
  end

  def remove(num)
    if self[num].include?(num)
      self[num].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % @store.length]
  end

  def num_buckets
    @store.length
  end

  def resize!
    original_store = @store.dup
    @store = Array.new(2*@store.length) { Array.new }
    original_store.each do |bucket|
      bucket.each do |num|
        self[num] << num
      end
    end
  end
end
