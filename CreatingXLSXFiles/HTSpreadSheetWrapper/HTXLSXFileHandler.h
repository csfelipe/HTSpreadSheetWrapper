//
//  HTXLSXFileCreator.h
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

#import <Foundation/Foundation.h>

@protocol HTXLSXFileHandlerProtocol <NSObject>
@property (readonly, nonatomic, copy) NSString *title;
@property (readonly, nonatomic, copy) NSString *outputFileName;
@property (readonly, nonatomic, copy) NSString *customFilePath;
@property (readonly, nonatomic, copy) NSString *outputFilePath;
@property (readonly, nonatomic, strong) NSArray<NSString*> *tabNames;
@property (readonly, nonatomic, strong) NSArray<NSDictionary*> *content;
@end

@interface HTXLSXFileHandler : NSObject <HTXLSXFileHandlerProtocol> {
    @protected
    NSString *_title;
    NSString *_outputFileName;
    NSString *_customFilePath;
    NSString *_outputFilePath;
    NSArray<NSString*> *_tabNames;
    NSArray<NSDictionary*> *_content;
}
@property (readonly, nonatomic, copy) NSString *title;
@property (readonly, nonatomic, copy) NSString *outputFileName;
@property (readonly, nonatomic, copy) NSString *customFilePath;
@property (readonly, nonatomic, copy) NSString *outputFilePath;
@property (readonly, nonatomic, strong) NSArray<NSString*> *tabNames;
@property (readonly, nonatomic, strong) NSArray<NSDictionary*> *content;
- (void)setupFileWithTitle:(NSString*)title;
- (void)setupFileWithTitle:(NSString*)title andOutputName:(NSString*)outputName;
- (void)setupFileWithTitle:(NSString*)title andCustomPath:(NSString*)path;
- (void)setupFileWithTitle:(NSString*)title outputName:(NSString*)outputName andCustomPath:(NSString*)path;
- (void)setupTabNames:(NSArray<NSString*>*)tabNames;
- (void)content:(NSArray*)content;
- (void)create;
- (void)update;
- (void)echo;
- (BOOL)doWeHaveTabs;
@end
