//
//  FinishDetailViewController.m
//  JustMemo
//
//  Created by shivill on 2018/11/18.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import "FinishDetailViewController.h"
#import "FinishData.h"

@interface FinishDetailViewController()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UITextView *textView;
@property (nonatomic,strong) FinishData *finishData;
@property (nonatomic,strong) NSMutableArray *queryData;
@property (nonatomic,strong) NSString *setTime;
@property (nonatomic,strong) NSString *finTime;

@end

@implementation FinishDetailViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //color for navigation bar
    [self navColor];
    
    [self preLoadData];
    
    //add textview
    [self initTextView];
    
    [self timeView];
}
- (void)viewWillAppear:(BOOL)animated
{
    //init contend of textview
    self.textView.text = self.finishData.data;
}

- (void)navColor
{
    UIView * navColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navColor.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    [self.view addSubview:navColor];
}



#pragma mark - load database data
- (void)preLoadData
{
    self.finishData = [self.finishData queryOneNote:self.ids];
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
    //In Detail mode ,text cannot be edited
    textView.editable = NO;
    
    self.textView = textView;
    
    //what does it meant?
    //self.textView.delegate = self;
    
    [self.view addSubview:textView];
    
    
}

- (void)timeView
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-10*2, 30)];
    
    NSDateFormatter *nsDateFmt = [[NSDateFormatter alloc] init];
    [nsDateFmt setDateFormat:@"Finished at YYYY/MM/dd  HH:mm:ss"];
    
    timeLabel.text = self.finishData.finTime;
    
    [self.view addSubview:timeLabel];
}

@end
