from skyfield.api import load, wgs84

# Create a timescale and ask the current time.
ts = load.timescale()
t = ts.now()

# Load the JPL ephemeris DE421 (covers 1900-2050).
planets = load('de421.bsp')
earth = planets['earth']

your_location = earth + wgs84.latlon(53.21667, -1.01667)  # Nottinghamshire

planet_names = ['mercury', 'venus', 'mars', 'jupiter barycenter', 'saturn barycenter', 'uranus barycenter', 'neptune barycenter', 'pluto barycenter']

for planet_name in planet_names:
    planet = planets[planet_name]
    astrometric = your_location.at(t).observe(planet)
    apparent = astrometric.apparent()
    alt, az, distance = apparent.altaz()
    
    status = "above horizon" if alt.degrees > 0 else "below horizon"
    print(f'{planet_name.title()}: {alt.degrees:.1f}° altitude - {status}')