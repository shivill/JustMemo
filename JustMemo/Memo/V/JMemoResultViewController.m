//
//  JMemoResultViewController.m
//  JustMemo
//
//  Created by shivill on 2018/12/18.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "JMemoViewController.h"
#import "JMemoResultViewController.h"
#import "JMemoEditViewController.h"
#import "JMemoData.h"

@interface JMemoResultViewController ()

@property (nonatomic,strong) JMemoData *jMemoData;
@end

@implementation JMemoResultViewController

- (void)setSearchResult:(NSMutableArray *)searchResult
{
    _searchResult = searchResult;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"now at tableview");
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //query for data first
    self.jMemoData = self.searchResult[([self.searchResult count] - 1 -[indexPath row])];
    
//    //for time label in cell
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 200, 30)];
//    timeLabel.text = self.jMemoData.setTime;
//    timeLabel.textColor = [UIColor grayColor];
    
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
    //[cell.contentView addSubview:timeLabel];
    
    //for cell searchresult text label
    //cell.textLabel.font = [UIFont systemFontOfSize:SIZE_FOR_MAIN_TEXT];
    cell.textLabel.text = self.jMemoData.data;
    
    

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.jMemoData = self.searchResult[([self.searchResult count] - 1 -[indexPath row])];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.resultDelegate respondsToSelector:@selector(pushToEditView:)])
    {
        NSLog(@"call delegate ");
        [self.resultDelegate pushToEditView:self.jMemoData];
    }
//    JMemoEditViewController *editView= [[JMemoEditViewController alloc] init];
//
//
//    self.hidesBottomBarWhenPushed = YES;
    
//    editView.ids = self.jMemoData.ids;
//    NSLog(@"ppto edit view");
//    UINavigationController *tempNavCon = [[UINavigationController alloc] init];
//    tempNavCon = self.presentingViewController;
////    if( isKindOfClass:[JMemoResultViewController class]])
////        NSLog(@"yes");
//        //NSLog(@"failed to find navicon");
//    NSLog(@"navi view controller = %@",tempNavCon);
//    NSLog(@"present view controller = %@",self.presentingViewController);
//
//    [tempNavCon pushViewController:editView animated:YES];
//    NSLog(@"now push to edit done");

}



@end
