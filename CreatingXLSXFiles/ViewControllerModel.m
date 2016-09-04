//
//  ViewControllerModel.m
//  CreatingXLSXFiles
//
//  Created by gringo  on 9/3/16.
//  Copyright © 2016 Hueland Tech. All rights reserved.
//

#import "ViewControllerModel.h"

@implementation ViewControllerModel

- (NSArray*)fakeTesteCase {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm.sss"];
    
    NSArray *states       = @[@"PASSED",@"FAILED",@"VERIFIED"];
    NSArray *descriptions = @[@"A computer once beat me at chess, but it was no match for me at kick boxing.",
                              @"Save the earth. It's the only planet with chocolate.",
                              @"Always forgive your enemies - Nothing annoys them so much.",
                              @"I'm not so good with the advice. Can I interest you in a sarcastic comment?",
                              @"No I won't go to hell! It has a restraining order against me.",
                              @"Never take life seriously. Nobody gets out alive anyway.",
                              @"You’re just jealous because the voices only talk to me."];
    
    int max = 500;
    NSMutableArray *tests = [[NSMutableArray alloc]init];
    
    for (int i=0; i<max; i++) {
        NSDate *now = [NSDate date];
        NSString *date = [formatter stringFromDate:now];
        
        int testCaseIndex = arc4random()%78;
        NSString *tabId = [NSString stringWithFormat:@"TAB-%03d", testCaseIndex];
        
        
        int stateIndex = arc4random()%states.count;
        NSString *state =  states[stateIndex];
        
        int descriptionIndex = arc4random()%states.count;
        NSString *description =  descriptions[descriptionIndex];
        
        [tests addObject:@{
                           @"tabId":tabId,
                           @"date":date,
                           @"state":state,
                           @"description":description
                           }];
    }
    return tests;
}

- (NSString*)includeDateOnThisName:(NSString*)name {
    NSDate *now                 = [NSDate date];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmm"];
    return [NSString stringWithFormat:@"%@-%@",name,[formatter stringFromDate:now]];
}

@end
