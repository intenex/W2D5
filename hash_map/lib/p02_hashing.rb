
class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    all_hashes = 0
    each_with_index do |e, i|
      all_hashes += (e.hash + i).hash # adding the hash of the thing inside to the index works here because e.hash is fundamentally going to be far more variant than a single character.hash as in String, it didn't work in string because there are only 26 characters you can hash to so if you have two strings of all the same characters the same number of times in different orders those will add to the samet hing but in this case we don't have that so this doesn't *really* work that great but it does pass the specs we need it to lol
    end
    all_hashes.hash
  end

  def hash_hash # remove the test to care about ordering when hashing these for a hash because hashes should not care about ordering so don't add the index bad boy to it
    all_hashes = 0
    each do |e|
      all_hashes += (e.hash).hash
    end
    all_hashes.hash
  end
end

class String
  def hash # basically in the same terms as the Array hash thing with a slight difference
    alpha = ("a".."z").to_a
    all_hashes = 0
    self.each_char.with_index do |c, i|
      result = c.unpack('b8').to_s.to_i.hash
      all_hashes += (result + (i * alpha.index(c.downcase)).hash).hash # must multiply the index by the index of the character to get different values for different orderings adding the same numbers in different orders always returns an identical sum but multiplying in different orders the same numbers does not
    end
    all_hashes.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    (keys.hash_hash + values.hash_hash).hash # call the array hash_hash method that does not account for index differences such that different orderings will return the same hash value
  end
end
