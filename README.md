# HTSpreadSheetWrapper

HTSpreadSheetWrapper is a simple wrapper that helps you create and update XLSX and CSV files.

This wrapper was build on top of [libxlsxwriter] (https://github.com/jmcnamara/libxlsxwriter) and [XlsxReaderWriter] (https://github.com/renebigot/XlsxReaderWriter).

## Instructions

 1. Create Group and name it "HTSpreadSheetWrapper" or whatever you want to call it
 2. Add `XlsxReaderWriter.xcodeproj` to "HTSpreadSheetWrapper" group
 3. Add "libxlsxwriter" folder to "HTSpreadSheetWrapper" group
 4. Compile `XlsxReaderWriter Mac`
 5. Go to your projects `TARGET`, select `Build Phases`, go to `Link Binary With Library`
 6. Select `XlsxReaderWriter.framework` and press "Add"
 7. Go to `Build Setting` and go to `Header Search Paths` and include these options:
 
 ```
	$(SRCROOT)/HTSpreadSheetWrapper/libxlsxwriter/include	(non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/XlsxReaderWriter\ Mac (non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/XlsxReaderWriter	(non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/ThirdParties	(recursive)
	```
	
 8. Add `HTSpreadSheetWrapper.h`, `HTXLSXFileHandler.h/.m` and `HTCSVFileHandler.h/.m` to "HTSpreadSheetWrapper" group
 9. Don't drink and drive, don't curse and be good to your parents so God will bless you and Santa Clause will bring presents
