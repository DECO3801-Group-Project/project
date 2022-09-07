import numpy as np
import heapq
from colorama import Back, init
import codecs, json

SEED = 4558421

# Hunter added this comment to line 8

class Landscape: # now line 10

    def __init__(self, dimensions: (int, int, int), init_map=None):
        self.dimensions = dimensions
        if init_map is None:
            self.grid = np.random.randint(
                self.dimensions[2],
                size=(self.dimensions[0], self.dimensions[1])
            )
        else:
            self.grid = np.array(init_map)

    def is_valid_position(self, coordinates: (int, int)) -> bool:
        return 0 <= coordinates[0] < self.dimensions[0] and \
               0 <= coordinates[1] < self.dimensions[1]

    def get_shape(self) -> (int, int):
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

    def rain(self, pattern=None) -> np.ndarray:
        if pattern is None:
            rain_grid = \
                np.ones(self.landscape.get_shape())
        else:
            rain_grid = pattern
        return rain_grid

    def get_neighbours(self, position: (int, int), lower=False)\
            -> list:
        neighbours = []
        land_grid = self.landscape.grid
        water_grid = self.waterscape.grid
        for i in range(-1, 2):
            for j in range(-1, 2):
                n_r = position[0] + i
                n_c = position[1] + j
                if (i != 0 or j != 0) and \
                        self.landscape.is_valid_position((n_r, n_c)) and\
                        (not lower or
                         land_grid[position] + water_grid[position]
                         > land_grid[n_r][n_c] + water_grid[n_r][n_c]):
                    neighbours.append(
                        (- land_grid[n_r][n_c] - water_grid[n_r][n_c], (n_r, n_c))
                    )
        # heapq.heapify(neighbours)
        return neighbours

    def disperse(self, rain_grid: np.ndarray, position: (int, int))\
            -> np.ndarray:
        neighbours = self.get_neighbours(position, lower=True)
        water_spilled = rain_grid[position]
        if len(neighbours) > 0:
            rain_grid[position] = 0
        for neighbour in neighbours:
            rain_grid[neighbour[1]] += \
                water_spilled / len(neighbours)
        return rain_grid

    def find_ponds(self, rain_grid: np.ndarray) -> list:
        included = []
        ponds = []
        for pos in rain_grid:
            if rain_grid[pos] > 0 and pos not in included:
                included.append(pos)
                pond = self.get_contagiously_connected(
                    rain_grid, included, pos)

                ponds.append(pond)
        return ponds

    def get_contagiously_connected(
            self, rain_grid: np.ndarray, included: list,
            pos, pond=None) -> list:
        if pond is None:
            pond = []
        neighbours = self.get_neighbours(pos)
        for neighbour in neighbours:
            if rain_grid[pos] > 0 and pos not in included:
                included.append(pos)
                pond.append(neighbour)
                self.get_contagiously_connected(
                    rain_grid, included, neighbour, pond=pond)
        return pond

    def level(self, rain_grid: np.ndarray, pond: list) -> np.ndarray:
        new_rain_grid = rain_grid.copy()
        total_rain = sum(rain_grid[pos] for pos in pond)

        return new_rain_grid

    def tick(self, rain_pattern: np.ndarray):
        rain_grid = self.rain(rain_pattern)
        rain_height = self.landscape.get_height()

        lw_descend = []
        for rows in range(len(self.landscape.grid)):
            for cols in range(len(self.landscape.grid[rows])):
                pos = (rows, cols)
                heapq.heappush(
                    lw_descend, ((- self.landscape.grid[pos]
                                  - self.waterscape.grid[pos]), pos)
                )

        for (height, pos) in lw_descend:
            # if -height < rain_height:
            #     ponds = self.find_ponds(rain_grid)
            #     for pond in ponds:
            #         rain_grid = self.level(rain_grid, pond)
            #     rain_height = -height

            rain_grid = self.disperse(rain_grid, pos)

        self.waterscape.grid += rain_grid


if __name__ == "__main__":
    init(wrap=False)
    np.random.seed(SEED)
    ls = Landscape((10, 10, 20))
    cbm = CarpetBombModel(ls)
    cbm.display()
    for i in range(10):
        cbm.tick(cbm.rain())
        cbm.display()

