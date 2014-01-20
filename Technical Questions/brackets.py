# Given n = some number
# Print all the valid string combinations (that make sense) that contain n pairs of brackets and/or the number of combinations (nth Catalan number)
# Note; this wasn't an interview question.

# Alternative methods include:
# Use a trie (Root node is a '(', child nodes after would be '(', and ')'.
# 

parens = [] # List of bracket combinations
def gimmeBrackets(n):
    brackets('', n, n)

# Recursive method that takes a string and the number of left parens and right parens left to use and generates all remaining possible bracket strings that make sense
def brackets(string, lb, rb):
    # Once there are no right parens left (thus there are no left parens left either), we're done with this path, so add it to our combinations list
    if rb == 0:
        parens.append(string)
    else: 
        if lb < rb:
            brackets(string + ')', lb, rb-1) 
        if lb > 0:
            brackets(string + '(', lb-1, rb) 

for i in range(3, 5):
    gimmeBrackets(i)
    print len(parens)
    parens = [] # Clear parens list
