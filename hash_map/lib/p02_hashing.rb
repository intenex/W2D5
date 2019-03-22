
class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    all_hashes = 0
    each_with_index do |e, i|
      all_hashes += (e.hash + i).hash
    end
    all_hashes.hash
  end
end

class String
  def hash
    alpha = ("a".."z").to_a
    all_hashes = 0
    self.each_char.with_index do |c, i|
      result = c.unpack('b8').to_s.to_i.hash
      all_hashes += (result + (i * alpha.index(c.downcase)).hash).hash
    end
    all_hashes.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    0
  end
end
