//
//  JMemoTool.m
//  JustMemo
//
//  Created by shivill on 2018/10/23.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import "JMemoTool.h"
#import "JMemoData.h"
#import "FMDB.h"

@implementation JMemoTool

static FMDatabaseQueue *_queue;

+ (void)initialize
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

}

+(NSMutableArray *)queryWithNote
{
    __block JMemoData *jMemoNote;
    
    //define memo array
    __block NSMutableArray *memoArray = nil;
    
    // typical code for using fmdb
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         // init memo array
         memoArray = [NSMutableArray array];
         
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from jmemonote"];
         
         while (rs.next)
         {
             
             jMemoNote = [[JMemoData alloc]init];
             
             jMemoNote.ids = [rs intForColumn:@"ids"];
             jMemoNote.data = [rs stringForColumn:@"data"];
             jMemoNote.setTime = [rs stringForColumn:@"settime"];

             
             [memoArray addObject:jMemoNote];
             
         }
     }];
    
    // 3.返回数据
    return memoArray;
}

+(void)insertNote:(JMemoData *)jMemoNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into jmemonote(data,settime) values(?,?)",jMemoNote.data,jMemoNote.setTime];
     }];
}

+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"delete from jmemonote where ids = ?",[NSNumber numberWithInt:ids]];
     }];
}

+(void)updateNote:(JMemoData *)jMemoNote
{

    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update jmemonote set data = ?, settime = ? where ids =?",jMemoNote.data,jMemoNote.setTime,[NSNumber numberWithInt:jMemoNote.ids]];
     }];
}

+(JMemoData *)queryOneNote:(int)ids
{
    
    __block JMemoData * jMemoData;
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;

         rs = [db executeQuery:@"select * from jmemonote where ids = ?",[NSNumber numberWithInt:ids]];
         while(rs.next)
         {
             jMemoData = [[JMemoData alloc] init];
             jMemoData.ids  = [rs intForColumn:@"ids"];
             jMemoData.data = [rs stringForColumn:@"data"];
             jMemoData.setTime = [rs stringForColumn:@"settime"];
         }
     }];
    return jMemoData;
}


@end
