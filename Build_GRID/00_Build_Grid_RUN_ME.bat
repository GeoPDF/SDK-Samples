@echo OFF
setLocal EnableDelayedExpansion
echo --
echo Extracting XML from PDF files

for %%a in ("*.pdf") do (
	set xml_fn="%%~na.xml"
 	tgo_composer -pdf=%%a -xml=!xml_fn! -product="TGO_Composer" -vendor="TerraGo" -dump -map=largestPaper -asWgs84 -neatlineOnly
	echo --
)

echo --
echo Writing KML...
set lf="00_GeoPDF_Index.kml"
echo ^<?xml version="1.0" encoding="utf-8" ?^> > !lf!
echo ^<kml xmlns="http://www.opengis.net/kml/2.2"^> >> !lf!
echo ^<Document^>^<Folder^>^<name^>GeoPDF_footprints^</name^> >> !lf!
echo 	^<Schema name="GeoPDF footprints" id="GeoPDF_footprints"^>^</Schema^> >> !lf!

for %%b in ("*.xml") do (
	set fn=%%b
	echo 	^<Placemark^> >> !lf!
	echo 		^<name^>%%~nb^</name^> >> !lf!
	echo 		^<description^>%~dp0%%~nb.pdf^</description^> >> !lf!	
	echo 		^<Polygon^>^<outerBoundaryIs^>^<LinearRing^>^<coordinates^>  >> !lf!
	for /F delims^=^"^ tokens^=2^,4 %%d in ('findstr /I /R /C:"geographic lon" !fn!') do echo.			%%d,%%e>>!lf!
	echo 		^</coordinates^>^</LinearRing^>^</outerBoundaryIs^>^</Polygon^> >> !lf!
	echo 		^<Style^>^<LineStyle^>^<color^>ff0000ff^</color^>^</LineStyle^>  ^<PolyStyle^>^<fill^>0^</fill^>^</PolyStyle^>^</Style^> >> !lf!
	echo 	^</Placemark^> >> !lf!
)
echo ^</Folder^>^</Document^>^</kml^> >> !lf!

echo --
echo KML to Shapefile conversion...
echo --

rem IF NOT EXIST "00_Output\shapefile" MKDIR 00_Output\shapefile
rem ogr2ogr -f "ESRI Shapefile" "00_output\shapefile\00_GeoPDF_Index.shp" "!lf!"

::clean up
del /q "*.xml"
GOTO EOF

echo Process Complete...
echo --
