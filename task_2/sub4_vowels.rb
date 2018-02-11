vowel_index = {}
vowels = %w[a e i o u y]
alphabet = ('a'..'z').to_a

vowels.each do |letter|
  vowel_index[letter] = alphabet.index(letter)
end

puts vowel_index
