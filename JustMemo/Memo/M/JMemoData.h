//
//  JMemoData.h
//  JustMemo
//
//  Created by shivill on 2018/10/23.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMemoData : NSObject

@property (nonatomic,assign) int ids;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *setTime;

- (NSMutableArray *)queryWithData;
- (void)insertData:(JMemoData *)addNote;
- (void)deleteData:(int)ids;
- (void)updateData:(JMemoData *)updateNote;
- (JMemoData *)queryOneNote:(int)ids;

@end
