//
//  JMemoTool.h
//  JustMemo
//
//  Created by shivill on 2018/10/23.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMemoData;

@interface JMemoTool : NSObject

+(NSMutableArray *)queryWithNote;
+(void)insertNote:(JMemoData *)jMemoNote;
+(void)deleteNote:(int)ids;
+(void)updateNote:(JMemoData *)jMemoNote;
+(JMemoData *)queryOneNote:(int)ids;

@end
