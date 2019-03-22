class HashSet
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
    @store[num.hash % @store.length]
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
