require_relative 'p04_linked_list'
require "byebug"

class HashMap
  include Enumerable
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    linked_list = bucket(key)
    if linked_list.include?(key)
      linked_list.update(key, val)
    else
      linked_list.append(key, val)
      @count += 1
      resize! if @count +1 == @store.length
    end
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    linked_list = bucket(key)
    if linked_list.include?(key)
      linked_list.remove(key)
      @count -= 1
    end
  end

  def each
    @store.each do |bucket|
      bucket.each {|node| yield(node.key, node.val) }
    end
  end

  # uncomment when you have Enumerable included # super fucking lucky to not get stuck and just keep moving forward at a good pace # really understanding the material really helps hilarious that you never even watched the lectures you just read them while working out and it was totally sufficient for this stuff but not SQL or Rails tragically
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    original_store = @store.dup
    @store = Array.new(2*@store.length) { LinkedList.new }
    original_store.each do |bucket|
      bucket.each do |node|
        bucket(node.key).append(node.key, node.val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    @store[key.hash % @store.length]
  end
end
