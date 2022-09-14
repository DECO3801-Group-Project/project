import numpy as np
from colorama import Back, init

SEED = 4558421


class Landscape:

    def __init__(self, dimensions, init_map=None):
        self.dimensions = dimensions
        if init_map is None:
            # creates a grid with size (width and height) of [0] and [1], max height of [2]
            self.grid = np.random.randint(
                self.dimensions[2],
                size=(self.dimensions[0], self.dimensions[1])
            )
        else:
            self.grid = np.array(init_map)

    def is_valid_position(self, coordinates) -> bool:
        return 0 <= coordinates[0] < self.dimensions[0] and \
               0 <= coordinates[1] < self.dimensions[1]

    def get_shape(self):
        return self.grid.shape

    def get_height(self) -> int:
        return self.dimensions[2]

    def display(self, waterscape=None):
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
        print()


class CarpetBombModel:
    def __init__(self, landscape: Landscape, waterscape=None):
        self.landscape = landscape
        rows, cols = landscape.get_shape()
        if waterscape is None:
            self.waterscape = \
                Landscape(landscape.dimensions,
                          np.zeros((rows, cols)))
        else:
            self.waterscape = waterscape

    def display(self):
        self.landscape.display(self.waterscape)

    def get_shape(self):
        return self.landscape.get_shape()

    def rain(self, pattern=None) -> np.ndarray:
        if pattern is None:
            rain_grid = \
                np.ones(self.landscape.get_shape())
        else:
            rain_grid = pattern
        return rain_grid

    def get_elevation(self, pos, land=True, water=True):
        height = 0
        if land:
            height += self.landscape.grid[pos]
        if water:
            height += self.waterscape.grid[pos]
        return height

    def get_neighbours(self, position, lower=False)\
            -> list:
        neighbours = []
        for i in range(-1, 2):
            for j in range(-1, 2):
                n_pos = (position[0] + i, position[1] + j)
                center_height = self.get_elevation(position)
                # if (i != 0 or j != 0) and \
                if (abs(i) + abs(j) == 1) and \
                        self.landscape.is_valid_position(n_pos) and\
                        (not lower or center_height >
                         self.get_elevation(n_pos)):
                    neighbours.append(
                        (self.get_elevation(n_pos), n_pos)
                    )
        return neighbours

    def disperse(self, rain_grid: np.ndarray, position)\
            -> np.ndarray:
        neighbours = self.get_neighbours(position, lower=True)
        water_spilled = rain_grid[position]
        if len(neighbours) > 0:
            rain_grid[position] = 0
        for neighbour in neighbours:
            rain_grid[neighbour[1]] += \
                water_spilled / len(neighbours)
        return rain_grid

    def disperse_all(self, rain_grid: np.array):
        lw_descend = []
        for row in range(self.get_shape()[0]):
            for col in range(self.get_shape()[1]):
                pos = (row, col)
                height = self.get_elevation(pos)
                lw_descend.append((height, pos))
        lw_descend.sort(reverse=True)

        for height, pos in lw_descend:
            rain_grid = self.disperse(rain_grid, pos)

        return rain_grid

    def level(self, rain_grid: np.ndarray) -> np.ndarray:
        for row in range(self.get_shape()[0]):
            for col in range(self.get_shape()[1]):
                pos = (row, col)
                if rain_grid[pos] <= 0:
                    continue
                pond = [pos]
                pond_boundary = self.get_neighbours(pos)
                trail = []
                while rain_grid[pos] > 0:
                    # as long as rain are not completely distributed
                    pond_boundary.sort()
                    step = round(pond_boundary[0][0] - self.get_elevation(pos), 9)

                    if step < 0:
                        # if there is lower land
                        trail += pond
                        submerge = pond_boundary.pop(0)
                        rain_grid[submerge[1]] = rain_grid[pos]
                        rain_grid[pos] = 0
                        pos = submerge[1]
                        pond = [submerge[1]]
                        pond_boundary = [x for x in self.get_neighbours(submerge[1])
                                         if x[1] not in pond]

                    elif step > rain_grid[pos] / len(pond):
                        # if no lower land and no spilling
                        for pond_spot in pond:
                            self.waterscape.grid[pond_spot] += rain_grid[pos] / len(pond)
                        rain_grid[pos] = 0

                    else:
                        # if no lower land and spilling
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

    def tick(self, rain_pattern: np.ndarray):
        rain_grid = self.rain(rain_pattern)
        rain_grid = self.disperse_all(rain_grid)
        rain_grid = self.level(rain_grid)
        self.waterscape.grid += rain_grid


if __name__ == "__main__":
    init(wrap=False)
    np.random.seed(SEED)
    cbm = CarpetBombModel(Landscape((5, 5, 50)))
    cbm.display()
    for i in range(10):
        cbm.tick(cbm.rain())
        cbm.display()
        # print("Total water: ", round(np.sum(cbm.waterscape.grid), 3))
