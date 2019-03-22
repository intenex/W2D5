require_relative 'p05_hash_map'
require_relative 'p04_linked_list'
require "byebug"

# need doubly linked list because when ejecting from a singly linked list
# you have no idea what linked to that element so you would need to go
# all the way through the linked list until you found the previous element
# that linked to the element you were trying to delete and then reset that
# link's next pointer to the next element skipping the element being ejected

class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      node = @map[key]
      update_node!(node)
      node.val
    else
      value = @prc.call(key)
      @store.append(key, value)
      @map[key] = @store.last
      eject! if @map.count > @max
      value
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    @store.remove(node.key)
    @store.append(node.key, node.val)
    @map[node.key] = @store.last
  end

  def eject!
    # debugger
    hash_key = @store.first.key
    @store.remove(hash_key)
    @map.delete(hash_key)
  end
end
