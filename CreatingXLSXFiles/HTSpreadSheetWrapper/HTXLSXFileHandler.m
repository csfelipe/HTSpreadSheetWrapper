//
//  HTXLSXFileHandler.m
//  HTSpreadSheetWrapper
//
//  Created by Felipe on 8/25/16.
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

#import "HTXLSXFileHandler.h"
#import "XlsxReaderWriter.h"
#import "xlsxwriter.h"

static NSString * const XLSX_EXTENSION                  = @"xlsx";
static NSString * const XLSX_SECTION_TITLE_TEST_CASE    = @"TAB CASE";
static NSString * const XLSX_SECTION_TITLE_DATE         = @"DATE";
static NSString * const XLSX_SECTION_TITLE_STATE        = @"STATE";
static NSString * const XLSX_SECTION_TITLE_DESC         = @"DESCRIPTION";

@interface HTXLSXFileHandler ()
@property (nonatomic,strong) HTXLSXFileHandlerConfigurator *configurator;
@end

@implementation HTXLSXFileHandler

#pragma mark - Initialization & Life Cycle

- (void)privateInit {
    _title          = @"__TITLE__";
    _outputFileName = @"__OUTPUT_FILE_NAME__";
    _customFilePath = @"__CUSTOM_FILE_PATH__";
    _outputFilePath = @"__OUTPUT_FILE_PATH__";
    _tabNames       = @[@"__ITEM__"];
    _content        = @[];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self privateInit];
    }
    return self;
}

- (void)setupConfigurator:(HTXLSXFileHandlerConfigurator *)configurator {
    self.configurator = configurator;
}

- (void)setupFileWithTitle:(NSString*)title {
    _title = title;
}

- (void)setupFileWithTitle:(NSString*)title andOutputName:(NSString*)outputName {
    _title          = title;
    _outputFileName = outputName;
}

- (void)setupFileWithTitle:(NSString*)title andCustomPath:(NSString*)path {
    _title          = title;
    _customFilePath = path;
}

- (void)setupFileWithTitle:(NSString*)title outputName:(NSString*)outputName andCustomPath:(NSString*)path {
    _title          = title;
    _outputFileName = outputName;
    _customFilePath = path;
}

- (void)setupTabNames:(NSArray<NSString*>*)tabNames {
    _tabNames = [NSArray arrayWithArray:tabNames];
}

- (void)content:(NSArray *)content {
    _content = [NSArray arrayWithArray:content];
}

- (void)create {
    [self prepareCustomPathForFolder];
    [self setup];
}

- (NSString*)outputFilePath {
    NSAssert(self.outputFileName, @"outputFileName needs to be overridden in subclasses");
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = @"";
    if (![_customFilePath isEqualToString:@"__CUSTOM_FILE_PATH__"]) {
        filePath   = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", self.customFilePath,self.outputFileName]] stringByAppendingPathExtension:XLSX_EXTENSION];
    } else {
        filePath   = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.outputFileName]] stringByAppendingPathExtension:XLSX_EXTENSION];
    }
    return filePath;
}

#pragma mark - Helpers

- (void)echo {
    printf("\n\tXLSX File:");
    printf("\n\t\tTitle             : %s", self.title.UTF8String);
    printf("\n\t\tOutput File Name  : %s", self.outputFileName.UTF8String);
    printf("\n\t\tOutput File Path  : %s", self.outputFilePath.UTF8String);
    printf("\n\t\tTab Name          : [%s]\n\n", [self stringFromArray:self.tabNames].UTF8String);
}

