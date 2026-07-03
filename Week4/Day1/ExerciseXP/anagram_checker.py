class AnagramChecker:
    def __init__(self):
        with open("sowpods.txt", "r") as file:
            self.words = [word.strip().lower() for word in file.readlines()]

    def is_valid_word(self, word):
        return word.lower() in self.words

    def is_anagram(self, word1, word2):
        return sorted(word1.lower()) == sorted(word2.lower()) and word1.lower() != word2.lower()

    def get_anagrams(self, word):
        word = word.lower()
        anagrams = []

        for dictionary_word in self.words:
            if self.is_anagram(word, dictionary_word):
                anagrams.append(dictionary_word)

        return anagrams