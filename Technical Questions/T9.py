# Goal: Given a set of words, and a phone number, return a list of words that could be made from a T9 encoding of the phone number. I define T9 encoding as the typical letters that are on the the number on a phone's keypad.

# Algorithm: Initialize an empty set called allCombinations. Set index i to 0. For every element in allCombinations, remove that element 'E' and add to the list E + numMap[numbers[i]] for each element in numMap[numbers[i]] where numbers is the list of digits comprising the phone number and numMap is a mapping from a digit to a list of characters corresponding to the letters on the phone's keypad. Lastly, check each element of allCombinations to see if it's contained in our dictionary.

dictionary = ([line.rstrip('\n') for line in open('/usr/share/dict/words')])
allRealWords = set([])
allCombinations = set([])

# Could just use list instead, since they're small integers from 0 -> 9
numMap = {0:[], 1:[], 2:['a','b','c'], 3:['d','e','f'], 4:['g','h','i'], 5:['j','k','l'], 6:['m','n','o'], 7:['p','q','r','s'], 8:['t','u','v'], 9:['w','x','y','z']}
numbers = [2,3,3,5,6]

for i in range(len(numbers)):
    if len(allCombinations) == 0:
        for x in numMap[numbers[i]]:
            allCombinations.add(x)
    else:
        addSet = set([])
        for y in allCombinations:
            if len(numMap[numbers[i]]) != 0:
                addSet.add(y)
            for x in numMap[numbers[i]]:
                addSet.add(y+x)
        allCombinations.symmetric_difference_update(addSet)

for word in allCombinations:
    if word in dictionary:
        print word
        allRealWords.add(word)
#allRealWords = set([word for word in allCombinations if word in dictionary])
#print '\n'.join(allRealWords)

print len(allRealWords)
