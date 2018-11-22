//
//  JMemoViewController.m
//  JustMemo
//
//  Created by shivill on 2018/10/19.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import "JMemoViewController.h"
#import "JMemoData.h"
#import "JMemoAddViewController.h"
#import "JMemoEditViewController.h"

#import "FinishData.h"

@interface JMemoViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BackDelegate>

@property (nonatomic,weak) UITableView *memoView;
@property (nonatomic,weak) UIButton *addButton;

//database data
@property (nonatomic,strong) JMemoData *jMemoData;
@property (nonatomic,strong) FinishData *finishData;
//array for data
@property (nonatomic,strong) NSMutableArray *queryData;


@end

@implementation JMemoViewController

- (void)returnToPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (JMemoData *)jMemoData
{
    if(_jMemoData == nil)
    {
        _jMemoData = [[JMemoData alloc] init];
    }
    return _jMemoData;
}

- (FinishData *)finishData
{
    if(_finishData == nil)
    {
        _finishData = [[FinishData alloc] init];
    }
    return _finishData;
}

- (NSMutableArray *)queryData
{
    if(_queryData == nil)
    {
        _queryData = [NSMutableArray array];
    }
    return _queryData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *memoView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height -10 ) style:UITableViewStylePlain];
    memoView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    memoView.separatorColor = [UIColor grayColor];
    memoView.delegate = self;
    memoView.dataSource = self;
    
    self.memoView = memoView;
    
    [self.view addSubview:memoView];

    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0.5*(self.view.frame.size.width-48), self.view.frame.size.height-100, 48, 48)];
    [addButton setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addOneMemo:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    [self.view addSubview:addButton];
    self.queryData = [self.jMemoData queryWithData];

    //for debug  to get database localtion of sandbox
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//    NSString* strDocDir = [paths objectAtIndex:0];
//    NSLog(@"%@",strDocDir);
    
    
    
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.queryData = [self.jMemoData queryWithData];
    [self.memoView reloadData];
}



- (void)addOneMemo:(UIImageView *)add
{
    [UIImageView animateWithDuration:0 animations:^{
        ;
    } completion:^(BOOL finished){
        JMemoAddViewController *toAddVC = [[JMemoAddViewController alloc] init];

        [self presentViewController:toAddVC animated:YES completion:^{
            add.layer.transform = CATransform3DIdentity;
            add.alpha = 1;
        }];
    }];
}


#pragma mark - method for tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.queryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //query for data first
    self.jMemoData = self.queryData[[indexPath row]];
    
    //for time label in cell
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 200, 30)];
    timeLabel.text = self.jMemoData.setTime;
    timeLabel.textColor = [UIColor grayColor];
    
    static NSString *MemoID = @"MemoID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MemoID];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemoID];
    }
    else
    {
        //remove contents of this cell,in order to avoid overlapping of subviews
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //timeLabel.tag = indexPath.row;
    [cell.contentView addSubview:timeLabel];

    //for cell main text label
    cell.textLabel.font = [UIFont systemFontOfSize:SIZE_FOR_MAIN_TEXT];
    cell.textLabel.text = self.jMemoData.data;

    
    //for finish button in cell
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 35, 30, 30)];
    finishBtn.backgroundColor = [UIColor blueColor];
    finishBtn.tag = self.jMemoData.ids;
    
    [finishBtn addTarget:self action:@selector(finishThisMemo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell.contentView addSubview:finishBtn];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //get memo data which is selected
        self.jMemoData = [self.queryData objectAtIndex:[indexPath row]];
        

        
        //delete this memo in jmemodata
        [self.jMemoData deleteData:self.jMemoData.ids];
        
        self.queryData = [self.jMemoData queryWithData];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JMemoEditViewController *editView= [[JMemoEditViewController alloc] init];
    
    self.jMemoData = self.queryData[[indexPath row]];
    
    self.hidesBottomBarWhenPushed = YES;
    
    editView.ids = self.jMemoData.ids;
    editView.backDelegate = self;

    [self.navigationController pushViewController:editView animated:YES];
    self.hidesBottomBarWhenPushed = NO;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - selector for finish-button

- (void)finishThisMemo:(UIButton *)btn
{
    self.jMemoData = [self.jMemoData queryOneNote:(int)btn.tag];
    //get current time with date-formatter
    NSDateFormatter *nsDateFmt = [[NSDateFormatter alloc] init];
    [nsDateFmt setDateFormat:@"YYYY/MM/dd  HH:mm:ss"];
    
    NSDate *editTime = [[NSDate alloc] init];
    
    NSString *currentTime = [nsDateFmt stringFromDate:editTime];
    
    //move this memo to finish view
    self.finishData.setTime = self.jMemoData.setTime;
    self.finishData.finTime = currentTime;
    self.finishData.data    = self.jMemoData.data;
    [self.finishData insertData:self.finishData];
    
    //delete this memo in jmemodata
    [self.jMemoData deleteData:self.jMemoData.ids];
    
    self.queryData = [self.jMemoData queryWithData];
    
    
    //to delete this memo in view. refresh memoView
    [self.memoView reloadData];

}

@end

