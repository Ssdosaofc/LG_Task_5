import random
import geopandas as gpd
from shapely.geometry import Polygon, MultiPolygon
from lxml import etree
from shapely.geometry import Point

def extract_geometries_from_kml(kml_file):
    tree = etree.parse(kml_file)
    root = tree.getroot()
    
    namespaces = {'kml': 'http://www.opengis.net/kml/2.2'}
    polygons = []
    
    for placemark in root.findall('.//kml:Placemark', namespaces):
        multi_geometry = placemark.find('.//kml:MultiGeometry', namespaces)
        if multi_geometry is not None:
            for geometry in multi_geometry.findall('.//kml:Polygon', namespaces):
                coordinates = geometry.find('.//kml:coordinates', namespaces).text.strip()
                coords = parse_coordinates(coordinates)
                polygons.append(Polygon(coords))
        else:
            polygon = placemark.find('.//kml:Polygon', namespaces)
            if polygon is not None:
                coordinates = polygon.find('.//kml:coordinates', namespaces).text.strip()
                coords = parse_coordinates(coordinates)
                polygons.append(Polygon(coords))
    
    return polygons

def parse_coordinates(coords_text):
    coords = coords_text.split()
    return [(float(coord.split(',')[0]), float(coord.split(',')[1])) for coord in coords]

def generate_random_points(polygons, num_points):
    points = []
    
    for _ in range(num_points):
        polygon = random.choice(polygons)
        minx, miny, maxx, maxy = polygon.bounds
        
        while True:
            point = Point(random.uniform(minx, maxx), random.uniform(miny, maxy))
            if polygon.contains(point):
                points.append(point)
                break
    
    return points

def create_kml(points, output_file):
    kml = etree.Element('kml', xmlns='http://www.opengis.net/kml/2.2')
    document = etree.SubElement(kml, 'Document')
    
    style_yellow = etree.SubElement(document, 'Style', id='yellowStyle')
    icon_style_yellow = etree.SubElement(style_yellow, 'IconStyle')    
    scale = etree.SubElement(icon_style_yellow, 'scale')
    scale.text = '3.5'    
    icon = etree.SubElement(icon_style_yellow, 'Icon')
    href = etree.SubElement(icon, 'href')
    href.text = 'https://raw.githubusercontent.com/Ssdosaofc/image-repo/refs/heads/main/glow.png'

    style_dim = etree.SubElement(document, 'Style', id='dimStyle')
    icon_style_dim = etree.SubElement(style_dim, 'IconStyle')    
    scale = etree.SubElement(icon_style_dim, 'scale')
    scale.text = '1.5'    
    icon = etree.SubElement(icon_style_dim, 'Icon')
    href = etree.SubElement(icon, 'href')
    href.text = 'https://raw.githubusercontent.com/Ssdosaofc/image-repo/refs/heads/main/dim.png'

    style_spread = etree.SubElement(document, 'Style', id='spreadStyle')
    icon_style_spread = etree.SubElement(style_spread, 'IconStyle')    
    scale = etree.SubElement(icon_style_spread, 'scale')
    scale.text = '3'    
    icon = etree.SubElement(icon_style_spread, 'Icon')
    href = etree.SubElement(icon, 'href')
    href.text = 'https://raw.githubusercontent.com/Ssdosaofc/image-repo/refs/heads/main/spread.png'

    
    for i, point in enumerate(points):
        placemark = etree.SubElement(document, 'Placemark')
        name = etree.SubElement(placemark, 'name')
        #name.text = f"Point {i+1}"
        
        style_url = etree.SubElement(placemark, 'styleUrl')
        if i%2== 0:
            style_url.text = '#dimStyle'
        elif i%3==0:
            style_url.text = '#spreadStyle'
        else:
            style_url.text = '#yellowStyle'
        
        point_element = etree.SubElement(placemark, 'Point')
        coordinates = etree.SubElement(point_element, 'coordinates')
        coordinates.text = f"{point.x},{point.y},0"
    
    tree = etree.ElementTree(kml)
    tree.write(output_file, pretty_print=True)


def main(kml_input, num_points, kml_output):
    polygons = extract_geometries_from_kml(kml_input)
    points = generate_random_points(polygons, num_points)
    create_kml(points, kml_output)
    print(f"Generated {num_points} random points with styles and saved to {kml_output}")

kml_input = 'India.kml'  
num_points = 300  
kml_output = 'night_light.kml'  

main(kml_input, num_points, kml_output)
