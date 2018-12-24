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
#import "JMemoResultViewController.h"

#import "FinishData.h"

@interface JMemoViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,BackDelegate,ResultDelegate>

@property (nonatomic,weak) UITableView *memoView;
@property (nonatomic,weak) UIButton *addButton;

//for editing mode
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) UIBarButtonItem *editBtn;
@property (nonatomic,strong) UIBarButtonItem *delBtn;
@property (nonatomic,strong) UIBarButtonItem *cancleBtn;

//for uisearchbar
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) JMemoResultViewController *resultVC;


@property (nonatomic) CGPoint startPoint;
@property (nonatomic,strong) UITableView *searchTable;



//database data
@property (nonatomic,strong) JMemoData *jMemoData;
@property (nonatomic,strong) FinishData *finishData;
@property (nonatomic,strong) JMemoData *searchData;
//array for data
@property (nonatomic,strong) NSMutableArray *queryData;
@property (nonatomic,strong) NSMutableArray *searchResult;


@end

@implementation JMemoViewController

#pragma mark - method for returndelegate
- (void)returnToPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - method for resultdelegate
-(void)pushToEditView:(JMemoData *)jMemoData
{
    NSLog(@"on delegate");
    JMemoEditViewController *editView= [[JMemoEditViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    editView.jMemoData = jMemoData;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:editView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    NSLog(@"delegate over");
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
    NSLog(@"now navc = %@",self.navigationController);
    self.startPoint = CGPointMake(0, -64); //important
    //for main memo view
    UITableView *memoView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIGHT_ABOVE_TABLEVIEW,self.view.frame.size.width,self.view.frame.size.height -10-HIGHT_ABOVE_TABLEVIEW ) style:UITableViewStylePlain];
    memoView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    memoView.separatorColor = [UIColor grayColor];
    memoView.delegate = self;
    memoView.dataSource = self;
    memoView.allowsMultipleSelectionDuringEditing = YES;
    
    self.memoView = memoView;
    
    [self.view addSubview:memoView];

    //for add button
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
    
    
    //init uibarbuttonitem with eidt/delete button
    self.editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView:)];
    self.delBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTableView:)];
    self.cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleEdit:)];
    self.navigationItem.rightBarButtonItem = self.editBtn;


    [self initSearchView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.queryData = [self.jMemoData queryWithData];
    [self.memoView reloadData];
}

#pragma mark - code for search view

- (void)initSearchView
{
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
////    searchBar.delegate = self;
//    searchBar.placeholder = @"Type Keyword Here......";
//
//    self.searchBar = searchBar;
//
//    //[self.memoView addSubview:searchBar];
    //for searchController & its searchbar inside
    self.resultVC = [[JMemoResultViewController alloc] init];
    self.resultVC.resultDelegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.placeholder = @"Type here...";
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    
    //解决：退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    
    [self unloadSearchView];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"update result");
    
    //NSMutableArray *sourceData = [NSMutableArray array];

    
    
    NSString *searchString = searchController.searchBar.text;
    // 谓词
    /**
     1.BEGINSWITH ： 搜索结果的字符串是以搜索框里的字符开头的
     2.ENDSWITH   ： 搜索结果的字符串是以搜索框里的字符结尾的
     3.CONTAINS   ： 搜索结果的字符串包含搜索框里的字符
     
     [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
     
     */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"data CONTAINS [CD] %@",searchString];
    
    //if there are words in the searchbar,searching with these words
    //else return the origin database result;
    if(_searchResult != nil && searchString.length > 0)
    {
        //clean search result for next search
        [_searchResult removeAllObjects];
        _searchResult = [NSMutableArray arrayWithArray:[self.queryData filteredArrayUsingPredicate:predicate]];
        //_searchResult = [NSMutableArray arrayWithArray:self.queryData];
        NSLog(@"search now result num= %lu",(unsigned long)_searchResult.count);

    }
    else
    {
        _searchResult = [NSMutableArray arrayWithArray:self.queryData];
        NSLog(@"return normal");
    }
    
    self.resultVC.searchResult = _searchResult;
    
}

- (void)loadSearchView
{
    self.memoView.tableHeaderView = self.searchController.searchBar;
}

- (void)unloadSearchView
{
    self.memoView.tableHeaderView = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat distance = scrollView.contentOffset.y - self.startPoint.y;
    if(fabs(distance) >= 10)
    {

        if(self.memoView.tableHeaderView != nil && distance>0 && self.startPoint.y >=-64)
        {
            [self unloadSearchView];
        }
        //else if(self.memoView.tableHeaderView == nil && distance<0 && scrollView.contentOffset.y <=-150)//self.startPoint.y <= -64 )
        else if(self.memoView.tableHeaderView == nil && distance<0 && self.startPoint.y <= -64 )
        {
            [self loadSearchView];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startPoint = scrollView.contentOffset;
}

#pragma mark - selector for edit barbutton
- (void)editTableView:(id)sender
{
    [self.memoView setEditing:YES animated:YES];
    
    self.navigationItem.leftBarButtonItem  = self.cancleBtn;
    self.navigationItem.rightBarButtonItem = self.delBtn;
    
}

#pragma mark - selector for delete barbutton
- (void)deleteTableView:(id)sender
{
    
    //[self.queryData removeObjectsInArray:self.deleteArray];
    for(JMemoData *finData in self.deleteArray)
    {
        [self.jMemoData deleteData:finData.ids];
    }
    
    [self.memoView setEditing:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = self.editBtn;
    
    self.queryData = [self.jMemoData queryWithData];
    
    [self.memoView reloadData];
}
#pragma mark - selector for cancle barbutton
- (void)cancleEdit:(id)sender
{
    [self.memoView setEditing:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = self.editBtn;
    self.deleteArray = nil;
    
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
    self.jMemoData = self.queryData[([self.queryData count] - 1 -[indexPath row])];
    
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

//remove edit-button while sliding to left
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem = nil;
}

//add edit-button when canceled
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem = self.editBtn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.jMemoData = self.queryData[([self.queryData count] - 1 -[indexPath row])];

    if(self.memoView.isEditing == NO)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        JMemoEditViewController *editView= [[JMemoEditViewController alloc] init];
    
    
        self.hidesBottomBarWhenPushed = YES;
    
        editView.jMemoData = self.jMemoData;
        editView.backDelegate = self;
        [self.navigationController pushViewController:editView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if(self.memoView.isEditing == YES)
    {
        [self.deleteArray addObject:self.jMemoData];
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.memoView.isEditing == YES)
    {
        [self.deleteArray removeObject:self.jMemoData];
    }
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

