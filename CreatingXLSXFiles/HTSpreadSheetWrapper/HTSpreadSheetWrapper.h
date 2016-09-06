//
//  HTSpreadSheetWrapper.h
//  HTSpreadSheetWrapper
//
//  Created by Felipe on 9/1/16.
//  Copyright © 2016 Hueland Tech (huelandproductions@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef HTSpreadSheetWrapper_h
#define HTSpreadSheetWrapper_h

#import "HTXLSXFileHandler.h"
#import "HTCSVFileHandler.h"
#import "HTStandardFileHandlerConfigurator.h"
#import "HTXLSXFileHandlerConfigurator.h"
#endif /* HTSpreadSheetWrapper_h */


/*
 
 ==============================================
 *          INSTRUCTIONS ON HOW TO USE:       *  
 ==============================================
 
 1. Create Group and name it "HTSpreadSheetWrapper" or whatever you want to call it
 2. Add "XlsxReaderWriter.xcodeproj" to "HTSpreadSheetWrapper" group
 3. Add "libxlsxwriter" folder to "HTSpreadSheetWrapper" group
 4. Compile "XlsxReaderWriter Mac"
 5. Go to your projects "TARGET", select "Build Phases", go to "Link Binary With Library"
 6. Select XlsxReaderWriter.framework and press "Add"
 7. Go to "Build Setting" and go to "Header Search Paths" and include these options:
	$(SRCROOT)/HTSpreadSheetWrapper/libxlsxwriter/include					(non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/XlsxReaderWriter\ Mac	(non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/XlsxReaderWriter		(non-recursive)
	$(SRCROOT)/HTSpreadSheetWrapper/XlsxReaderWriter/ThirdParties			(recursive)
 8. Add HTSpreadSheetWrapper.h, HTXLSXFileHandler.h/.m and HTCSVFileHandler.h/.m to "HTSpreadSheetWrapper" group
 9. Don't drink and drive; don't curse and be good to your parents so God will bless you and Santa Clause will bring presents
 
*/