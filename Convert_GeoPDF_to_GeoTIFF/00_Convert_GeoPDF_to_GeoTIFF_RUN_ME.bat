@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem prompt user for dpi value
SET /P Qual="Enter DPI value: (300 is recommended)"

rem look inside the folder for content
for /r %%i in (*.pdf) do (
	set xml_fn="%%~ni_!Qual!dpi.xml"
	break > !xml_fn!
	echo ^<?xml version="1.0" encoding="UTF-8" standalone="no" ?^> >> !xml_fn!
	echo ^<geoDoc^> >> !xml_fn!
	echo		^<pages^> >> !xml_fn!
	echo			^<page^> >> !xml_fn!
	echo				^<content url="%%~ni.pdf" page="0" referenceFrame="largestPaper"^> >> !xml_fn!
	echo					^<scale dpi="!Qual!" /^> >> !xml_fn!
	echo				^</content^> >> !xml_fn!
	echo			^</page^> >> !xml_fn!
	echo		^</pages^> >> !xml_fn!
	echo ^</geoDoc^> >> !xml_fn!
	
 	tgo_composer -output="%%~ni_!Qual!dpi.tif" -xml=!xml_fn! -georeg -product="TGO_Composer" -verbose=d -vendor="TerraGo"
	rem del !xml_fn!
)