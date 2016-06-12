//
//  STEngine.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STEngine.h"

@implementation STEngine

- (NSString *)getDataListFile:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
             objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

- (NSMutableArray *)loadDataFromFile:(NSString *)fileName
{
    NSString *path = [self getDataListFile:fileName];
    NSLog(@"loadDataFromFile path is %@", path);
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSInteger dataCount = [dict count];
    
    for (int i = 0; i < dataCount; i++)
    {
        NSArray *array = [dict objectForKey:[NSString stringWithFormat:@"%d",i]];
        if (array)
        {
            [dataArray addObject:[array objectAtIndex:0]];
        }
    }
    return dataArray;
}

- (void)saveDataToFileWithArray:(NSMutableArray *)array fileName:(NSString *)fileName
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (int i = 0; i < [array count]; i++)
    {
        NSArray *object = [[NSArray alloc] initWithObjects:[array objectAtIndex:i], nil];
        [dict setObject:object forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSString * result = [self getDataListFile:fileName];
    NSLog(@"result is %@", result);
    [dict writeToFile:result atomically:YES];
}

- (void)addData:(NSString*)string type:(NSMutableArray *)dataArray fileName:(NSString *)fileName
{
    BOOL result = NO;
    for (NSString *data in dataArray)
    {
        result = [string caseInsensitiveCompare:data] == NSOrderedSame;
        if (result)
        {
            [dataArray removeObject:data];
            [dataArray insertObject:string atIndex:0];
            break;
        }
    }
    if (!result)
    {
        [dataArray insertObject:string atIndex:0];
    }
    [self saveDataToFileWithArray:dataArray fileName:fileName];
}

- (void)cleanData:(NSString *)fileName
{
    NSString *path = [self getDataListFile:fileName];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [dict removeAllObjects];
    [dict writeToFile:path atomically:YES];
}


#pragma mark - AdsFile

- (NSString *)saveAppIcons:(NSString *)urlStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURLResponse *response;
    NSString *filePath;
    NSString *directory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/appIcons"];
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0] returningResponse:&response error:nil];
    filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",response.suggestedFilename]];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        
    }
    return filePath;
}
@end
