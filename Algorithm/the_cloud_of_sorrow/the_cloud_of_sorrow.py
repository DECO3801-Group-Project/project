# The Cloud of Sorrow
# +-------------------------------------------------------------------------+
# |  An inundation model. Yes, sorrowful!                                   |
# |                                        - Syed Muhammad Zahir            |
# +-------------------------------------------------------------------------+
__author__ = "Syed Muhammad Zahir"


from itertools import count
from math import cos, pi
from const import *

import requests
import numpy as np

base_api_url = "https://api.open-elevation.com/api/v1/lookup?locations="

class Grid:
    pass

def load_terrain(
        min_lat: float, max_lat: float, 
        min_lon: float, max_lon: float, 
        min_x: float, max_x: float,
        min_z: float, max_z: float, size: int) -> None:
    latitudes = list(np.linspace(MIN_LAT, MAX_LAT, size))
    longitudes = list(np.linspace(MIN_LON, MAX_LON, size))
    locations = [f"{lat},{lon}" for lat in latitudes for lon in longitudes]
    
    file_handle = open("data.json", "a")
    # file_handle.write("{\"results\": [")
    counter = 898300
    
    while counter < len(locations):        
        search_locations = []
        
        # There are at least 100 elements left to search
        if len(locations) - counter >= 100:
            search_locations = locations[counter:counter + 100]
        else:
            search_locations = locations[counter:]
        counter += 100
        
        search_locations = "|".join(search_locations)
        api_url = base_api_url + search_locations
        response = requests.get(api_url)
        terrain_data = {}
        try:
            terrain_data = response.json()
            terrain_data = terrain_data['results']
        except:
            pass
        for position in terrain_data:
            latitude = position['latitude']
            longitude = position['longitude']
            y = position['elevation']
            x, z = lat_lng_to_screen_x_y(latitude, longitude, global_min, global_max)
            file_handle.write("{\"x\": " + str(x) + ", " + "\"z\": " + str(z) + ", " + "\"y\": " + str(y) + "},")
        file_handle.flush()
            
    file_handle.write("]}")
    file_handle.flush()
    file_handle.close()
    

def lat_lng_to_global_x_z(lat, lng):
    x = RADIUS_OF_EARTH * lng * cos(((MIN_LAT + MAX_LAT) * (pi / 180)) / 2)
    z = RADIUS_OF_EARTH * lat
    return (x, z)

global_min = lat_lng_to_global_x_z(MIN_LAT, MIN_LON)
global_max = lat_lng_to_global_x_z(MAX_LAT, MAX_LON)

def lat_lng_to_screen_x_y(lat, lng, global_min, global_max):
    position_x, position_z = lat_lng_to_global_x_z(lat, lng)
    
    dx = (position_x - global_min[0])/(global_max[0] - global_min[0])
    dz = (position_z - global_min[1])/(global_max[1] - global_min[1])

    return (
        min_x + SCREEN_LENGTH * dx,
        min_z + SCREEN_WIDTH * dz
    )

load_terrain(MIN_LAT, MAX_LAT, MIN_LON, MAX_LON, min_x, max_x, min_z, max_z, NUMBER)
class Grid:
    pass

