//
//  CSVParser.m
//  CSVParser
//
//  Created by Ha Minh Vuong on 8/31/12.
//  Copyright (c) 2012 Ha Minh Vuong. All rights reserved.
//

#import "CSVParser.h"

@interface CSVParser()
+ (NSArray *)trimComponents:(NSArray *)array withCharacters:(NSString *)characters;
@end

@implementation CSVParser

+ (NSArray *)trimComponents:(NSArray *)array withCharacters:(NSString *)characters
{
    NSMutableArray *marray = [[NSMutableArray alloc] initWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [marray addObject:[obj stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:characters]]];
    }];
    return marray;
}

+ (NSArray *)parseCSVIntoArrayOfDictionariesFromFile:(NSString *)path
                        withSeparatedCharacterString:(NSString *)character
                                quoteCharacterString:(NSString *)quote
{
    NSError *error = nil;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!content) return nil;
    NSArray *rows = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r"]];
    NSString *trimStr = (quote != nil) ? [quote stringByAppendingString:@"\n\r "] : @"\n\r ";
    NSArray *keys = [CSVParser trimComponents:[[rows objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]]
                               withCharacters:trimStr];
    for (int i = 1; i < rows.count; i++) {
        NSArray *objects = [CSVParser trimComponents:[[rows objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]]
                                      withCharacters:trimStr];
        [mutableArray addObject:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
    }
    return mutableArray;
}


+ (NSArray *)parseCSVIntoArrayOfArraysFromFile:(NSString *)path
                  withSeparatedCharacterString:(NSString *)character
                          quoteCharacterString:(NSString *)quote
{
    NSError *error = nil;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    //NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    if (!content) return nil;
    NSArray *rows = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r"]];
    NSString *trimStr = (quote != nil) ? [quote stringByAppendingString:@"\n\r "] : @"\n\r ";
    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mutableArray addObject:[CSVParser trimComponents:[obj componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]]
                                           withCharacters:trimStr]];
    }];
    return mutableArray;
}

@end
