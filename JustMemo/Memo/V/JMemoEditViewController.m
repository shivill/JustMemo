//
//  JMemoEditViewController.m
//  JustMemo
//
//  Created by shivill on 2018/11/4.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "JMemoEditViewController.h"
#import "JMemoData.h"

@interface JMemoEditViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UITextView *textView;
@property (nonatomic,strong) JMemoData *jMemoData;
@property (nonatomic,strong) NSMutableArray *queryData;
@property (nonatomic,strong) NSString *setTime;

@end

@implementation JMemoEditViewController

- (JMemoData *)jMemoData
{
    if(_jMemoData == nil)
    {
        _jMemoData = [[JMemoData alloc] init];
    }
    return _jMemoData;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //color for navigation bar
    [self navColor];
    
    //save button to save memo data
    [self saveBtn];
    
    [self preLoadData];
    
    //add textview
    [self initTextView];
    
    [self timeView];
}
- (void)viewWillAppear:(BOOL)animated
{
    //init contend of textview
    self.textView.text = self.jMemoData.data;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //get current time with date-formatter
    NSDateFormatter *nsDateFmt = [[NSDateFormatter alloc] init];
    [nsDateFmt setDateFormat:@"YYYY/MM/dd  HH:mm:ss"];
    
    NSDate *editTime = [[NSDate alloc] init];
    
    NSString *currentTime = [nsDateFmt stringFromDate:editTime];
    
    //save datas to database
//    NSLog(@"data=%@,cnt=%lu",self.jMemoData.data,(unsigned long)[self.jMemoData.data length]);
//    NSLog(@"text=%@,cnt=%lu",self.textView.text,(unsigned long)[self.textView.text length]);

    if(![self.jMemoData.data isEqualToString:self.textView.text])
    {
        self.jMemoData.data = self.textView.text;
        self.jMemoData.setTime = currentTime;
    }
    [self.jMemoData updateData:self.jMemoData];
}

- (void)navColor
{
    UIView * navColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navColor.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    [self.view addSubview:navColor];
}


#pragma mark - save button & save

- (void)saveBtn
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [saveBtn setFrame:CGRectMake(self.view.frame.size.width -65, 30, 60, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];

    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    saveBtn.tintColor = [UIColor blackColor];

    [saveBtn addTarget:self action:@selector(saveText:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:saveBtn];
}

- (void)saveText:(id)sender
{
    self.jMemoData.data = self.textView.text;
    NSLog(@"for debug ,back to nav vc");

    if([self.backDelegate respondsToSelector:@selector(returnToPreView)])
    {
        [self.backDelegate returnToPreView];
    }
    //[self.jMemoData insertDatas:self.jMemoData];

    //back after saving

}

#pragma mark - load database data
- (void)preLoadData
{
    self.jMemoData = [self.jMemoData queryOneNote:self.ids];
}

#pragma mark - set text view
- (void)initTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, self.view.frame.size.height - 130)];
    
    textView.font = [UIFont systemFontOfSize:18];
    textView.layer.borderWidth = 1.5;
    textView.layer.borderColor = [[UIColor blackColor] CGColor];
    textView.layer.cornerRadius = 4.0f;
    textView.layer.masksToBounds = YES;
    //be able to bouceback at vertical
    textView.alwaysBounceVertical = YES;
    //first charactor,not capital
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.textView = textView;
    
    //what does it meant?
    //self.textView.delegate = self;
    
    [self.view addSubview:textView];
    
    
}

- (void)timeView
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-10*2, 30)];
    
    NSDateFormatter *nsDateFmt = [[NSDateFormatter alloc] init];
    [nsDateFmt setDateFormat:@"YYYY/MM/dd  HH:mm:ss"];
    
    timeLabel.text = self.jMemoData.setTime;
    
    [self.view addSubview:timeLabel];
}

@end
