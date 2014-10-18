# Random Name Generator, based in the code of Joshua Smith

class RandomName

	def self.random_name
		[[random_consonant.upcase,random_vowel,random_consonant,random_consonant],
		[random_consonant.upcase,random_vowel,random_consonant,random_consonant,random_vowel],
		[random_consonant.upcase,random_vowel,random_consonant,random_consonant,random_vowel,random_consonant],
		[random_vowel.upcase,random_consonant,random_consonant,random_vowel],
		[random_vowel.upcase,random_consonant,random_consonant,random_vowel,random_consonant],
		[random_vowel.upcase,random_consonant,random_consonant,random_vowel,random_consonant,random_vowel]].sample.join
	end

	def self.random_vowel
		['a','e','i','o','u'].sample
	end

	def self.random_consonant
		([*'b'..'z']-['e','i','o','u']).sample
	end

	private_class_method :random_vowel,:random_consonant

end
