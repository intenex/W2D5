class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    @prev.next = self.next
    @next.prev = self.prev
  end
end

class LinkedList
  include Enumerable
  def initialize
    @head = Node.new #should have next
    @tail = Node.new #should have prev
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next unless empty?
  end

  def last
    @tail.prev unless empty?
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    current_node = @head.next
    until current_node.key == key || current_node == @tail
      current_node = current_node.next
    end
    current_node.val
  end

  def include?(key)
    get(key) ? true : false
  end

  def append(key, val)
    new_node = Node.new(key, val)
    @tail.prev.next = new_node
    new_node.prev = @tail.prev
    new_node.next = @tail
    @tail.prev = new_node
  end

  def update(key, val)
    current_node = @head.next
    until current_node.key == key || current_node == @tail
      current_node = current_node.next
    end
    current_node.val = val unless current_node == @tail
  end

  def remove(key)
    current_node = @head.next
    until current_node.key == key || current_node == @tail
      current_node = current_node.next
    end
    current_node.remove unless current_node == @tail
  end

  def each
    current_node = @head.next
    until current_node == @tail
      yield(current_node)
      current_node = current_node.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  # def to_s
  #   inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  # end
end
