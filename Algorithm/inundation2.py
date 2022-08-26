# Recursive Inundation Model Algorithm v2
__author__ = "Syed Muhammad Zahir"

# IMPORTS
import random as r
from colorama import Back, Style, init
import time

# INITIALISNG colorama

init()

# UTILITY FUNCTIONS
""" 
Determines the position and value of the smallest number in a 2-D array.

Parameters:
    array:      a 2-D array to search in

Return:
    The first element in a 2-D that represents the smallest element in the
    array
"""
def getFirstMin(array: list[list[int]]) -> tuple[tuple[int, int], int]:
    minimum = float("inf")
    i = 0
    j = 0
    for row in array:
        for column, value in enumerate(row):
            if (value < minimum):
                minimum = value
                i = array.index(row)
                j = column

    return ((i, j), minimum)

"""
Given a dictionary with tuple keys and number values, a list containing the
tuple keys are returned such that the values associated with those keys are the
smallest in the dictionary

Parameters:
    mapping:    a dictionary to search in

Return:
    a list containing the tuple keys with the smallest associated valaues in the
    dictionary 
"""
def getMinimum(mapping: dict[tuple[int, int], int]) -> list[tuple[int, int]]:
        minimumHeight = min(mapping.values())
        minimumPoints = [k for k in mapping if mapping[k] == minimumHeight]
        return minimumPoints

# CLASS DEFINITIONS

"""
A class represntation of a square 2-D grid
"""
class Grid:
    """
    Initiates a Grid of a specific size and uniformly randomly generated
    number elements between 0 and a specified maximum

    Parameters:
        size:       the side length of the 2-D array
        height:     the maximum "height" or value possible in the array
    """
    def __init__(self, size: int, height: int) -> None:
        self.size = size
        self.maxHeight = height
        self.positions = [[round(r.random() * self.maxHeight, 2) for i in range(size)] 
                          for j in range(size)]

    """
    Determines whether a coordinate lies inside the grid

    Parameters:
        row:        the row to check
        column:     the column to check

    Returns:
        True if the coordinate (row, column) lies in the grid, False otherwise
    """
    def inBounds(self, row: int, column: int) -> bool:
        return (0 <= row < self.size and 0 <= column < self.size)

    """
    Prints the grid intuatively, colouring the background of any bluespot 
    elements in light-blue as in the colorama Python package (Back.LIGHTBLUE_EX)

    Parameters:
        blueSpots:      a list of tuples with (row, column) information
    """
    def print_grid(self, blueSpots: list[tuple[int, int]]) -> None:
        for i in range(self.size):
            for j in range(self.size):
                value = self.positions[i][j]
                value = "%.1f" % value
                if (i, j) in blueSpots:
                    if (j == self.size - 1):
                        print(Back.LIGHTBLUE_EX 
                              + f" {value} " 
                              + Style.RESET_ALL)
                    else:
                        print(Back.LIGHTBLUE_EX 
                              + f" {value} " 
                              + Style.RESET_ALL, end="")
                elif (j == self.size - 1):
                    print(f" {value} ")
                else:
                    print(f" {value} ", end="")
        print()

    """
    Turns a given list of element positions and return a dictionary mapping the
    position keys to respective values in the 2-D array

    Precondition:
        Assumes the list of tuples have (row, value) information such that
        self.inbounds(row, column) returns True for each element

    Parameters:
        positions:      a list of tuples with (row, column) information

    Returns:
        A dictionary with position keys and their associated values from the
        2-D grid
    """
    def positionMap(self, 
            positions: list[tuple[int, int]]) -> dict[tuple[int, int], int]:
        mapping = {}
        for position in positions:
            row, column = position
            mapping[position] = self.positions[row][column]
        return mapping


