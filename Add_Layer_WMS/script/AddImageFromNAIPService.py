import sys, os, urllib2
from xml.etree import ElementTree

# constants
IMG_FMT = "jpgpng"
IMG_EXT = ".png"
IMG_WD = 3000
IMG_HT = 3000

# parse command line arguments
inPdf = sys.argv[1]
inWms = "http://isse.cr.usgs.gov/arcgis/rest/services/Orthoimagery/USGS_EROS_Ortho_NAIP/ImageServer/exportImage?"

inBase = os.path.splitext(inPdf)[0]
inLayers = "USGS_EROS_Ortho_NAIP"
tempXml = inBase+".xml"
tempImage = inBase+IMG_EXT
tempGeoTiff = inBase+".tif"
OutGeoTiff = inBase+"_out.tif"
tempSdkXml = inBase+".xml"

outPdf = inBase+"_out.pdf"

# dump GeoPDF neatline to xml
cmdTemplate = 'tgo_composer -dump -pdf="{pdf}" -xml="{xml}" -asWgs84 -neatlineOnly -verbose'
cmdStr = cmdTemplate.format(pdf=inPdf, xml=tempXml)
print cmdStr
os.system(cmdStr)


# parse XML for neatline bbox
with open(tempXml, 'rt') as f:
    tree = ElementTree.parse(f)

    minX = minY = 180.0
    maxX = maxY = -180.0
    for pt in tree.findall(".//neatline/points/point/geographic"):
        x = float(pt.attrib.get("lon"))
        y = float(pt.attrib.get("lat"))
        minX = min(x, minX)
        minY = min(y, minY)
        maxX = max(x, maxX)
        maxY = max(y, maxY)

    print "min=[%f, %f]" % (minX, minY)
    print "max=[%f, %f]" % (maxX, maxY)

f.close()
os.remove(tempXml)


# fetch map from WMS
wmsTemplate = "{wms}&BBOX={minX},{minY},{maxX},{maxY}&BBOXSR=4326&SIZE={width},{height}&IMAGESR=4326&FORMAT={fmt}&pixelType=S16&f=image"
wmsStr = wmsTemplate.format(wms=inWms, minX=minX, minY=minY, maxX=maxX, maxY=maxY, width=IMG_WD, height=IMG_HT, fmt=IMG_FMT)
print wmsStr
request = urllib2.Request(url=wmsStr)
img = urllib2.urlopen(request)
f = open(tempGeoTiff, 'wb')
f.write(img.read())
f.close()
img.close


# convert image to GeoTIFF
cmdTemplate = 'gdal_translate -of GTiff -b 1 -b 2 -b 3 -b mask -a_srs EPSG:4326 -a_ullr {minX} {maxY} {maxX} {minY} "{tmpImg}" "{outTif}"'
cmdStr = cmdTemplate.format(tmpImg=tempGeoTiff, outTif=OutGeoTiff, minX=minX, minY=minY, maxX=maxX, maxY=maxY)
print cmdStr
os.system(cmdStr)


# build SDK xml
xmlTemplate = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<geoDoc version="1.0">
  <pages>
    <page number="0">
      <content action="insertFirst" url="{geoTiff}" type="TIFF" createLayer="true" layerName="{layer}" referenceFrame="largestPaper"/>
    </page>
  </pages>
</geoDoc>'''
xmlStr = xmlTemplate.format(outPdf=outPdf, geoTiff=OutGeoTiff, layer=inLayers)
f = open(tempSdkXml, 'wb')
f.write(xmlStr)
f.close()


# add GeoTIFF using SDK 
cmdTemplate = 'tgo_composer -assemble -pdf="{pdf}" -output="OUT\{outPdf}" -xml="{xml}" -verbose -product=TGO_Composer -vendor=TerraGo'
cmdStr = cmdTemplate.format(pdf=inPdf, outPdf=outPdf, xml=tempSdkXml)
print cmdStr
os.system(cmdStr)
