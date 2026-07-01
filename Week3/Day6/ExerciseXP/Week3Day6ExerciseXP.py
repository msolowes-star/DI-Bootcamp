class Human:
    def __init__(self, id_number, name, age, priority, blood_type):
        self.id_number = id_number
        self.name = name
        self.age = age
        self.priority = priority
        self.blood_type = blood_type
        self.family = []

    def add_family_member(self, person):
        if person not in self.family:
            self.family.append(person)

        if self not in person.family:
            person.family.append(self)


class Queue:
    def __init__(self):
        self.humans = []

    def add_person(self, person):
        if person.age > 60 or person.priority:
            self.humans = [person] + self.humans
        else:
            self.humans.append(person)

    def find_in_queue(self, person):
        for i in range(len(self.humans)):
            if self.humans[i] == person:
                return i
        return None

    def swap(self, person1, person2):
        index1 = self.find_in_queue(person1)
        index2 = self.find_in_queue(person2)

        if index1 is not None and index2 is not None:
            self.humans[index1], self.humans[index2] = self.humans[index2], self.humans[index1]

    def get_next(self):
        if len(self.humans) == 0:
            return None

        next_person = self.humans[0]
        self.humans = self.humans[1:]
        return next_person

    def get_next_blood_type(self, blood_type):
        if len(self.humans) == 0:
            return None

        for i in range(len(self.humans)):
            if self.humans[i].blood_type == blood_type:
                person = self.humans[i]
                self.humans = self.humans[:i] + self.humans[i + 1:]
                return person

        return None

    def sort_by_age(self):
        new_list = []

        while len(self.humans) > 0:
            best_person = self.humans[0]
            best_index = 0

            for i in range(len(self.humans)):
                current = self.humans[i]

                if current.priority and not best_person.priority:
                    best_person = current
                    best_index = i

                elif current.priority == best_person.priority:
                    if current.age > best_person.age:
                        best_person = current
                        best_index = i

            new_list.append(best_person)
            self.humans = self.humans[:best_index] + self.humans[best_index + 1:]

        self.humans = new_list

    def rearrange_queue(self):
        for i in range(len(self.humans) - 1):
            current_person = self.humans[i]
            next_person = self.humans[i + 1]

            if next_person in current_person.family:
                for j in range(i + 2, len(self.humans)):
                    possible_swap = self.humans[j]

                    if possible_swap not in current_person.family:
                        self.humans[i + 1], self.humans[j] = self.humans[j], self.humans[i + 1]
                        break