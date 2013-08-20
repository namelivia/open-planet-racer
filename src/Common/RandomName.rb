# Random Name Generator, based in the code of Joshua Smith

class RandomName

def getRandomName()

  retName = ""
  length = rand(1)+5;
 #// CVCCVC or VCCVCV
  if (rand(1) < 1) then

	retName += getRandomConsonant()
        retName = retName.upcase
        retName += getRandomVowel()
        retName += getRandomConsonant()
        retName += getRandomConsonant()
        if (length >= 5) then 
		retName += getRandomVowel() 
	end
        if (length >= 6) then 
		retName += getRandomConsonant()
	end
  else
  	retName += getRandomVowel()
        retName = retName.upcase
        retName += getRandomConsonant()
        retName += getRandomConsonant()
        retName += getRandomVowel()
        if (length >= 5) then
        	 retName += getRandomConsonant()
        end
        if (length >= 6) then 
		retName += getRandomVowel()
        end
  end
  return retName
end

def getRandomVowel()
  randNum = rand(3)+1
  case (randNum)
    when 0
      return 'a'
    when 1
      return 'e'
    when 2
      return 'i'
    when 3
      return 'o'
    when 4
      return 'u'
    end
end

def  getRandomConsonant()
                randLetter = (rand(25)+97).chr
                while (isCharVowel(randLetter)) do
                  randLetter = (rand(25)+97).chr
                end
	return randLetter
end

def isCharVowel(letter)
  if (letter == 'a' or letter == 'e' or letter == 'i' or letter == 'o' or letter == 'u') then
    return true
  else
    return false
  end
end
end
