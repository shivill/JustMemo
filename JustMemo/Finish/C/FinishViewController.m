//
//  FinishViewController.m
//  JustMemo
//
//  Created by shivill on 2018/11/18.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "FinishViewController.h"
#import "FinishData.h"
#import "FinishDetailViewController.h"

@interface FinishViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UITableView *finishView;
@property (nonatomic,weak) UIButton *addButton;

//for editing mode
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) UIBarButtonItem *editBtn;
@property (nonatomic,strong) UIBarButtonItem *delBtn;
@property (nonatomic,strong) UIBarButtonItem *cancleBtn;

//database data
@property (nonatomic,strong) FinishData *finishData;
//array for data
@property (nonatomic,strong) NSMutableArray *queryData;


@end

@implementation FinishViewController




- (void)returnToPreView
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)deleteArray
{
    if(_deleteArray == nil)
    {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init tableview
    UITableView *finishView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIGHT_ABOVE_TABLEVIEW,self.view.frame.size.width,self.view.frame.size.height -10-HIGHT_ABOVE_TABLEVIEW ) style:UITableViewStylePlain];
    finishView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    finishView.separatorColor = [UIColor grayColor];
    finishView.delegate = self;
    finishView.dataSource = self;
    finishView.allowsMultipleSelectionDuringEditing = YES;
    
    self.finishView = finishView;
    
    [self.view addSubview:finishView];
    
    //init uibarbuttonitem with eidt/delete button
    self.editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView:)];
    self.delBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTableView:)];
    self.cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleEdit:)];
    self.navigationItem.rightBarButtonItem = self.editBtn;

    self.queryData = [self.finishData queryWithData];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.queryData = [self.finishData queryWithData];
    [self.finishView reloadData];
}

#pragma mark - selector for edit barbutton
- (void)editTableView:(id)sender
{
    [self.finishView setEditing:!self.finishView.isEditing animated:YES];
    
    self.navigationItem.leftBarButtonItem  = self.cancleBtn;
    self.navigationItem.rightBarButtonItem = self.delBtn;

}

#pragma mark - selector for delete barbutton
- (void)deleteTableView:(id)sender
{

    //[self.queryData removeObjectsInArray:self.deleteArray];
    for(FinishData *finData in self.deleteArray)
    {
        [self.finishData deleteData:finData.ids];
    }
    
    [self.finishView setEditing:!self.finishView.isEditing animated:YES];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = self.editBtn;

    self.queryData = [self.finishData queryWithData];
    
    [self.finishView reloadData];
}
#pragma mark - selector for cancle barbutton
- (void)cancleEdit:(id)sender
{
    [self.finishView setEditing:!self.finishView.isEditing animated:YES];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = self.editBtn;

}


#pragma mark - methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.queryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //query for data first
    self.finishData = self.queryData[([self.queryData count] - 1 -[indexPath row])];
    
    //for time label in cell
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 200, 30)];
    timeLabel.text = self.finishData.finTime;
    timeLabel.textColor = [UIColor grayColor];
    
    static NSString *finishID = @"finishID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:finishID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:finishID];
    }
    else
    {
        //remove contents of this cell,in order to avoid overlapping of subviews
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }

    //to add time label
    [cell.contentView addSubview:timeLabel];


    //for cell main text label
    cell.textLabel.font = [UIFont systemFontOfSize:SIZE_FOR_MAIN_TEXT];
    cell.textLabel.text = self.finishData.data;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //get memo data which is selected
        self.finishData = [self.queryData objectAtIndex:[indexPath row]];
        

        //delete this memo in jmemodata
        [self.finishData deleteData:self.finishData.ids];
        
        self.queryData = [self.finishData queryWithData];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.finishData = self.queryData[([self.queryData count] - 1 -[indexPath row])];

    if(self.finishView.isEditing == NO)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        FinishDetailViewController *editView= [[FinishDetailViewController alloc] init];

        self.hidesBottomBarWhenPushed = YES;

        editView.ids = self.finishData.ids;

        [self.navigationController pushViewController:editView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if(self.finishView.isEditing == YES)
    {
        [self.deleteArray addObject:self.finishData];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.finishView.isEditing == YES)
    {
        [self.deleteArray removeObject:self.finishData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
