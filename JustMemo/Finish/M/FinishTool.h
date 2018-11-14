//
//  FinishTool.h
//  JustMemo
//
//  Created by shivill on 2018/11/13.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FinishData;
@interface FinishTool : NSObject

+(NSMutableArray *)queryWithNote;
+(void)insertNote:(FinishData *)finishNote;
+(void)deleteNote:(int)ids;
+(void)updateNote:(FinishData *)finishNote;
+(FinishData *)queryOneNote:(int)ids;

@end

NS_ASSUME_NONNULL_END