- (void)prepareCustomPathForFolder {
    if (_customFilePath) {
        NSArray  *documentPaths          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [documentPaths objectAtIndex:0];
        NSString *folderPath             = [documentsDirectoryPath stringByAppendingPathComponent:_customFilePath];
        
        // if folder doesn't exist, create it
        BOOL isDir;
        NSError *error  = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (! [fileManager fileExistsAtPath:folderPath isDirectory:&isDir]) {
            BOOL success = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (!success || error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            NSAssert(success, @"Failed to create folder at path:%@", folderPath);
        }
    }
}

- (void)setup {
    if (!self.configurator) {
        NSAssert(NO, @"Configurator must be initialized");
    }
    
    int row = 0;
    lxw_workbook  *workbook  = new_workbook([self.outputFilePath fileSystemRepresentation]);
    lxw_worksheet *worksheet = NULL;
    lxw_format    *bold      = workbook_add_format(workbook);
    format_set_bold(bold);
    
    NSString *lastDescriptor = @"";
    NSMutableArray *sortedContent = [[self sortedContent] copy];
    for (int i=0; i<_content.count; i++) {
        NSDictionary *aDictionary   = sortedContent[i];
        NSString *currentDescriptor = aDictionary[[[self configurator] key]];
        if (![currentDescriptor isEqualToString:lastDescriptor]) {
            row             = 0;
            lastDescriptor  = [currentDescriptor copy];
            worksheet       = workbook_add_worksheet(workbook, currentDescriptor.UTF8String);
            
            for (int j=0; j<[[self configurator]titles].count; j++) {
                NSString *aTitle = self.configurator.titles[j];
                worksheet_write_string(worksheet, row, j, aTitle.UTF8String, bold);
            }
        }
        
        row++;
        for (int k=0; k<[[self configurator]keys].count; k++) {
            NSString *aKey = self.configurator.keys[k];
            NSString *aValue = aDictionary[aKey];
            worksheet_write_string(worksheet, row, k, aValue.UTF8String,  NULL);
        }
    }
    workbook_close(workbook);
}

- (void)update {
    if (!self.configurator) {
        NSAssert(NO, @"Configurator must be initialized");
    }
    //get spreadsheet
    BRAOfficeDocumentPackage *spreadsheet = [BRAOfficeDocumentPackage open:self.outputFilePath];
    //get possible new sheet names
    NSMutableArray *titlesForWorkSheets = [[NSMutableArray alloc]initWithArray:[self titlesForWorkSheets]];

    //check for sheets that already exist
    NSMutableArray *sheetsThatAlreadyExist = [[NSMutableArray alloc]init];
    for (BRASheet *aWorkSheet in spreadsheet.workbook.sheets) {
        if ([titlesForWorkSheets containsObject:aWorkSheet.name]) {
            [sheetsThatAlreadyExist addObject:aWorkSheet.name];
        }
    }

    //remove the that already exist
    [titlesForWorkSheets removeObjectsInArray:sheetsThatAlreadyExist];

    //in case there are new sheets to be created then create
    if (titlesForWorkSheets.count > 0) {
        for (NSString *aNewWorkSheet in titlesForWorkSheets) {
            [spreadsheet.workbook createWorksheetNamed:aNewWorkSheet];
        }
    }
    
    //gets all indexes for each sheet title
    NSDictionary *indexInfo       = [self informationOnIndexMatchForSpreadsheet:spreadsheet];
    int row                       = 0;
    NSMutableArray *sortedContent = [[self sortedContent] copy];
    NSString *lastDescriptor      = @"";
    NSNumber *index               = @(1);
    BRAWorksheet *aWorkSheet      = nil;
    
    //fills in the sheet
    for (int i=0; i<_content.count; i++) {
        NSDictionary *aDictionary   = sortedContent[i];
        NSString *currentDescriptor = aDictionary[[[self configurator]key]];
        if (![lastDescriptor isEqualToString:currentDescriptor]) {
            lastDescriptor = [currentDescriptor copy];
            index          = indexInfo[lastDescriptor];
            aWorkSheet     = spreadsheet.workbook.worksheets[index.intValue];
            row            = [self nextAvailableRowForSheet:aWorkSheet];
            //creating the header row in case this sheet is new
            if (row == 1) {
                for (int j=0; j<[[self configurator]titles].count; j++) {
                    NSString *aTitle        = [[self configurator]titles][j];
                    NSString *cellReference = [NSString stringWithFormat:@"%@%@", [self columnBasedOnIndex:j],@(row)];
                    [[aWorkSheet cellForCellReference:cellReference shouldCreate:YES] setStringValue:aTitle];
                }
                row++;
            }
        } else {
            row++;
        }
        
        for (int k=0; k<[[self configurator]keys].count; k++) {
            NSString *aKey          = [[self configurator]keys][k];
            NSString *aValue        = aDictionary[aKey];
            NSString *cellReference = [NSString stringWithFormat:@"%@%@", [self columnBasedOnIndex:k],@(row)];
            [[aWorkSheet cellForCellReference:cellReference shouldCreate:YES] setStringValue:aValue];
        }
    }
    
    //saving all changes in the sheet
    [spreadsheet save];
}

- (int)nextAvailableRowForSheet:(BRAWorksheet*)sheet {
    int nextAvailableIndex = 1;
    BOOL finished = NO;
    //some people just want to see the world burn
    while (!finished) {
        NSString *cell = [NSString stringWithFormat:@"A%@",@(nextAvailableIndex)];
        NSString *cellContent = [[sheet cellForCellReference:cell] stringValue];
        if ([cellContent isEqualToString:@""] || cellContent.length == 0) {
            finished = YES;
        } else {
            nextAvailableIndex++;
        }
    }
    return nextAvailableIndex;
}

- (NSDictionary*)informationOnIndexMatchForSpreadsheet:(BRAOfficeDocumentPackage*)spreadsheet {
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    for (int i=0; i<spreadsheet.workbook.sheets.count; i++) {
        BRASheet *aWorkSheet = spreadsheet.workbook.sheets[i];
        [info setObject:@(i) forKey:aWorkSheet.name];
    }
    return info;
}

#pragma mark - Support Methods

- (BOOL)doWeHaveTabs {
    if (self.tabNames.count > 0) {
        if (self.tabNames.count == 1 && [self.tabNames[0] isEqualToString:@"__ITEM__"]) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)stringFromArray:(NSArray*)array {
    NSString *string = @"";
    for (int i=0; i<array.count;i++) {
        if (i==(array.count-1)) {
            string = [NSString stringWithFormat:@"%@(%@)", string,array[i]];
        }
        else {
            string = [NSString stringWithFormat:@"%@(%@),", string,array[i]];
        }
    }
    return string;
}

- (NSArray<NSString*>*)titlesForWorkSheets {
    NSString *lastDescriptorValue  = @"";
    NSMutableArray *sortedContent  = [[self sortedContent] copy];
    NSMutableArray *uniqueNewTabs  = [[NSMutableArray alloc]init];
    
    for (int i=0; i<_content.count; i++) {
        NSDictionary *aDictionary   = sortedContent[i];
        NSString *currentDescriptor        = aDictionary[[[self configurator] key]];
        if (![currentDescriptor isEqualToString:lastDescriptorValue]) {
            lastDescriptorValue = currentDescriptor;
            [uniqueNewTabs addObject:lastDescriptorValue];
        }
    }
    return uniqueNewTabs;
}

- (NSMutableArray*)sortedContent {
    NSSortDescriptor *descriptor  = [[NSSortDescriptor alloc] initWithKey:[self.configurator key] ascending:YES];
    return [[NSMutableArray alloc]initWithArray:[_content sortedArrayUsingDescriptors:@[descriptor]]];

}

- (NSString*)columnBasedOnIndex:(int)index {
    NSString *column = @"";
    BOOL shouldGoOn  = NO;
    int dividedIndex = 0;
    int restOfIndex  = 0;
    
    while (!shouldGoOn) {
        NSString *divisions = @"";
        dividedIndex = index/26;
        restOfIndex  = index%26;
        if (dividedIndex<=0) {
            column = [NSString stringWithFormat:@"%c%@",(index+65),column];
            shouldGoOn = YES;
        } else if (dividedIndex>0) {
            column = [NSString stringWithFormat:@"%c%@",(restOfIndex+65),column];
        }
        index = dividedIndex-1;
        divisions = [NSString stringWithFormat:@"%@%@", divisions,@(index)];
    }
    return column;
}


@end
