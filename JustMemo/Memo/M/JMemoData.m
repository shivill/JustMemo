//
//  JMemoData.m
//  JustMemo
//
//  Created by shivill on 2018/10/23.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import "JMemoData.h"
#import "JMemoTool.h"

@implementation JMemoData

- (NSString *)data
{
    if(_data == nil)
    {
        _data = [[NSString alloc]init];
    }
    return _data;
}

- (NSString *)setTime
{
    if(_setTime == nil)
    {
        _setTime = [[NSString alloc] init];
    }
    return _setTime;
}

-(NSMutableArray *)queryWithData
{
    return [JMemoTool queryWithNote];
}

-(void)insertData:(JMemoData *)addNote
{
    [JMemoTool insertNote:addNote];
}

- (void)deleteData:(int)ids
{
    [JMemoTool deleteNote:ids];
}

- (void)updateData:(JMemoData *)updateNote
{
    [JMemoTool updateNote:updateNote];
}

- (JMemoData *)queryOneNote:(int)ids
{
    return [JMemoTool queryOneNote:ids];
}


@end
