class Farm:

    def __init__(self, farm_name):
        self.name = farm_name
        self.animals = {}

    # Bonus version using **kwargs
    def add_animal(self, **kwargs):

        for animal, count in kwargs.items():

            if animal in self.animals:
                self.animals[animal] += count
            else:
                self.animals[animal] = count

    def get_info(self):

        info = f"{self.name}'s farm\n\n"

        for animal, count in self.animals.items():
            info += f"{animal:<10}: {count}\n"

        info += "\nE-I-E-I-O!"

        return info

    def get_animal_types(self):

        return sorted(self.animals.keys())

    def get_short_info(self):

        animal_list = []

        for animal in self.get_animal_types():

            if self.animals[animal] > 1:
                animal_list.append(animal + "s")
            else:
                animal_list.append(animal)

        if len(animal_list) == 1:
            animals_string = animal_list[0]
        else:
            animals_string = ", ".join(animal_list[:-1])
            animals_string += " and " + animal_list[-1]

        return f"{self.name}'s farm has {animals_string}."


# Test the program

macdonald = Farm("McDonald")

macdonald.add_animal(
    cow=5,
    sheep=2,
    goat=12
)

print(macdonald.get_info())

print()

print(macdonald.get_animal_types())

print()

print(macdonald.get_short_info())