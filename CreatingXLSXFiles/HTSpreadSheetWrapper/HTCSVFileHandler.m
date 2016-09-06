//
//  HTCSVFileCreator.m
//  HTSpreadSheetWrapper
//
//  Created by Felipe on 8/29/16.
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

#import "HTCSVFileHandler.h"


static NSString * const CSV_EXTENSION = @"csv";
static NSString * const CSV_SEPARATOR = @"|#|";

@interface HTCSVFileHandler ()
@property (nonatomic,strong) HTCSVFileHandlerConfigurator *configurator;
@end

@implementation HTCSVFileHandler
#pragma mark - Initialization & Life Cycle

- (void)privateInit {
    _title          = @"__TITLE__";
    _outputFileName = @"__OUTPUT_FILE_NAME__";
    _customFilePath = @"__CUSTOM_FILE_PATH__";
    _outputFilePath = @"__OUTPUT_FILE_PATH__";
    _content        = @[];
}



- (instancetype)init {
    self = [super init];
    if (self) {
        [self privateInit];
    }
    return self;
}

- (void)setupConfigurator:(HTCSVFileHandlerConfigurator*)configurator {
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

- (void)content:(NSArray *)content {
    _content = [NSArray arrayWithArray:content];
}

- (void)run {
    [self prepareCustomPathForFolder];
    [self setup];
}

- (NSString*)outputFilePath {
    NSAssert(self.outputFileName, @"outputFileName needs to be overridden in subclasses");
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = @"";
    if (![_customFilePath isEqualToString:@"__CUSTOM_FILE_PATH__"]) {
        filePath   = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", self.customFilePath,self.outputFileName]] stringByAppendingPathExtension:CSV_EXTENSION];
    } else {
        filePath   = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.outputFileName]] stringByAppendingPathExtension:CSV_EXTENSION];
    }
    return filePath;
}

#pragma mark - Helpers

- (void)echo {
    printf("\n\tCSV File:");
    printf("\n\t\tTitle             : %s", self.title.UTF8String);
    printf("\n\t\tOutput File Name  : %s", self.outputFileName.UTF8String);
    printf("\n\t\tOutput File Path  : %s", self.outputFilePath.UTF8String);
}

- (void)prepareCustomPathForFolder {
    if (![self doesFileExist]) {
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
}

- (BOOL)doesFileExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.outputFilePath];
}

- (void)setup {
    if (!self.configurator) {
        NSAssert(NO, @"Configurator must be initialized");
    }
    
    NSSortDescriptor *descriptor  = [[NSSortDescriptor alloc] initWithKey:[[self configurator] key] ascending:YES];
    NSMutableArray *sortedContent = [[NSMutableArray alloc]initWithArray:[_content sortedArrayUsingDescriptors:@[descriptor]]];
    
    NSString *csvString = @"";
    if ([self doesFileExist]) {
        csvString = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:self.outputFilePath] encoding:NSUTF8StringEncoding error:NULL];
    }

    for (int i=1; i<[sortedContent count]; i++) {
        NSDictionary *aDictionary   = sortedContent[i];
        //        NSString *testCaseId        = aDictionary[@"tabId"];
        //        NSString *date              = aDictionary[@"date"];
        //        NSString *state             = aDictionary[@"state"];
        //        NSString *description       = aDictionary[@"description"];
        
        for (int j=0; j<[[self configurator]keys].count; j++) {
            NSString *aKey  = self.configurator.keys[j];
            NSString *aValue = aDictionary[aKey];
            if (j==(self.configurator.keys.count-1)) {
                csvString = [csvString stringByAppendingFormat:@"%@\n",aValue];
            } else {
                csvString = [csvString stringByAppendingFormat:@"%@,",aValue];
            }
        }
        
        //csvString = [csvString stringByAppendingFormat:@"%@%@%@%@%@%@%@\n", testCaseId,CSV_SEPARATOR,date,CSV_SEPARATOR,state,CSV_SEPARATOR,description];
    }
    
    [csvString writeToFile:self.outputFilePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}



@end
