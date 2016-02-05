@echo OFF
setLocal EnableDelayedExpansion

:Remove Attachements via SDK
for %%a in ("*.pdf") do (

	echo remove attachments
	set xml_fn="%%~na_RmAtt.xml"
	break> !xml_fn!
	echo ^<?xml version="1.0" encoding="UTF-8" standalone="no" ?^> >> !xml_fn!
	echo ^<geoDoc^> >> !xml_fn!
	echo 	^<attachments action="remove"/^> >> !xml_fn!
	echo ^</geoDoc^> >> !xml_fn!
		
	tgo_composer -pdf=%%a -xml=!xml_fn! -output="%%~na_OUT.pdf" -georeg -product=TGO_Composer -vendor=TerraGo -verbose
	rem del !xml_fn!
	)
)