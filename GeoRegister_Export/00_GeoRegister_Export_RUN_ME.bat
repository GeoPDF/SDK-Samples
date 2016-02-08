@echo OFF
setLocal EnableDelayedExpansion

for %%a in ("*.pdf") do (
	tgo_composer -pdf=%%a -xml=%%~na_neatlineOnly_WGS84.xml -product="TGO_Composer" -vendor="TerraGo" -dump -map=largestPaper -asWgs84 -neatlineOnly
	tgo_composer -pdf=%%a -xml=%%~na_All.xml -product="TGO_Composer" -vendor="TerraGo" -dump -map=largestPaper
	tgo_composer -pdf=%%a -xml=%%~na_All_WGS84.xml -product="TGO_Composer" -vendor="TerraGo" -dump -map=largestPaper -asWgs84
	
)	
