import string
import re


class Text:
    def __init__(self, text):
        self.text = text

    def word_frequency(self, word):
        words = self.text.lower().split()
        word = word.lower()

        count = words.count(word)

        if count == 0:
            return None
        return count

    def most_common_word(self):
        words = self.text.lower().split()

        word_counts = {}

        for word in words:
            if word in word_counts:
                word_counts[word] += 1
            else:
                word_counts[word] = 1

        most_common = max(word_counts, key=word_counts.get)
        return most_common

    def unique_words(self):
        words = self.text.lower().split()
        unique = set(words)
        return list(unique)

    @classmethod
    def from_file(cls, file_path):
        with open(file_path, "r") as file:
            content = file.read()

        return cls(content)


class TextModification(Text):
    def remove_punctuation(self):
        clean_text = ""

        for char in self.text:
            if char not in string.punctuation:
                clean_text += char

        return clean_text

    def remove_stop_words(self):
        stop_words = [
            "a", "an", "the", "and", "or", "but", "is", "are", "was", "were",
            "in", "on", "at", "to", "for", "of", "with", "by", "this", "that",
            "it", "as", "be", "from"
        ]

        words = self.text.lower().split()
        filtered_words = []

        for word in words:
            if word not in stop_words:
                filtered_words.append(word)

        return " ".join(filtered_words)

    def remove_special_characters(self):
        clean_text = re.sub(r"[^a-zA-Z0-9\s]", "", self.text)
        return clean_text


# Testing Part I
text = Text("Hello world hello Python world world")

print(text.word_frequency("world"))
print(text.most_common_word())
print(text.unique_words())


# Testing Bonus
modified_text = TextModification("Hello!!! This is a test, with punctuation & special characters.")

print(modified_text.remove_punctuation())
print(modified_text.remove_stop_words())
print(modified_text.remove_special_characters())