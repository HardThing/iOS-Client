//
//  STEngine.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STEngine : NSObject

- (NSString *)getDataListFile:(NSString *)fileName;
/**
 Load data from list file.
 @param fileName The data list file name.
 */
- (NSMutableArray *)loadDataFromFile:(NSString *)fileName;
/**
 Save data array to list file.
 @param array The data array.
 @param fileName The data list file name.
 */
- (void)saveDataToFileWithArray:(NSMutableArray *)array fileName:(NSString *)fileName;
/**
 Add data to list file.
 @param string The string data has been saved.
 @param dataArray The data array of list file.
 @param fileName The data list file name.
 */
- (void)addData:(NSString*)string type:(NSMutableArray *)dataArray fileName:(NSString *)fileName;
/**
 Remove data of the list file.
 @param fileName The data list file name.
 */
- (void)cleanData:(NSString *)fileName;


- (NSString *)saveAppIcons:(NSString *)urlStr;
@end
