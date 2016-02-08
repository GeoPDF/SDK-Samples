@echo OFF
setLocal EnableDelayedExpansion
:CHKFORMAT
SET "AllowExt=tif ecw img jp2 sid"
SET "AllowExt= %AllowExt%"
SET "AllowExt=%AllowExt: = *.%"


SET /P Qual="Enter the JPEG Quality value: (1-100, 80 is recommended)"
for %%a in (%AllowExt%) do (
	set xml_fn="%%~na_!Qual!.xml"
	break> !xml_fn!
	echo ^<?xml version="1.0" encoding="UTF-8" standalone="no" ?^> >> !xml_fn!
	echo ^<geoDoc version="1.0"^> >> !xml_fn!
	echo 	^<pages^> >> !xml_fn!
	echo 		^<page number="0"^> >> !xml_fn!
	echo 			^<content url="%%a" type="TIFF"^> >> !xml_fn!
	echo 				^<raster^> >> !xml_fn!
	echo 					^<imagePyramid/^> >> !xml_fn!
	echo 					^<compression type="JPEG" quality="!Qual!" /^> >> !xml_fn!
	echo 	 				^<layers type="static"^> >> !xml_fn!
	echo 		 				^<red band="1"/^> >> !xml_fn!
	echo 		 				^<green band="2"/^> >> !xml_fn!
	echo 		 				^<blue band="3"/^> >> !xml_fn!
	echo 	 				^</layers^> >> !xml_fn!
	echo 					^<stretch^> >> !xml_fn!
	echo 						^<histogram standardDeviation="2.5"/^> >> !xml_fn!
	echo 					^</stretch^> >> !xml_fn!	
	echo 				^</raster^> >> !xml_fn!
	echo 			^</content^> >> !xml_fn!
	echo 		^</page^> >> !xml_fn!
	echo  	^</pages^> >> !xml_fn!
	echo ^</geoDoc^> >> !xml_fn!
	tgo_composer -georeg -output="%%~na_!Qual!.pdf" -xml=!xml_fn! -verbose=debug -product=TGO_Composer -vendor=TerraGo
	del !xml_fn!
)
GOTO :EOF