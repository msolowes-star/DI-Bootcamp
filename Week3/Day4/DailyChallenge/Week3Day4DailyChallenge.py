import math


class Circle:

    def __init__(self, radius=None, diameter=None):
        if radius is not None:
            self._radius = radius
        elif diameter is not None:
            self._radius = diameter / 2
        else:
            self._radius = 1

    @property
    def radius(self):
        return self._radius

    @property
    def diameter(self):
        return self._radius * 2

    def area(self):
        return math.pi * (self.radius ** 2)

    def __str__(self):
        return (f"Circle(radius={self.radius}, "
                f"diameter={self.diameter}, "
                f"area={self.area():.2f})")

    def __add__(self, other):
        return Circle(radius=self.radius + other.radius)

    def __gt__(self, other):
        return self.radius > other.radius

    def __eq__(self, other):
        return self.radius == other.radius

    def __lt__(self, other):
        return self.radius < other.radius


# ------------------------
# Testing
# ------------------------

circle1 = Circle(radius=5)
circle2 = Circle(diameter=8)
circle3 = Circle(radius=3)

print(circle1)
print(circle2)

print(f"Circle 1 area: {circle1.area():.2f}")
print(f"Circle 2 area: {circle2.area():.2f}")

new_circle = circle1 + circle2
print("\nNew circle after addition:")
print(new_circle)

print("\nComparisons:")
print(circle1 > circle2)
print(circle1 == circle2)

circles = [circle1, circle2, circle3]

print("\nBefore sorting:")
for circle in circles:
    print(circle)

circles.sort()

print("\nAfter sorting:")
for circle in circles:
    print(circle)