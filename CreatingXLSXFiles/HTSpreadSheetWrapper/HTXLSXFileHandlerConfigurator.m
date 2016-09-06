//
//  HTXLSXFileHandlerConfigurator.m
//  CreatingXLSXFiles
//
//  Created by gringo  on 9/5/16.
//  Copyright © 2016 Hueland Tech. All rights reserved.
//

#import "HTXLSXFileHandlerConfigurator.h"

@interface HTXLSXFileHandlerConfigurator ()
@property (nonatomic,strong) NSArray *currentTitles;
@end

@implementation HTXLSXFileHandlerConfigurator
- (void)fileTitles:(NSArray*)titles {
    self.currentTitles = [titles copy];
}

- (NSArray*)titles {
    if (!self.currentTitles)
        return @[];
    return self.currentTitles;
}
@end
