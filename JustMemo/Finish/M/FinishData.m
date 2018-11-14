//
//  FinishData.m
//  JustMemo
//
//  Created by shivill on 2018/11/13.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "FinishData.h"
#import "FinishTool.h"

@implementation FinishData

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

- (NSString *)finTime
{
    if(_finTime == nil)
    {
        _finTime = [[NSString alloc] init];
    }
    return _finTime;
}

-(NSMutableArray *)queryWithData
{
    return [FinishTool queryWithNote];
}

-(void)insertData:(FinishData *)addNote
{
    [FinishTool insertNote:addNote];
}

- (void)deleteData:(int)ids
{
    [FinishTool deleteNote:ids];
}

- (void)updateData:(FinishData *)updateNote
{
    [FinishTool updateNote:updateNote];
}

- (FinishData *)queryOneNote:(int)ids
{
    return [FinishTool queryOneNote:ids];
}

@end
