require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    # debugger unless i.between?(0, self.store.length - 1)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  attr_reader :store, :start_idx
  attr_accessor :count
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @start_idx = 0
  end

  # def [](i)
  #   if i < 0
  #     new_bound = @count + i
  #     return nil if new_bound < 0
  #     new_bound < count ? @store[new_bound] : nil
  #   else
  #     i < count ? @store[i] : nil
  #   end
  # end

  def [](i)
    if i >= self.count
      return nil
    elsif i < 0
      return nil if i < -self.count
      return self[self.count + i]
    end

    self.store[(self.start_idx + i) % capacity]
  end

  # def []=(i, val)
  #   if i < 0
  #     new_bound = @count + i
  #     return nil if new_bound < 0
  #     new_bound < count ? @store[new_bound] = val : nil
    # else
    #   if i < @count
    #     @store[i] = val 
    #   else
    #     @store[capacity - 1] = val unless @store[capacity - 1] 
    #   end
  #   end
  # end

  def []=(i, val)
    if i >= self.count
      (i - self.count).times { push(nil) }
    elsif i < 0
      return nil if i < -self.count
      return self[self.count + i] = val
    end

    if i == self.count
      resize! if capacity == self.count
      self.count += 1
    end

    self.store[(self.start_idx + i) % capacity] = val
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def capacity
    @store.length
  end

  def include?(val)
    (0...capacity).each do |i|
      return true if @store[i] == val
    end
    false
  end

  def push(val)
    resize! if count + 1  > capacity
    @store[count] = val
    @count += 1
  end

  def unshift(val)
    resize! if count + 1  > capacity
    (1..@count).reverse_each do |i|
      @store[i] = @store[i-1]
    end
    @store[0] = val
    @count += 1
  end

  def pop
    return nil if count == 0
    val = @store[count-1]
    @store[@count - 1] = nil
    @count -= 1
    val
  end

  def shift
    return nil if count == 0
    val = @store[0]
    (0...@count).each do |i|
      @store[i] = @store[i+1] if self.count > i+1 # don't reference @store[i+1] if it's out of bounds which it would be if we're shifting on the last index
    end
    @count -= 1
    val
  end

  def first
    @store[0]
  end

  def last
    @store[@count-1]
  end

  def each
    (0...@count).each do |i|
      yield(@store[i])
    end
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # return false if other.is_a?(Array) && @count != other.length
    return false unless length == other.length
    # return false if other.is_a?(DynamicArray) && @count != other.count
    (0...@count).each do |i|
      return false if @store[i] != other[i]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_capacity = capacity * 2
    old_store = @store
    @store = StaticArray.new(new_capacity)
    (0...old_store.length).each do |i|
      @store[i] = old_store[i]
    end
  end
end
