import numpy as np
from colorama import Back, init
import time

SEED = 4558421
SURROUND8 = False
ROUND_DIGIT = 6
SIMULATION_SIZE = (10, 10, 100)
CEILING = SIMULATION_SIZE[2] * 2
PERIOD = 100
TICKING = True
DISPLAY = True


class Landscape:

    def __init__(self, dimensions: tuple, init_map=None) -> None:
        """
        construct 2d array of land height,
        will be randomized if no initial map given
        :param dimensions: (shape of 2d array, max height of map), ignored if initial map is given
        :param init_map: pre-initialsed map
        """
        if init_map is None:
            self.dimensions = dimensions
            self.grid = np.random.randint(
                self.dimensions[2],
                size=(self.dimensions[0], self.dimensions[1])
            )
        else:
            self.grid = np.array(init_map)
            self.dimensions = (self.grid.shape[0], self.grid.shape[1], np.amax(self.grid))

    def is_within_bounds(self, coordinates) -> bool:
        """
        :param coordinates: specified coordinates
        :return: whether specified coordinates lies within the 2d array
        """
        return 0 <= coordinates[0] < self.dimensions[0] and \
               0 <= coordinates[1] < self.dimensions[1]

    def get_shape(self) -> tuple:
        """
        :return: shape of this 2d array
        """
        return self.grid.shape

    def get_height(self) -> int:
        """
        :return: max height of this 2d array
        """
        return self.dimensions[2]

    def display(self, waterscape=None):
        """
        prints the 2d array
        :param waterscape: if given, the numbers will be summed up and
                colored blue if waterscape is greater than 0
        """
        for i in range(self.dimensions[0]):
            for j in range(self.dimensions[1]):
                if waterscape is not None and \
                        waterscape.grid[i, j] > 0:
                    print(Back.BLUE, end="")
                    value = round(self.grid[i, j] + waterscape.grid[i, j], 1)
                else:
                    value = round(self.grid[i, j], 1)
                print(f"{value} ".rjust(6) + Back.RESET, end="")
                if j == self.dimensions[1] - 1:
                    print()


