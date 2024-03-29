//
//  HTCSVFileHandlerConfigurator.m
//  CreatingXLSXFiles
//
//  Created by gringo  on 9/5/16.
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

#import "HTStandardFileHandlerConfigurator.h"

@interface HTStandardFileHandlerConfigurator ()
@property (nonatomic,strong) NSArray  *currentFileKeys;
@property (nonatomic,strong) NSString *currentDescriptorKey;
@property (nonatomic,strong) NSNumber *currentDescriptorKeyIndex;
@end

@implementation HTStandardFileHandlerConfigurator

- (void)fileKeys:(NSArray*)keys {
    self.currentFileKeys = [keys copy];
}

- (void)fileKeysFromContent:(NSArray*)content {
    NSDictionary *aPieceOfTheContent = content[0];
    self.currentFileKeys = aPieceOfTheContent.allKeys;
}

- (void)descriptorKey:(NSString*)key {
    self.currentDescriptorKey = [key copy];
}

- (void)descriptorKeyIndex:(NSNumber*)index {
    self.currentDescriptorKeyIndex = [index copy];
}

- (NSArray*)keys {
    if (!self.currentFileKeys)
        return @[];
    return self.currentFileKeys;
}

- (NSString*)key {
    if ([self index] != -1)
        return self.currentFileKeys[[self index]];
    
    if (!self.currentDescriptorKey)
        return @"";
    return self.currentDescriptorKey;
}

- (NSInteger)index {
    if (!self.currentDescriptorKeyIndex)
        return -1;
    return self.currentDescriptorKeyIndex.integerValue;
}

@end
