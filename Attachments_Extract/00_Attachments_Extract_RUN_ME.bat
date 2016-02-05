if exist extract_attachment.gpkg del extract_attachment.gpkg
tgo_composer -dump -pdf=12SUE9706979349_geo.pdf -attachmentID=Layers-8402.gpkg -output=extracted_12SUE9706979349.gpkg -verbose=debug -product=TGO_Composer -vendor=TERRAGO