"""
A class that initiates and simulates a flood
"""
class InundationModel:
    """
    Initiates the model, setting the provided Grid as the eventual flood plane

    Parameters:
        grid:       the grid which will be used to simulate the flood, the
                    values at each coordinate in the array representing the
                    relative height    
    """
    def __init__(self, grid: Grid, stepSize = 1, maxStepCount = float("inf")) -> None:
        self.grid = grid
        self.stepSize = stepSize
        self.maxStepCount = maxStepCount
        self.stepCount = 0
        minPoint, _ = getFirstMin(self.grid.positions)
        self.blueSpotPositions = [minPoint]

    """
    Displays the grid, passing the blue spot coordinates through to be coloured
    """
    def display(self):
        self.grid.print_grid(self.blueSpotPositions)

    """
    Simulates a step in the simulation which causes all blue spots to increase
    their heights by self.stepSize.
    """
    def tick(self):
        self.stepCount += 1
        for position in self.blueSpotPositions:
            row, column = position
            surroundings = self.getSurrounding(row, column)
            surroundings = list(filter(lambda x: x not in self.blueSpotPositions, surroundings))
            if len(surroundings) == 0:
                self.grid.positions[row][column] += self.stepSize
                continue
            mapping = self.grid.positionMap(surroundings)
            minimum = min(mapping.values()) 
            if self.grid.positions[row][column] + self.stepSize > minimum:
                self.grid.positions[row][column] = minimum
            else:
                self.grid.positions[row][column] += self.stepSize

    """
    Returns a list of the positions of surrounding elements of a given position
    at a specified row and column, such that the coordinate is in bounds and
    is not a blue spot

    Parameters:
        row:        the row value of the position
        column:     the column value of the position

    Returns:
        a list of valid coordinates that surround the specified positional 
        coordinate
    """
    def getSurrounding(self, row: int, column: int) -> list[tuple[int, int]]:
        surroundings = [
            (row - 1, column), (row + 1, column), 
            (row, column - 1), (row, column + 1)]

        surroundings = list(filter(
            lambda p: self.grid.inBounds(p[0], p[1]), 
            surroundings))

        return surroundings

    """
    Determines the next blue spot(s) (if possible) for each blue spot on the grid.
    This simulates the effect of rain which pushes rainwater to other lower
    potential water resevoirs.
    """
    def advance(self) -> None:
        for position in self.blueSpotPositions:
            additionalSpots = []
            row, column = position
            self.search(row, column, additionalSpots)

            mapping = self.grid.positionMap(additionalSpots)
            if (len(mapping) > 0):
                minimumPoints = getMinimum(mapping)
                self.blueSpotPositions.extend(minimumPoints)

    """
    Recursive helper function for advance which locates (and randomly pick if
    needed) the lowest surrounding pixel. The searching stops when all
    surrounding elements are greater in height or when there is no valid
    surrounding element (i.e. point is a blue spot or is at a corner).
    Continues searching in this manner keeping track of all searched elements
    before it.

    Parameters:
        row:        the row of the current searched element
        column:     the column of the current searched element
        points:     a list of all previous searched elements
    """
    def search(self, row: int, column: int, points: list[tuple[int, int]]):
        value = self.grid.positions[row][column]
        surroundings = self.getSurrounding(row, column)
        
        surroundings = list(filter(
            lambda p: p not in self.blueSpotPositions, 
            surroundings))
        surroundings = list(filter(lambda p: p not in points, surroundings))
        surroundings = list(filter(lambda p: 
            self.grid.positions[p[0]][p[1]] <= value, surroundings))

        mapping = self.grid.positionMap(surroundings)
        if (len(surroundings) == 0) or min(mapping.values()) > value:
            return points

        minimumPoints = getMinimum(mapping)
        minimumPoint = r.choice(minimumPoints)
        points.append(minimumPoint)
        self.search(minimumPoint[0], minimumPoint[1], points)

    def level(self):
        checkingPositions = self.blueSpotPositions.copy()
        while len(checkingPositions) > 0:
            pond = []
            self.levelHelper(checkingPositions.pop(), pond, checkingPositions)
            sumHeight = 0
            for point in pond:
                row, column = point
                sumHeight += self.grid.positions[row][column]
                
            average = sumHeight / len(pond)
            for point in pond:
                row, column = point
                self.grid.positions[row][column] = average
                
    def levelHelper(self, position: tuple[int, int], pond: list[tuple[int, int]], checking: list[tuple[int, int]]):
        row, column = position
        surroundings = self.getSurrounding(row, column)
        surroundings = list(filter(lambda x: x in checking, surroundings))
        
        pond.append(position)
        
        if len(surroundings) == 0:
            return
        
        for point in surroundings:
            if (point in checking):
                checking.remove(point)
            self.levelHelper(point, pond, checking)
    
    """
    Starts the simulation loop that ends when all elements have been flood. The
    simulation ticks each prvoided tickSpeed.

    Parameters:
        tickSpeed:      the speed at which the simulation runs
    """
    def simulate(self, tickSpeed: float = 1.0) -> None:
        while len(self.blueSpotPositions) < self.grid.size ** 2 and self.stepCount < self.maxStepCount:
            time.sleep(tickSpeed)
            self.display()
            self.advance()
            self.display()
            self.level()
            time.sleep(tickSpeed)
            self.display()
            self.tick()


        print(f"Number of steps: {self.stepCount}")
        print(f"Total simulation time: {self.stepCount * tickSpeed} seconds")

# MAIN

def main():
    grid = Grid(4, 9)
    model = InundationModel(grid, stepSize=0.1)
    model.simulate(0.01)

main()
