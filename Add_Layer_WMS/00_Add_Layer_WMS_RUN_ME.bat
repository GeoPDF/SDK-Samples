@echo OFF
setLocal EnableDelayedExpansion

for %%a in ("*.pdf") do (
	script\AddImageFromNAIPService.py %%a
	del /q "%%~na*.xml"
	del /q "%%~na*.tif"
)
GOTO EOF