class CarpetBombModel:
    def __init__(self, landscape: Landscape, waterscape=None):
        """
        construct a model for flood model
        :param landscape: landscape to work on
        :param waterscape: if not given, will be initialized as 2d zero array of the same shape
        """
        self.landscape = landscape
        rows, cols = landscape.get_shape()
        self.waterscape = \
            Landscape(landscape.dimensions,
                      np.zeros((rows, cols)))
        if waterscape is not None:
            self.tick(self.rain(waterscape.grid))

    def display(self) -> None:
        """
        prints the current simulation
        """
        self.landscape.display(self.waterscape)
        print("Total water: ", round(np.sum(cbm.waterscape.grid), 3))
        print()

    def get_shape(self) -> tuple:
        """
        :return: shape of simulation
        """
        return self.landscape.get_shape()

    def rain(self, pattern=None) -> np.ndarray:
        """
        generates rain uniformly across the whole simulation
        :param pattern: if given, overrides the uniform rain
        :return: generated rain as 2d array
        """
        if pattern is None:
            rain_grid = \
                np.ones(self.landscape.get_shape())
        else:
            rain_grid = pattern
        return rain_grid

    def get_elevation(self, pos, land=True, water=True):
        """
        returns elevation of simulation at specified position
        :param pos: specified position
        :param land: whether include land elevation
        :param water: whether include water elevation
        :return: elevation sum at specified position
        """
        height = 0
        if land:
            height += self.landscape.grid[pos]
        if water:
            height += self.waterscape.grid[pos]
        return height

    def get_neighbours(self, position, lower=False)\
            -> list:
        """
        returns neighbouring coordinates of specified position
        :param position: specified position
        :param lower: whether returned neighbours should only include lower elevation
        :return: list of neighbouring coordinates as (elevation, coordinates)
        """
        neighbours = []
        for i in range(-1, 2):
            for j in range(-1, 2):
                n_pos = (position[0] + i, position[1] + j)
                center_height = self.get_elevation(position)
                if ((SURROUND8 and (i != 0 or j != 0)) or
                    (abs(i) + abs(j) == 1)) and \
                        self.landscape.is_within_bounds(n_pos):
                    n_elevation = self.get_elevation(n_pos)
                    if (not lower or center_height >
                            n_elevation):
                        neighbours.append((n_elevation, n_pos))
        return neighbours

    def get_descend(self):
        """
        get sorted list of coordinates from high to low
        :return: list as (elevation, coordinates)
        """
        lw_descend = []
        for row in range(self.get_shape()[0]):
            for col in range(self.get_shape()[1]):
                pos = (row, col)
                height = self.get_elevation(pos)
                lw_descend.append((height, pos))
        lw_descend.sort(reverse=True)
        return lw_descend

    def disperse(self, rain_grid: np.ndarray, position)\
            -> np.ndarray:
        """
        disperse rain at specified position onto lower neighbouring positions
        :param rain_grid: rain grid to work on
        :param position: specified position
        :return: modified rain grid
        """
        neighbours = self.get_neighbours(position, lower=True)
        water_spilled = rain_grid[position]
        if len(neighbours) > 0:
            rain_grid[position] = 0
        for neighbour in neighbours:
            rain_grid[neighbour[1]] += \
                water_spilled / len(neighbours)
        return rain_grid

    def disperse_all(self, rain_grid: np.array, descend: list)\
            -> tuple:
        """
        disperse rain in specified order
        :param rain_grid: rain grid to work on
        :param descend: specified order
        :return: modified rain grid
        """
        water_accumulation = []
        for height, pos in descend:
            rain_grid = self.disperse(rain_grid, pos)
            if rain_grid[pos] > 0:
                water_accumulation.append(pos)

        return rain_grid, water_accumulation

    def level(self, rain_grid: np.ndarray, order: list)\
            -> np.ndarray:
        """
        level rain in specified order
        :param rain_grid: rain grid to work on
        :param order: specified order
        :return: modified rain grid, should 0s
        """
        # descend = [elevation for elevation in descend if rain_grid[elevation[1]] > 0]
        # removes position if no rain at position
        for pos in order:
            pond = [pos]
            pond_boundary = self.get_neighbours(pos)
            while rain_grid[pos] > 0:
                # as long as rain are not completely distributed
                # find next lowest neighbour
                pond_boundary.sort()
                if len(pond_boundary) > 0:
                    step = round(pond_boundary[0][0] - self.get_elevation(pos), ROUND_DIGIT)
                else:
                    step = CEILING

                if step < 0:
                    # if there is lower land
                    # move all rain to lower land and set lower land as pond
                    submerge = pond_boundary.pop(0)
                    rain_grid[submerge[1]] += rain_grid[pos]
                    rain_grid[pos] = 0
                    pos = submerge[1]
                    pond = [submerge[1]]
                    pond_boundary = [x for x in self.get_neighbours(submerge[1])
                                     if x[1] not in pond]

                elif step > rain_grid[pos] / len(pond):
                    # if no lower land and no spilling
                    # distribute rain evenly to all in pond
                    for pond_spot in pond:
                        self.waterscape.grid[pond_spot] += rain_grid[pos] / len(pond)
                    rain_grid[pos] = 0

                else:
                    # if no lower land and spilling
                    # distribute rain evenly to all in pond up to height of lowest neighbour
                    # add lowest neighbour to pond
                    if step > 0:
                        for pond_spot in pond:
                            self.waterscape.grid[pond_spot] += step
                        rain_grid[pos] -= step * len(pond)
                    submerge = pond_boundary.pop(0)
                    pond.append(submerge[1])
                    rain_grid[pos] += rain_grid[submerge[1]]
                    rain_grid[submerge[1]] = 0
                    pond_boundary += [x for x in self.get_neighbours(submerge[1])
                                      if x[1] not in pond]
                    pond_boundary = list(dict.fromkeys(pond_boundary))

        return rain_grid

    def tick(self, rain_pattern: np.ndarray) -> None:
        """
        what happens in 1 unit time
        :param rain_pattern: 2d array representing the density of rain
        """
        rain_grid = self.rain(rain_pattern)
        rain_grid, accumulated = self.disperse_all(rain_grid, self.get_descend())
        rain_grid = self.level(rain_grid, accumulated)
        self.waterscape.grid += rain_grid
        self.waterscape.grid = np.round(self.waterscape.grid, ROUND_DIGIT)


if __name__ == "__main__":
    init(wrap=False)
    np.random.seed(SEED)
    cbm = CarpetBombModel(Landscape(SIMULATION_SIZE))
    if DISPLAY:
        cbm.display()
    time_initial = time.perf_counter()

    for unit_time in range(PERIOD):
        if TICKING:
            print("tick ", unit_time + 1)
        cbm.tick(cbm.rain())

        # insert write to file here
        # cbm.waterscape.grid is the array storing water levels without land elevation

        if DISPLAY:
            cbm.display()
        if np.all(cbm.waterscape.grid > np.zeros((SIMULATION_SIZE[0], SIMULATION_SIZE[1]))):
            break

    time_end = time.perf_counter()
    print(f"Simulation of size {SIMULATION_SIZE} across {unit_time + 1} unit time completed in {time_end - time_initial:0.4f} seconds")
