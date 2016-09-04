//
//  ViewController.m
//  CreatingXLSXFiles
//
//  Created by gringo  on 9/3/16.
//  Copyright © 2016 Hueland Tech. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerModel.h"
#import "HTSpreadSheetWrapper.h"
@implementation ViewController {
    ViewControllerModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    model = [[ViewControllerModel alloc]init];
    
    // Creating a XLSX file
    //    NSArray *content    = [model fakeTesteCase];
    //    NSString *name      = [model includeDateOnThisName:@"xlsx_example"];
    //    NSString *path      = @"Randomic/Test/Path";
    //    [self createXLSXFileWithTitle:name name:name customPath:path andContent:content];
    
    // Updating a XLSX file
    //    NSArray *content    = [model fakeTesteCase];
    //    //to be able to update you needd to have the use the same name of the file you intend to update
    //    NSString *name      = @"xlsx_example-201609031829";
    //    //to be able to update you needd to have the use the same path of the file you intend to update
    //    NSString *path      = @"Randomic/Test/Path";
    //    [self updateXLSXFileWithTitle:name name:name customPath:path andContent:content];
    
    // Creating a CSV file
    //    NSArray *content    = [model fakeTesteCase];
    //    NSString *name      = [model includeDateOnThisName:@"csv_example"];
    //    NSString *path      = @"Randomic/Test/Path";
    //    [self createCSVFileWithTitle:name name:name customPath:path andContent:content];
    
    // Updating a CSV file
    //    NSArray *content    = [model fakeTesteCase];
    //    //to be able to update you needd to have the use the same name of the file you intend to update
    //    NSString *name      = @"csv_example-201609031832";
    //    //to be able to update you needd to have the use the same path of the file you intend to update
    //    NSString *path      = @"Randomic/Test/Path";
    //    [self updateCSVFileWithTitle:name name:name customPath:path andContent:content];
}

- (void)createXLSXFileWithTitle:(NSString*)title
                           name:(NSString*)name
                     customPath:(NSString*)path
                     andContent:(NSArray*)content {
    HTXLSXFileHandler *fileHandler = [HTXLSXFileHandler new];
    [fileHandler setupFileWithTitle:title outputName:name andCustomPath:path];
    [fileHandler content:content];
    [fileHandler create];

}

- (void)updateXLSXFileWithTitle:(NSString*)title
                           name:(NSString*)name
                     customPath:(NSString*)path
                     andContent:(NSArray*)content {
    HTXLSXFileHandler *fileHandler = [HTXLSXFileHandler new];
    [fileHandler setupFileWithTitle:title outputName:name andCustomPath:path];
    [fileHandler content:content];
    [fileHandler update];

}

- (void)createCSVFileWithTitle:(NSString*)title
                          name:(NSString*)name
                    customPath:(NSString*)path
                    andContent:(NSArray*)content {
    HTCSVFileHandler *file = [HTCSVFileHandler new];
    [file setupFileWithTitle:title outputName:name andCustomPath:path];
    [file content:content];
    [file run];
}

- (void)updateCSVFileWithTitle:(NSString*)title
                          name:(NSString*)name
                    customPath:(NSString*)path
                    andContent:(NSArray*)content {
    HTCSVFileHandler *file = [HTCSVFileHandler new];
    [file setupFileWithTitle:title outputName:name andCustomPath:path];
    [file content:content];
    [file run];
}

@end
