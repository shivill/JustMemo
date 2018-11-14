//
//  FinishTool.m
//  JustMemo
//
//  Created by shivill on 2018/11/13.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "FinishTool.h"
#import "FinishData.h"
#import "FMDB.h"

@implementation FinishTool

static FMDatabaseQueue *_queue;

+(void)initialize
{
    //get document filepath from sandbox
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    //append database filename to document filepath,for a usable path
    NSString *path = [documentFolderPath stringByAppendingPathComponent:@"JMemo.sqlite"];
    
    //init a file manager
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //to judge if there have a database file
    BOOL isExist = [fm fileExistsAtPath:path];
    if(!isExist)
    {
        //copy database
        
        //get database filepath from project bundle
        NSString *dbBundlePath = [[NSBundle mainBundle]pathForResource:@"JMemo.sqlite" ofType:nil];
        
        [fm copyItemAtPath:dbBundlePath toPath:path error:nil];
    }
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    
    [_queue inDatabase:^(FMDatabase *db){
        BOOL createResult = [db executeUpdate:@"create table if not exists finishnote(ids INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT,settime TEXT,fintime TEXT,level INT,title TEXT)"];
        if(!createResult)
        {
            NSLog(@"create table error");
        }
        else
        {
            NSLog(@"create finishNote db successful");
        }
    }];

}

+(NSMutableArray *)queryWithNote
{
    __block FinishData *finishNote;
    
    //define memo array
    __block NSMutableArray *memoArray = nil;
    
    // typical code for using fmdb
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         // init memo array
         memoArray = [NSMutableArray array];
         
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from finishnote"];
         
         while (rs.next)
         {
             
             finishNote = [[FinishData alloc]init];
             
             finishNote.ids = [rs intForColumn:@"ids"];
             finishNote.data = [rs stringForColumn:@"data"];
             finishNote.setTime = [rs stringForColumn:@"settime"];
             finishNote.finTime = [rs stringForColumn:@"fintime"];

             
             [memoArray addObject:finishNote];
             
         }
     }];
    
    // 3.返回数据
    return memoArray;
}

+(void)insertNote:(FinishData *)finishNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into finishnote(data,settime,fintime) values(?,?,?)",finishNote.data,finishNote.setTime,finishNote.finTime];
     }];
}

+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"delete from finishnote where ids = ?",[NSNumber numberWithInt:ids]];
     }];
}

+(void)updateNote:(FinishData *)finishNote
{
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update finishnote set data = ?, fintime = ? where ids =?",finishNote.data,finishNote.finTime,[NSNumber numberWithInt:finishNote.ids]];
     }];
}

+(FinishData *)queryOneNote:(int)ids
{
    
    __block FinishData * finishNote;
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from finishnote where ids = ?",[NSNumber numberWithInt:ids]];
         while(rs.next)
         {
             finishNote = [[FinishData alloc] init];
             finishNote.ids  = [rs intForColumn:@"ids"];
             finishNote.data = [rs stringForColumn:@"data"];
             finishNote.setTime = [rs stringForColumn:@"settime"];
             finishNote.finTime = [rs stringForColumn:@"fintime"];
         }
     }];
    return finishNote;
}


@end
