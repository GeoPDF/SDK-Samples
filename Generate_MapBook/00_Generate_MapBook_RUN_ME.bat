@echo off

echo f | xcopy %CD%\OriginalSources %CD%\Mapbook_OUT /y /s
tgo_composer -xml=mapbook.xml -georeg -verbose=debug -product=TGO_Composer -vendor=TerraGo