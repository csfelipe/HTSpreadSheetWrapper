//
//  HTXLSXFileHandlerConfigurator.h
//  CreatingXLSXFiles
//
//  Created by gringo  on 9/5/16.
//  Copyright © 2016 Hueland Tech. All rights reserved.
//

#import "HTStandardFileHandlerConfigurator.h"

@interface HTXLSXFileHandlerConfigurator : HTStandardFileHandlerConfigurator
- (void)fileTitles:(NSArray*)titles;
- (NSArray*)titles;
@end
